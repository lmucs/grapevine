# load environment variables
dotenv         = require 'dotenv-with-overload'
dotenv._getKeysAndValuesFromEnvFilePath "#{__dirname}/.env"
dotenv._setEnvs()

request = require 'request'
fs = require 'fs'
intervalInSeconds = 10
serverName = 'http://localhost:3000/'
databaseAPI = 'http://localhost:8000/'
twitterURL = 'twitter/posts/'
fbPostURL = 'facebook/posts/'
chrono = require 'chrono-node'
async = require 'async'


getEvents = ->
  request {url: "#{databaseAPI}/api/v1/tokens"} , (err, res) ->
    options =
      url: '#{databaseAPI}/api/v1/feeds'
      headers: 'x-access-token': res.body.token
    request options, (err, res) ->

getTwitterEvents = ->
  ids = []
  sinceID = null
  events = []
  async.series [
    (callback) ->
      ## Make API CAll
      ids = resultsOfCall.id
      sinceID = resultsOfCall.sinceID
      callback()
    (callback) ->
      getEventsFromTweets name, sinceID for id in ids
      callback()
  ]

getFBEvents = ->
  ids = []
  timeStamp = null
  events = []
  async.series [
    (callback) ->
      ## Make API CAll
      ids = resultsOfCall.id
      timeStamp = resultsOfCall.timeStamp
      callback()
    (callback) ->

      getEventsFromFBFeed name, timeStamp for id in ids
      callback()
  ]

setIntervalX = (callback, delay, repetitions) ->
  counter = 0
  intervalID = setInterval((->
    callback()
    if ++counter == repetitions
      clearInterval intervalID
    return
  ), delay)
  return

getEventsFromTweets = (networkName, feedName, sinceID) ->
  requestURL = "#{serverName}#{twitterURL}#{feedName}"
  requestURL += '/' + sinceID if sinceID
  request requestURL, (err, res, body) ->
    if res.statusCode is 200
      events = processRawTweets JSON.parse body
      request
        url: "#{databaseAPI}api/v1/tokens"
        method: 'POST'
        headers:
          'content-type': 'application/json'
        body: JSON.stringify {username: process.env.USERNAME, password: process.env.PASSWORD}
      , (err, response, body) ->
        throw err if err
        request
          url: "#{databaseAPI}admin/v1/events"
          method: 'POST'
          headers:
            'content-type': 'application/json'
            'x-access-token': (JSON.parse body).token
          body: JSON.stringify({'events': events})
        , (err, response, body) ->
          throw err if err
          console.log 'done-zo'

getEventsFromFBFeed = (screenName, timeStamp) ->
  requestURL = "#{serverName}#{fbPostURL}#{screenName}"
  requestURL += '/' + timeStamp if timeStamp
  request requestURL, (err, res, body) ->
    if res.statusCode is 200 and JSON.parse(body).data?
      rawPosts = JSON.parse(body).data
      events = processRawPosts rawPosts, screenName
      request
        url: "#{databaseAPI}api/v1/tokens"
        method: 'POST'
        headers:
          'content-type': 'application/json'
        body: JSON.stringify {username: process.env.USERNAME, password: process.env.PASSWORD}
      , (err, response, body) ->
        throw err if err
        request
          url: "#{databaseAPI}admin/v1/events"
          method: 'POST'
          headers:
            'content-type': 'application/json'
            'x-access-token': (JSON.parse body).token
          body: JSON.stringify({'events': events})
        , (err, response, body) ->
          throw err if err
          console.log 'done-zo'

writeEventsToFile = (events, path) ->
  for event in events
    fs.appendFile path, JSON.stringify(event, null, 4), (err) ->
      throw err if err

processRawTweets = (tweets) ->
  events = []
  for tweet in tweets
    tweetText = tweet.text
    author = tweet.user.screen_name
    url = getTwitterURL(author, tweet.id_str)
    tweetInfo = {url, author}
    events = [events..., extractEvents(tweetText, tweetInfo)...]
  events

processRawPosts = (posts, author) ->
  events = []
  for post in posts
    postText = post.message ? ""
    url = getFacebookURL(post.id)
    postInfo = {author, url}
    events = [events..., extractEvents(postText, postInfo)...]
  events

getFacebookURL = (id) ->
  [user, post] = id.split("_")
  "https://www.facebook.com/#{user}/posts/#{post}"

getTwitterURL = (screenName, tweetID) ->
  "https://twitter.com/#{screenName}/status/#{tweetID}"

# Get rid of events that have already happened
extractEvents = (text, postInfo) ->
  events = []
  parsedDates = chrono.parse text
  currentTime = (new Date).getTime()
  for date in parsedDates
    startDate = date.start.date()
    if startDate.getTime() > currentTime
      events.push
        timeProcessed: new Date().getTime()
        startTimeIsKnown: date.start.knownValues.hour?
        endTimeIsKnown: date.end?
        startTime: startDate.getTime()
        endTime: if date.end then date.end.date().getTime() else null
        post: text
        url: postInfo.url
        author: postInfo.author
        processedInfo: JSON.stringify date
        tags: [] #TODO: CLASSIFIER WORK HERE
  events


exports.getEventsFromSocialFeeds = getEvents
exports.getEventsFromFBFeed = getEventsFromFBFeed
exports.getEventsFromTweets = getEventsFromTweets

