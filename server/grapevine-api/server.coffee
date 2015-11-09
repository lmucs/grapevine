# load environment variables
dotenv         = require 'dotenv-with-overload'
dotenv._getKeysAndValuesFromEnvFilePath "#{__dirname}/.env"
dotenv._setEnvs()

express    = require 'express'
logger     = require 'morgan'
bodyParser = require 'body-parser'
auth       = require './middlewares/auth'
routes     = require './routes'

app = express()

# set up middleware
app.use bodyParser.json()
app.use logger process.env.LOGGING_LEVEL or 'dev' unless process.env.NODE_ENV is 'test'
app.all '/api/v1/*',   [ auth ]
app.all '/admin/v1/*', [ auth ]

# register routes
app.use '/', routes

# handle invalid routes
app.use (req, res) ->
  res.status(404).json 'message': 'resource not found'

module.exports = app.listen process.env.PORT or 8000