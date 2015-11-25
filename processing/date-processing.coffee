# load environment variables
dotenv         = require 'dotenv-with-overload'
dotenv._getKeysAndValuesFromEnvFilePath "#{__dirname}/.env"
dotenv._setEnvs()

request = require 'request'
intervalInSeconds = 10
serverName = 'http://localhost:3000/'
databaseAPI = 'http://localhost:8000/'
twitterURL = 'twitter/posts/'
fbPostURL = 'facebook/posts/'
chrono = require 'chrono-node'
async = require 'async'

getRequestURL = (networkName, feedName, since) ->
  requestURL = ""
  if networkName is 'twitter'
    requestURL = "#{serverName}#{twitterURL}#{feedName}"
    requestURL += '/' + since if since
  else if networkName is 'facebook'
    requestURL = "#{serverName}#{fbPostURL}#{feedName}"
    requestURL += '/' + since if since
  return requestURL


getEventsFromFeed = (networkName, feedName, feedID, sinceID) ->
  requestURL = getRequestURL networkName, feedName, sinceID
  request requestURL, (err, res, body) ->
    if res.statusCode is 200
      console.log body
      events = []
      if networkName is 'twitter'
        events = processRawTweets JSON.parse(body), feedID
      else if networkName is 'facebook' and JSON.parse(body).data?
        rawPosts = JSON.parse(body).data
        events = processRawPosts rawPosts, networkName, feedID
      request
        url: "#{databaseAPI}api/v1/tokens"
        method: 'POST'
        headers:
          'content-type': 'application/json'
        body: JSON.stringify {username: process.env.USERNAME, password: process.env.PASSWORD}
      , (err, response, body) ->
        console.log events
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
          # request
          #   url: "#{databaseAPI}admin/v1/feeds"
          #   method: 'PUT'
          #   headers:
          #     'content-type': 'application/json'
          #     'x-access-token': (JSON.parse body).token
          #   body: JSON.stringify({'lastPulled': if networkName is 'twitter' then maxSinceID else (new Date).getTime()})
          # , (err, response, body) ->
          #   console.log 'done-zo'

processRawTweets = (tweets, feedID) ->
  events = []
  for tweet in tweets
    tweetText = tweet.text
    author = tweet.user.screen_name
    url = getTwitterURL(author, tweet.id_str)
    tweetInfo = {url, author}
    events = [events..., extractEvents(tweetText, tweetInfo, feedID)...]
  events

processRawPosts = (posts, author, feedID) ->
  console.log 'processing raw posts'
  console.log "length of posts #{posts.length}"
  events = []
  for post in posts
    postText = post.message ? ""
    url = getFacebookURL(post.id)
    postInfo = {author, url}
    events = [events..., extractEvents(postText, postInfo, feedID)...]
  events

getFacebookURL = (id) ->
  [user, post] = id.split("_")
  "https://www.facebook.com/#{user}/posts/#{post}"

getTwitterURL = (screenName, tweetID) ->
  "https://twitter.com/#{screenName}/status/#{tweetID}"

# Get rid of events that have already happened
extractEvents = (text, postInfo, feedID) ->
  events = []
  parsedDates = chrono.parse text
  console.log text
  console.log "parsed dates #{JSON.stringify parsedDates}"
  currentTime = (new Date).getTime()
  myEvent = null
  for date in parsedDates
    # date = parsedDates[-1..]
    # console.log 'date' + JSON.stringify date
    startDate = date.start.date()
    if startDate.getTime() > currentTime
      myEvent =
        timeProcessed: new Date().getTime()
        startTimeIsKnown: date.start.knownValues.hour?
        endTimeIsKnown: date.end?
        startTime: startDate.getTime()
        endTime: if date.end then date.end.date().getTime() else null
        post: text
        url: postInfo.url
        author: postInfo.author
        processedInfo: JSON.stringify date
        feedID: feedID
        tags: [] #TODO: CLASSIFIER WORK HERE
  if myEvent then [myEvent] else []


exports.getEventsFromFeed = getEventsFromFeed

