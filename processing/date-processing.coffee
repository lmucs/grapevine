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

getEventsFromFBFeed = (feed) ->

  getFBFeedPosts = (next) ->
    request "#{socialMediaAPIHost}/facebook/posts/#{feed.feed_name}", (err, res, body) ->
      throw err if err
      next JSON.parse(body)?.data

  getFBFeedEvents = (next) ->
    request "#{socialMediaAPIHost}/facebook/events/#{feed.feed_name}", (err, res, body) ->
      console.log "EVENTS: #{body}"
      throw err if err
      events = JSON.parse(body)?.data
      eventInfoToPost = []
      currentTime = new Date().getTime()
      for FBevent in events
        startTime = new Date(FBevent.start_time).getTime()
        endTime = if FBevent.end_time then new Date(FBevent.end_time).getTime() else 0
        console.log "FBevent #{JSON.stringify FBevent}"
        console.log "FUTURE #{startTime > currentTime or endTime > currentTime}"
        if startTime > currentTime or endTime > currentTime
          eventInfoToPost.push
            timeProcessed: new Date().getTime()
            location: [FBevent.place?.name, FBevent.place?.location?.country, FBevent.place?.location?.state, FBevent.place?.location?.city, FBevent.place.location?.street]
            # startTimeIsKnown: null
            # endTimeIsKnown: null
            startTime: startTime
            endTime: endTime
            post: FBevent.description
            # url: postInfo.url
            # author: postInfo.author
            # processedInfo: ""
            feedID: feed.feed_id
            title: FBevent.title
            tags: [] #TODO: CLASSIFIER WORK HERE
      next eventInfoToPost

  extractEventsFromPosts = (next) ->
    (posts) ->
      events = []
      for post in posts
        postText = post.message or ''
        url = getFacebookURL(post.id)
        postInfo = {author:feed.feed_name, url}
        eventInfoToPost = extractEvents postText, postInfo, feed.feed_id, post.created_time
        events.push eventInfoToPost if eventInfoToPost
      next events

  getFBFeedPosts extractEventsFromPosts pushEvents done
  getFBFeedEvents pushEvents done
  # TODO: update pull time

getLoginToken = (callback) ->
  request
    url: "#{databaseAPI}api/v1/tokens"
    method: 'POST'
    headers: 'content-type': 'application/json'
    body: JSON.stringify {username: process.env.USERNAME, password: process.env.PASSWORD}
  , (err, response, body) ->
    return callback err if err
    callback null, (JSON.parse body).token

pushEvents = (callback) ->
  (events) ->
    getLoginToken (err, token) ->
      request
        url: "#{databaseAPI}admin/v1/events"
        method: 'POST'
        headers:
          'content-type': 'application/json'
          'x-access-token': token
        body: JSON.stringify({'events': events})
      , (err, response, body) ->
        throw err if err
        callback()

done = -> console.log 'done'

processRawTweets = (tweets, feedID) ->
  events = []
  for tweet in tweets
    tweetText = tweet.text
    author = tweet.user.screen_name
    url = getTwitterURL(author, tweet.id_str)
    tweetInfo = {url, author}
    events.push.apply events, extractEvents tweetText, tweetInfo, feedID, tweet.created_at
  events

getFacebookURL = (id) ->
  [user, post] = id.split("_")
  "https://www.facebook.com/#{user}/posts/#{post}"

getTwitterURL = (screenName, tweetID) ->
  "https://twitter.com/#{screenName}/status/#{tweetID}"

# Get rid of events that have already happened
extractEvents = (text, postInfo, feedID, createdTime) ->
  events = []
  parsedDates = chrono.parse text, new Date(createdTime)
  currentTime = (new Date).getTime()
  myEvent = null
  for date in parsedDates
    startDate = date.start.date()
    if startDate.getTime() > currentTime or true
      myEvent =
        timeProcessed: new Date().getTime()
        # startTimeIsKnown: date.start.knownValues.hour?
        # endTimeIsKnown: date.end?
        startTime: startDate.getTime()
        endTime: if date.end then date.end.date().getTime() else null
        post: text
        url: postInfo.url
        author: postInfo.author
        processedInfo: JSON.stringify date
        feedID: feedID
        tags: [] #TODO: CLASSIFIER WORK HERE
  myEvent
  # if myEvent then [myEvent] else []

exports.getEventsFromFBFeed = getEventsFromFBFeed

