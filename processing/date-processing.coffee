request = require 'request'
intervalInSeconds = 5
serverName = 'http://localhost:3000/'
twitterURL = 'twitter/posts/'
fbURL = ''
chrono = require 'chrono-node'

getRawTweets = (screenName, sinceID) ->
  requestURL = "#{serverName}#{twitterURL}#{screenName}"
  requestURL += sinceID if sinceID
  request requestURL, (err, res, body) ->
    events = processRawTweets JSON.parse body


twitterProcessing = (tweets) ->
  events = []
  for tweet in tweets
    tweetText = tweet.text
    parsedDate = chrono.parse tweetText
    author = tweet.user.screen_name
    for date in parsedDate
      myEvent = {}
      myEvent.startTime = date.start.date()
      myEvent.endTime = date.end.date() if date.end
      myEvent.text = tweetText
      myEvent.author = author
      myEvent.processedInfo = date
      events.push myEvent
  events

setInterval getEventsFromSocialFeeds, 1000 * intervalInSeconds