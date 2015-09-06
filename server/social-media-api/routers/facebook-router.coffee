express        = require 'express'
request        = require 'request' 
facebookRouter = express.Router()

facebookAPIHost = 'https://graph.facebook.com'

facebookRouter.get '/:pageName', (req, res) ->
  
  request "#{facebookAPIHost}/\\
           #{req.params.pageName}/\\
           ?access_token=#{process.env.FB_TOKEN}", (error, response, body) ->
    res.send body
  

module.exports = facebookRouter