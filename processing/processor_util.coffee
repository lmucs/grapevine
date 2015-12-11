request = require 'request'
async   = require 'async'

exports.getLoginToken = (callback) ->
  request
    url: "#{process.env.GRAPEVINE_API_HOST}/api/v1/tokens"
    method: 'POST'
    headers: 'content-type': 'application/json'
    body: JSON.stringify {username: process.env.USERNAME, password: process.env.PASSWORD}
  , (err, response, body) ->
    return callback err if err
    callback null, (JSON.parse body).token

exports.pushGrapevineEvents = (callback) ->
  (grapevineEvents) ->
    exports.getLoginToken (err, token) ->
      request
        url: "#{process.env.GRAPEVINE_API_HOST}/admin/v1/events"
        method: 'POST'
        headers:
          'content-type': 'application/json'
          'x-access-token': token
        body: JSON.stringify({'events': grapevineEvents})
      , (err, response, body) ->
        return callback err if err
        callback null, 'message' : 'done pushing events'

exports.isFutureEvent = (event) ->
  currentTime = (new Date).getTime()
  event.startTime > currentTime or event.endTime > currentTime

exports.updateLastPulled = ({feed, lastPulled}, callback) ->
  lastPulled = lastPulled or (new Date).getTime()
  exports.getLoginToken (err, token) ->
    request
      url: "#{process.env.GRAPEVINE_API_HOST}/admin/v1/feeds/#{feed.feed_id}"
      method: 'PUT'
      headers:
        'content-type': 'application/json'
        'x-access-token': token
      body: JSON.stringify({'lastPulled': lastPulled})
    , (err, response, body) ->
      return callback err if err
      callback null

classifyTags = (text, callback) ->
  request
    url: "#{process.env.GRAPEVINE_CLASSIFY_HOST}/tags"
    method: 'POST'
    headers: 'content-type': 'application/json'
    auth:
      'user': process.env.CLASUSERNAME
      'password': process.env.CLASPASSWORD
    body: JSON.stringify {post: text}
  , (err, response, body) ->
    if err
      callback []
    else
      callback (JSON.parse body).tags

exports.classify = (next) ->
  (events) ->
    async.map events
      , (event, callback) ->
        classifyTags event.post, (tags) ->
          event.tags = tags
          callback null, event
    , (err, events) ->
      next events
