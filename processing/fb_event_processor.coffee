async               = require 'async'
request             = require 'request'
timeExtractor       = require './time_extractor'
util                = require './processor_util'
pushGrapevineEvents = util.pushGrapevineEvents
isFutureEvent       = util.isFutureEvent

exports.extractAndSendEventsFromFeed = (feed) ->

  getFBFeedPosts = (next) ->
    request "#{process.env.SOCIAL_MEDIA_API_HOST}/facebook/posts/#{feed.feed_name}", (err, res, body) ->
      throw err if err
      next JSON.parse(body)?.data

  getFBFeedEvents = (next) ->
    request "#{process.env.SOCIAL_MEDIA_API_HOST}/facebook/events/#{feed.feed_name}", (err, res, body) ->
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
            location: [FBevent.place?.name, FBevent.place?.location?.country,
                       FBevent.place?.location?.state, FBevent.place?.location?.city,
                       FBevent.place?.location?.street]
            isAllDay: FBevent.end_time?
            startTime: startTime
            endTime: if FBevent.end_time then new Date(FBevent.end_time).getTime() else null
            post: FBevent.description
            url: "https://www.facebook.com/events/#{FBevent.id}"
            feedID: feed.feed_id
            title: FBevent.name
            tags: [] #TODO: CLASSIFIER WORK HERE
      next grapevineEvents

  async.parallel [
    (callback) -> getFBFeedPosts extractGrapevineEventsFromPosts pushGrapevineEvents callback
    (callback) -> getFBFeedEvents extractGrapevineEventsFromFBEvents pushGrapevineEvents callback
  ], (err) ->
    console.log err if err
