request = require 'request'
intervalInSeconds = 5
serverName = 'http://localhost:3000/'
twitterURL = 'twitter/posts/'
fbURL = ''
chrono = require 'chrono-node'

twitterProcessing = (screenName, sinceID) ->
  requestURL = "#{serverName}#{twitterURL}#{screenName}"
  requestURL += sinceID if sinceID
  events = []
  request requestURL , (err, res, body) ->
    tweets = JSON.parse body
    for tweet in tweets
      tweetText = tweet.text
      console.log tweetText
      parsedDate = chrono.parse tweetText
      console.log JSON.parse JSON.stringify parsedDate
      for date in parsedDate
        myEvent = {}
        myEvent.startTime = date.start.date()
        myEvent.endTime = date.end.date() if date.end
        myEvent.text = tweetText
        myEvent.author = screenName
        myEvent.processedInfo = date
        events.push myEvent
        console.log myEvent
      console.log "============================"
    console.log events

    #chrono.parseDate postString


setInterval twitterProcessing('LoyolaMarymount'), 1000 * intervalInSeconds