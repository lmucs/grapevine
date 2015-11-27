# load environment variables
dotenv         = require 'dotenv-with-overload'
dotenv._getKeysAndValuesFromEnvFilePath "#{__dirname}/.env"
dotenv._setEnvs()

request = require 'request'
getLoginToken = require('./processor_util').getLoginToken
FBEventProcessor = require './fb_event_processor'

intervalInSeconds = 60*5

run = ->
  console.log "running"
  getLoginToken (err, token) ->
    throw err if err
    request
      url: "#{process.env.GRAPEVINE_API_HOST}/admin/v1/feeds"
      method: 'GET'
      headers:
        'content-type': 'application/json'
        'x-access-token': token
    , (err, response, body) ->
      parsedBody = JSON.parse body
      for feed in parsedBody.facebook
        FBEventProcessor.extractAndSendEventsFromFeed feed


setInterval run, 1000 * intervalInSeconds

