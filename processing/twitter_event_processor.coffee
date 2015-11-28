request             = require 'request'
timeExtractor       = require './time_extractor'
util                = require './processor_util'
pushGrapevineEvents = util.pushGrapevineEvents
isFutureEvent       = util.isFutureEvent
updateLastPulled    = util.updateLastPulled

exports.extractAndSendEventsFromList = (list) ->

  lastPulled = 0

  getTweets = (next) ->
    request "#{process.env.SOCIAL_MEDIA_API_HOST}/twitter/list/#{list.list_id}/#{(list.last_pulled or '')}", (err, res, body) ->
      throw err if err
      tweets = JSON.parse body
      lastPulled = tweets[0]?.id_str
      next JSON.parse body

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
    console.log "extracted events from tweets of twitter list #{list.list_id},
                 sent events to Grapevine,
                 and updated time when list was last pulled from"

  console.log list

  getTweets extractGrapevineEventsFromTweets pushGrapevineEvents -> console.log 'done-zo'
  (updateLastPulled(list, lastPulled))

# exports.sendEventsFromTwitterFeed = (feed) ->

#   getTweets = (next) ->
#     request "#{socialMediaAPIHost}/twitter/posts/#{feed.feed_name}", (err, res, body) ->
#       throw err if err
#       next JSON.parse body

#   extractGrapevineEventsFromTweets = (next) ->
#     (tweets) ->
#       grapevineEvents = []
#       for tweet in tweets
#         extractedTimeAttributes = dateProcessor.extractedTimeAttributes tweet.text, tweet.created_at
#         if extractedTimeAttributes
#           # we consider a tweet to be an event if we extract time info from it
#           grapevineEvent = extractedTimeAttributes
#           if dateProcessor.isFutureEvent grapevineEvent
#             grapevineEvent.feedID = tweet.user.id
#             grapevineEvents.push grapevineEvent
#       next grapevineEvents

#   getTweets extractGrapevineEventsFromTweets pushGrapevineEvents updateLastPulled lastPulled -> console.log ''
