async               = require 'async'
request             = require 'request'
timeExtractor       = require './time_extractor'
util                = require './processor_util'
pushGrapevineEvents = util.pushGrapevineEvents
isFutureEvent       = util.isFutureEvent
updateLastPulled    = util.updateLastPulled

exports.extractAndSendEvents = (feed) ->

  numOfNewEventsToPull = 100

  getFBFeedPosts = (next) ->
    since = if feed.last_pulled > 0 then feed.last_pulled else ''
    request "#{process.env.SOCIAL_MEDIA_API_HOST}/facebook/posts/#{feed.feed_name}/#{since}", (err, res, body) ->
      throw err if err
      posts = JSON.parse(body)?.data
      # Since FB events can't be filtered by the time they were created (but FB posts can be),
      # we count how many of the newest created posts pulled are events.
      # We can then just pull the appropriate number of events in getFBFeedEvents().
      numOfNewEventsToPull = (posts.filter (post) -> post.message?.indexOf 'added an event.' >= 0).length
      next posts

  getFBFeedEvents = (next) ->
    request "#{process.env.SOCIAL_MEDIA_API_HOST}/facebook/events/#{feed.feed_name}/#{numOfNewEventsToPull}", (err, res, body) ->
      throw err if err
      next JSON.parse(body)?.data

  extractGrapevineEventsFromPosts = (next) ->
    (posts) ->
      grapevineEvents = []
      for post in posts
        extractedTimeAttributes = timeExtractor.extractTimeAttributes post.message, post.created_time
        if extractedTimeAttributes
          # we consider a post to be an event if we were able to extract a date/time from it
          grapevineEvent = extractedTimeAttributes
          if isFutureEvent grapevineEvent
            grapevineEvent.url = ((id) ->
              [user, post] = id.split("_")
              "https://www.facebook.com/#{user}/posts/#{post}")(post.id)
            grapevineEvent.feedID = feed.feed_id
            grapevineEvent.tags = [] # TODO
            grapevineEvents.push grapevineEvent
      next grapevineEvents

  extractGrapevineEventsFromFBEvents = (next) ->
    (FBevents) ->
      grapevineEvents = []
      for FBevent in FBevents
        startTime = new Date(FBevent.start_time).getTime()
        if (startTime > new Date().getTime())
          grapevineEvents.push
            timeProcessed: new Date().getTime()
            location: getLocationInfo FBevent
            isAllDay: FBevent.end_time?
            startTime: startTime
            endTime: if FBevent.end_time then new Date(FBevent.end_time).getTime() else null
            post: FBevent.description
            url: "https://www.facebook.com/events/#{FBevent.id}"
            feedID: feed.feed_id
            title: FBevent.name
            tags: [] #TODO: CLASSIFIER WORK HERE
      next grapevineEvents

  async.series [
    (callback) -> getFBFeedPosts extractGrapevineEventsFromPosts pushGrapevineEvents callback
    (callback) -> getFBFeedEvents extractGrapevineEventsFromFBEvents pushGrapevineEvents callback
  ], (err) ->
    throw err if err
    updateLastPulled {feed}, (err) ->
      throw err if err
      console.log "extracted events from posts and events of FB feed #{feed.feed_name},
                   sent events to Grapevine,
                   and updated time when feed was last pulled from"

getLocationInfo = (FBevent) ->
  [FBevent.place?.name or '_',
   FBevent.place?.location?.country or '_',
   FBevent.place?.location?.state or '_',
   FBevent.place?.location?.city or '_',
   FBevent.place?.location?.street or '_']