request = require 'request'
intervalInSeconds = 5
serverName = 'http://localhost:3000/'
twitterURL = 'twitter/posts/'
fbPostURL = 'facebook/posts'
chrono = require 'chrono-node'

extractEvents = (text, author) ->
  events = []
  parsedDate = chrono.parse text
  for date in parsedDate
    myEvent = {}
    myEvent.startTime = date.start.date()
    myEvent.endTime = date.end.date() if date.end
    myEvent.text = tweetText
    myEvent.author = author
    myEvent.processedInfo = date
    events.push myEvent
  events

processRawTweets = (tweets) ->
  events = []
  for tweet in tweets
    tweetText = tweet.text
    author = tweet.user.screen_name
    events = [events..., extractEvents tweetText, author ...]
  events

processRawPosts = (posts, screenName) ->
  events = []
  for post in posts
    postText = post.message
    events = [events..., extractEvents postText, screenName ...]
  events

getRawTweets = (screenName, sinceID) ->
  requestURL = "#{serverName}#{twitterURL}#{screenName}"
  requestURL += '/' + sinceID if sinceID
  request requestURL, (err, res, body) ->
    events = processRawTweets JSON.parse body

getRawFBPosts = (screenName, timeStamp) ->
  requestURL = "#{serverName}#{fbPostURL}#{screenName}"
  requestURL += '/' + timeStamp if timeStamp
  request requestURL, (err, res, body) ->
    posts = JSON.parse(body).data
    events = processRawPosts posts, screenName

setInterval getEventsFromSocialFeeds, 1000 * intervalInSeconds