express        = require 'express'
request        = require 'request' 
twitterRouter  = express.Router()

twitterAPIHost = 'https://api.twitter.com/1.1'

oauth =
  consumer_key:     process.env.TWITTER_CONSUMER_KEY
  consumer_secret:  process.env.TWITTER_CONSUMER_SECRET
  token:            process.env.TWITTER_TOKEN
  token_secret:     process.env.TWITTER_TOKEN_SECRET

twitterRouter.get '/posts/:screenName', (req, res) -> 
  url = "#{twitterAPIHost}/" + 
        "statuses/user_timeline.json" +
        "?screen_name=#{req.params.screenName}"
  request.get {url, oauth}, (error, response, body) ->
    res.send body

module.exports = twitterRouter