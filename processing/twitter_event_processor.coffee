request             = require 'request'
timeExtractor       = require './time_extractor'
util                = require './processor_util'
pushGrapevineEvents = util.pushGrapevineEvents
isFutureEvent       = util.isFutureEvent
updateLastPulled    = util.updateLastPulled

exports.extractAndSendEvents = (feed) ->

  lastPulled = 0

  getTweets = (next) ->
    type = if feed.feed_name is 'twitter_list' then 'list' else 'posts'
    identifier = if feed.feed_name is 'twitter_list' then feed.feed_id else feed.feed_name
    since = if feed.last_pulled > 0 then feed.last_pulled else ''
    request "#{process.env.SOCIAL_MEDIA_API_HOST}/twitter/#{type}/#{identifier}/#{since}", (err, res, body) ->
      throw err if err
      tweets = JSON.parse body
      lastPulled = tweets[0]?.id_str
      next tweets

  extractGrapevineEventsFromTweets = (next) ->
    (tweets) ->
      grapevineEvents = []
      for tweet in tweets
        extractedTimeAttributes = timeExtractor.extractTimeAttributes tweet.text, tweet.created_at
        if extractedTimeAttributes
          # we consider a tweet to be an event if we extract time info from it
          grapevineEvent = extractedTimeAttributes
          if isFutureEvent grapevineEvent
            grapevineEvent.feedID = tweet.user.id
            #TODO: event URL?
            grapevineEvents.push grapevineEvent
      next grapevineEvents

  done = (err) ->
    return console.log err if err
    console.log "extracted events from tweets from #{feed.feed_name} (ID: #{feed.feed_id}),
                 sent events to Grapevine,
                 and updated time when list was last pulled from"

  getTweets extractGrapevineEventsFromTweets pushGrapevineEvents (err) ->
    updateLastPulled {feed, lastPulled}, done if lastPulled
    done null
