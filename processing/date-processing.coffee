# load environment variables
dotenv         = require 'dotenv-with-overload'
dotenv._getKeysAndValuesFromEnvFilePath "#{__dirname}/.env"
dotenv._setEnvs()
async = require 'async'
request = require 'request'
intervalInSeconds = 10
socialMediaAPIHost = 'http://localhost:3000'
databaseAPI = 'http://localhost:8000/'
chrono = require 'chrono-node'
async = require 'async'

exports.sendEventsFromFBFeed = (feed) ->

  getFBFeedPosts = (next) ->
    request "#{socialMediaAPIHost}/facebook/posts/#{feed.feed_name}", (err, res, body) ->
      throw err if err
      next JSON.parse(body)?.data

  getFBFeedEvents = (next) ->
    request "#{socialMediaAPIHost}/facebook/events/#{feed.feed_name}", (err, res, body) ->
      throw err if err
      next JSON.parse(body)?.data

  extractGrapevineEventsFromPosts = (next) ->
    (posts) ->
      grapevineEvents = []
      for post in posts
        extractedTimeAttributes = getTimeAttributes post.message, post.created_time
        if extractedTimeAttributes
          # we consider a post to be an event if we were able to extract date/time info from it
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
        if (new Date(FBevent.start_time).getTime() > new Date().getTime())
          grapevineEvents.push
            timeProcessed: new Date().getTime()
            location: getFBEventLocation FBevent
            isAllDay: FBevent.end_time?
            startTime: new Date(FBevent.start_time).getTime()
            endTime:   if FBevent.end_time then new Date(FBevent.end_time).getTime() else null
            post: FBevent.description
            url: "https://www.facebook.com/events/#{FBevent.id}"
            feedID: feed.feed_id
            title: FBevent.name
            tags: [] #TODO: CLASSIFIER WORK HERE
      next grapevineEvents

  # THE MEAT AND POTATOES!
  async.parallel [
    (callback) -> getFBFeedPosts extractGrapevineEventsFromPosts pushGrapevineEvents callback
    (callback) -> getFBFeedEvents extractGrapevineEventsFromFBEvents pushGrapevineEvents callback
  ], (err) ->
    console.log err if err

exports.sendEventsFromTwitterList = (list) ->

  getTweets = (next) ->
    request "#{socialMediaAPIHost}/twitter/list/#{list.list_id}", (err, res, body) ->
      throw err if err
      next JSON.parse body

  extractGrapevineEventsFromTweets = (next) ->
    (tweets) ->
      grapevineEvents = []
      for tweet in tweets
        extractedTimeAttributes = getTimeAttributes tweet.text, tweet.created_at
        if extractedTimeAttributes
          # we consider a tweet to be an event if we extract time info from it
          grapevineEvent = extractedTimeAttributes
          if isFutureEvent grapevineEvent
            grapevineEvent.feedID = 45
            #TODO: event URL?
            grapevineEvents.push grapevineEvent
      next grapevineEvents

  getTweets extractGrapevineEventsFromTweets pushGrapevineEvents -> console.log 'done'

exports.sendEventsFromTwitterFeed = (feed) ->

  getTweets = (next) ->
    request "#{socialMediaAPIHost}/twitter/posts/#{feed.feed_name}", (err, res, body) ->
      throw err if err
      next JSON.parse body

  extractGrapevineEventsFromTweets = (next) ->
    (tweets) ->
      grapevineEvents = []
      console.log "TWEETS #{JSON.stringify tweets}"
      for tweet in tweets
        console.log "TWEET #{JSON.stringify tweet}"
        extractedTimeAttributes = getTimeAttributes tweet.text, tweet.created_at
        if extractedTimeAttributes
          console.log "extractedTimeAttributes #{JSON.stringify extractedTimeAttributes}"
          # we consider a tweet to be an event if we extract time info from it
          grapevineEvent = extractedTimeAttributes
          if isFutureEvent grapevineEvent
            grapevineEvent.feedID = tweet.user.id
            grapevineEvents.push grapevineEvent
      next grapevineEvents

  getTweets extractGrapevineEventsFromTweets pushGrapevineEvents -> console.log 'done'

getLoginToken = (callback) ->
  request
    url: "#{databaseAPI}api/v1/tokens"
    method: 'POST'
    headers: 'content-type': 'application/json'
    body: JSON.stringify {username: process.env.USERNAME, password: process.env.PASSWORD}
  , (err, response, body) ->
    return callback err if err
    callback null, (JSON.parse body).token

isFutureEvent = (event) ->
  currentTime = (new Date).getTime()
  event.startTime > currentTime or event.endTime > currentTime

getFBEventLocation = (FBevent) ->
  [FBevent.place?.name,
   FBevent.place?.location?.country,
   FBevent.place?.location?.state,
   FBevent.place?.location?.city,
   FBevent.place?.location?.street]

pushGrapevineEvents = (callback) ->
  (grapevineEvents) ->
    getLoginToken (err, token) ->
      request
        url: "#{databaseAPI}admin/v1/events"
        method: 'POST'
        headers:
          'content-type': 'application/json'
          'x-access-token': token
        body: JSON.stringify({'events': grapevineEvents})
      , (err, response, body) ->
        return callback err if err
        callback null, 'message' : 'done pushing events'

getTimeAttributes = (text, timeCreated) ->
  # chrono extracts relative date information given the post and the time the post was created
  # ('tomorrow' means something different depending on when the post was created)
  parsedDates = chrono.parse text, new Date timeCreated
  if parsedDates.length > 0
    #TODO: fix this hack
    chronosDateInfo = parsedDates[parsedDates.length - 1]
    post:           text
    timeProcessed:  new Date().getTime()
    chronosOutput:  JSON.stringify chronosDateInfo
    isAllDay:       not chronosDateInfo.start.knownValues.hour?
    endTimeIsKnown: chronosDateInfo.end?
    startTime:      chronosDateInfo.start.date().getTime()
    endTime:        chronosDateInfo.end?.date().getTime()
  else
    null
