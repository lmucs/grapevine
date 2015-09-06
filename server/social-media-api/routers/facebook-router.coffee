express        = require 'express'
request        = require 'request' 
facebookRouter = express.Router()

APIHost        = 'https://graph.facebook.com'

facebookRouter.get '/posts/:pageName/:timeStamp?', (req, res) ->
  request "#{APIHost}/\\
           #{req.params.pageName}/\\
           ?access_token=#{process.env.FB_TOKEN}", (error, response, body) ->
    res.status(response.statusCode) unless response.statusCode is 200
    url = getFacebookURL (JSON.parse body).id, 'posts', req.params.timeStamp
    request url, (err, response, body) ->
      res.send body

facebookRouter.get '/events/:pageName/:timeStamp?', (req, res) ->
  request "#{APIHost}/\\
           #{req.params.pageName}/\\
           ?access_token=#{process.env.FB_TOKEN}", (error, response, body) ->
    res.status(response.statusCode) unless response.statusCode is 200
    request getFacebookURL((JSON.parse body).id, 'events', req.params.timeStamp), (err, response, body) ->
      res.send body


getFacebookURL = (id, type, timestamp) -> 
  url = "#{APIHost}/#{id}/#{type}?access_token=#{process.env.FB_TOKEN}&limit=100"
  url += "&since=#{timestamp}" if timestamp
  url

module.exports = facebookRouter