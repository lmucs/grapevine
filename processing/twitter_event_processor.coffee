request             = require 'request'
timeExtractor       = require './time_extractor'
util                = require './processor_util'
pushGrapevineEvents = util.pushGrapevineEvents
isFutureEvent       = util.isFutureEvent
updateLastPulled    = util.updateLastPulled

exports.extractAndSendEventsFromList = (list) ->

  getTweets = (next) ->
    request "#{socialMediaAPIHost}/twitter/list/#{list.list_id}", (err, res, body) ->
      throw err if err
      next JSON.parse body

  extractGrapevineEventsFromTweets = (next) ->
    (tweets) ->
      grapevineEvents = []
      for tweet in tweets
        extractedTimeAttributes = dateProcessor.extractedTimeAttributes tweet.text, tweet.created_at
        if extractedTimeAttributes
          # we consider a tweet to be an event if we extract time info from it
          grapevineEvent = extractedTimeAttributes
          if dateProcessor.isFutureEvent grapevineEvent
            grapevineEvent.feedID = 45
            #TODO: event URL?
            grapevineEvents.push grapevineEvent
      next grapevineEvents

  getTweets extractGrapevineEventsFromTweets pushGrapevineEvents -> console.log 'done'

exports.sendEventsFromTwitterFeed = (feed) ->

  getTweets = (next) ->
    request "#{socialMediaAPIHost}/twitter/posts/#{feed.feed_name}", (err, res, body) ->
      throw err if err
      next JSON.parse body

  extractGrapevineEventsFromTweets = (next) ->
    (tweets) ->
      grapevineEvents = []
      for tweet in tweets
        extractedTimeAttributes = dateProcessor.extractedTimeAttributes tweet.text, tweet.created_at
        if extractedTimeAttributes
          # we consider a tweet to be an event if we extract time info from it
          grapevineEvent = extractedTimeAttributes
          if dateProcessor.isFutureEvent grapevineEvent
            grapevineEvent.feedID = tweet.user.id
            grapevineEvents.push grapevineEvent
      next grapevineEvents

  getTweets extractGrapevineEventsFromTweets pushGrapevineEvents -> console.log 'done'
