# load environment variables
require('dotenv').load()

express        = require 'express'
bodyParser     = require 'body-parser'
facebookRouter = require './routers/facebook-router'
twitterRouter  = require './routers/twitter-router'

app = express()

# set up middleware
app.use bodyParser.json()

# register routes
app.use '/facebook', facebookRouter
app.use '/twitter', twitterRouter

# start the server
app.listen process.env.PORT or 3000