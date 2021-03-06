express        = require 'express'
request        = require 'request'
twitterRouter  = express.Router()

twitterAPIHost = 'https://api.twitter.com/1.1'
tweetlimit     = 100

oauth =
  consumer_key:     process.env.TWITTER_CONSUMER_KEY
  consumer_secret:  process.env.TWITTER_CONSUMER_SECRET
  token:            process.env.TWITTER_TOKEN
  token_secret:     process.env.TWITTER_TOKEN_SECRET


twitterRouter.get '/posts/:screenName/:sinceID?', (req, res) ->
  url = "#{twitterAPIHost}/" +
        "statuses/user_timeline.json" +
        "?screen_name=#{req.params.screenName}" +
        "&count=#{tweetlimit}"
  url += "&since_id#{req.params.sinceID}" if req.params.sinceID

  request.get {url, oauth}, (error, response, body) ->
    return res.status(400).json error if error
    res.status(200).json JSON.parse body

twitterRouter.get '/list/:listID/members/:cursor?', (req, res) ->
  url = "#{twitterAPIHost}/" +
      "lists/members.json" +
      "?list_id=#{process.env.TWITTER_LIST_ID}" +
      "&slug=#{process.env.TWITTER_SCREEN_NAME}"
  url += "&cursor=#{req.params.cursor}" if req.params.cursor
  request.get {url, oauth}, (error, response, body) ->
    return res.status(400).json error if error
    res.status(200).json JSON.parse body

twitterRouter.get '/list/:listID/:sinceID?', (req, res) ->
  url = "#{twitterAPIHost}/" +
        "lists/statuses.json" +
        "?user_id=#{process.env.TWITTER_SCREEN_NAME}" +
        "&list_id=#{req.params.listID}" +
        "&include_rts=0"
  url += "&since_id=#{req.params.sinceID}" if req.params.sinceID
  request.get {url, oauth}, (error, response, body) ->
    return res.status(400).json error if error
    res.send body

twitterRouter.post '/feeds/:screenName', (req, res) ->
  url = "#{twitterAPIHost}/" +
        "lists/members/create.json" +
        "?user_id=#{process.env.TWITTER_SCREEN_NAME}" +
        "&list_id=#{process.env.TWITTER_LIST_ID}" +
        "&screen_name=#{req.params.screenName}"
  request.post {url, oauth}, (error, response, body) ->
    parsedBody = JSON.parse body
    if parsedBody.errors?.length > 0
      return res.status(400).json parsedBody
    res.send body

twitterRouter.delete '/feeds/:screenName', (req, res) ->
  url = "#{twitterAPIHost}/" +
        "lists/members/destroy.json" +
        "?user_id=#{process.env.TWITTER_SCREEN_NAME}" +
        "&list_id=#{process.env.TWITTER_LIST_ID}" +
        "&screen_name=#{req.params.screenName}"
  request.post {url, oauth}, (error, response, body) ->
    parsedBody = JSON.parse body
    if parsedBody.errors?.length > 0
      return res.status(400).json parsedBody
    res.send body

module.exports = twitterRouter