# load environment variables
dotenv         = require 'dotenv-with-overload'
dotenv._getKeysAndValuesFromEnvFilePath "#{__dirname}/.env"
dotenv._setEnvs()

request = require 'request'

feeds = []

getLoginToken = (callback) ->
  request
    url: "#{process.env.GRAPEVINE_API_HOST}/api/v1/tokens"
    method: 'POST'
    headers: 'content-type': 'application/json'
    body: JSON.stringify {username: process.env.USERNAME, password: process.env.PASSWORD}
  , (err, response, body) ->
    return callback err if err
    callback null, (JSON.parse body).token

requestMembers = (cursor, callback) ->
  console.log callback
  request
    url: "#{process.env.SOCIAL_MEDIA_API_HOST}/twitter/list/222479944/members/#{(cursor or '')}"
    method: 'GET'
    headers: 'content-type': 'application/json'
  , (err, response, body) ->
    return console.log err if err
    parsedBody = JSON.parse body
    for user in parsedBody.users
      feeds.push user.screen_name
    return requestMembers parsedBody.next_cursor, callback if parsedBody.next_cursor > 0
    callback()

followFeeds = ->
  console.log feeds
  getLoginToken (err, token) ->
    for feed in feeds
      console.log "adding feed #{feed}"
      request
        url: "#{process.env.GRAPEVINE_API_HOST}/api/v1/users/1/feeds"
        method: 'POST'
        headers:
          'content-type': 'application/json'
          'x-access-token': token
        body: JSON.stringify {networkName: 'twitter', feedName: feed}
      , (err, response, body) ->
        return console.log err if err

requestMembers 0, followFeeds

