request = require 'request'
async   = require 'async'
cosine  = require 'cosine'
natural = require 'natural'

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
    console.log "PUSH grapevineEvents #{JSON.stringify grapevineEvents}"
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

classifyTags = (text) ->
  request
    url: "#{process.env.GRAPEVINE_CLASSIFY_HOST}/tags"
    method: 'POST'
    headers: 'content-type': 'application/json'
    auth: 'user': process.env.CLASUSERNAME
          'password': process.env.CLASPASSWORD
    body: JSON.stringify {post: text}
  , (err, response, body) ->
    if err
      console.log(err)
      tags = []
    else
      tags = (JSON.parse body).tags

#TO DO
exports.extractTitle = (post, chronoText) ->
  post = post.replace /\(.*\)/g, ""       #remove parentheticals
  sents = post.match /[^\.!\?]+[\.!\?]+/g
  console.log sents
  for sent in sents
    if sent.indexOf chronoText, 0 != 1
      

exports.removeDuplicates = (events) ->
  #TO DO
  events

exports.classify = (next) ->
  (events) ->
    async.map events 
      , (event, callback) ->
        event.tags = classifyTags(event.post)
        # if !event.title?
        #   chronoOutput = JSON.parse event.chronoOutput
        #   event.title = extractTitle(event.post,chronoOutput.text)
        return callback err if err
        callback null, event
      , (err, events) ->
        console.log err if err
        next events
