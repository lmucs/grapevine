request = require 'request'
intervalInSeconds = 5
twitterURL = 'http://localhost:3000/twitter/posts/LoyolaMarymount'
chrono = require 'chrono-node'

processing = () ->
  request 'http://localhost:3000/twitter/posts/LoyolaMarymount' , (err, res, body) ->
    tweets = JSON.parse body
    dates = []
    for tweet in tweets
      tweetText = tweet.text
      console.log tweetText
      parsedDate = chrono.parse tweetText
      console.log parsedDate
      console.log parsedDate[0].start.knownValues
      dates.push parsedDate
      console.log "============================"
    console.log dates

    #chrono.parseDate postString


setInterval processing, 1000 * intervalInSeconds