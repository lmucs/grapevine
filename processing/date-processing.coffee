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

# getRequestURLFor = ({network_name, feed_name, last_pulled}) ->
#   requestURL = "#{host}/#{network_name]}/posts/#{feed_name}/#{if last_pulled then last_pulled else ''}"

getEventsFromFBFeed = (feed) ->

  getFBFeedPosts = (next) ->
    request "#{socialMediaAPIHost}/facebook/posts/#{feed.feed_name}", (err, res, body) ->
      next JSON.parse(body)?.data

  extractEventsFromPosts = (next) ->
    (posts) ->
      events = []
      for post in posts
        postText = post.message or ''
        url = getFacebookURL(post.id)
        postInfo = {author:feed.feed_name, url}
        events.push.apply events, extractEvents postText, postInfo, feed.feed_id
      next events

  getFBFeedPosts extractEventsFromPosts pushEvents done
  # getFBFeedEvents pushEvents

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
# getEventsFromFeed = (feed) ->
#   request getRequestURLFor feed, (err, res, body) ->
#     if res.statusCode is 200
#       events = []
#       if JSON.parse(body).data?
#         rawPosts = JSON.parse(body).data
#         events = processRawPosts rawPosts, feed_name, feed_id
#       request
#         url: "#{databaseAPI}api/v1/tokens"
#         method: 'POST'
#         headers: 'content-type': 'application/json'
#         body: JSON.stringify {username: process.env.USERNAME, password: process.env.PASSWORD}
#       , (err, response, body) ->
#         console.log events
#         throw err if err
#         request
#           url: "#{databaseAPI}admin/v1/events"
#           method: 'POST'
#           headers:
#             'content-type': 'application/json'
#             'x-access-token': (JSON.parse body).token
#           body: JSON.stringify({'events': events})
#         , (err, response, body) ->
#           throw err if err
#           console.log 'done-zo'
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
  currentTime = (new Date).getTime()
  myEvent = null
  for date in parsedDates
    # date = parsedDates[-1..]
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


exports.getEventsFromFBFeed = getEventsFromFBFeed

