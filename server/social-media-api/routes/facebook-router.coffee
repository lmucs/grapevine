express        = require 'express'
request        = require 'request'
facebookRouter = express.Router()
fbURL          = "https%3A%2F%2Fwww.facebook.com%2F"

APIHost        = 'https://graph.facebook.com/v2.5'
feedLimit      = 100

facebookRouter.get '/:feedType(events|posts)/:pageName/:after?', (req, res) ->

  getPageID = (next) ->
    pageIDEndpoint = "#{APIHost}/" +
                      "?id=#{fbURL}#{req.params.pageName}" +
                      "&access_token=#{process.env.FB_TOKEN}"
    request pageIDEndpoint, (err, response, body) ->
      parsedBody = JSON.parse body
      return res.sendStatus response.statusCode if parsedBody.error
      next parsedBody.id



  # TODO: split into different methods for events and posts
  getFeedFromPageID = (id) ->
    feedEndpoint = "#{APIHost}/#{id}/" +
                   "#{req.params.feedType}" +
                   "?access_token=#{process.env.FB_TOKEN}"
    feedEndpoint += "&limit=#{feedLimit}" if req.params.feedType is 'posts'
    if req.params.after
      if req.params.feedType is 'posts'
        after = Math.round(req.params.after / 1000)
        feedEndpoint += "&since=#{after}"
      else if req.params.feedType is 'events'
        feedEndpoint += "&limit=#{req.params.after}"
    request feedEndpoint, (err, response, body) ->
      return res.sendStatus response.statusCode if (JSON.parse body).error
      res.send body

  getPageID getFeedFromPageID


module.exports = facebookRouter