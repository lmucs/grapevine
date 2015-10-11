# load environment variables
dotenv         = require 'dotenv-with-overload'
dotenv._getKeysAndValuesFromEnvFilePath "#{__dirname}/.env"
dotenv._setEnvs()

express        = require 'express'
logger         = require 'morgan'
bodyParser     = require 'body-parser'
pg             = require 'pg'

pgClient = new pg.Client process.env.DATABASE_URL
console.log 'connecting postgres client...'
pgClient.connect()
pgClient.query 'CREATE TABLE IF NOT EXISTS feeds(
    feedID SERIAL PRIMARY KEY,
    feedName text)'
pgClient.query 'CREATE TABLE IF NOT EXISTS events(
    eventID SERIAL PRIMARY KEY,
    title text,
    timeProcessed integer,
    startTime integer,
    endTime integer,
    repeatsWeekly integer,
    tags text[],
    origin text,
    URL text,
    postContent text,
    feedID SERIAL REFERENCES feeds)'
pgClient.query 'CREATE TABLE IF NOT EXISTS users(
    userID SERIAL PRIMARY KEY,
    username text,
    password text)'
pgClient.query 'CREATE TABLE IF NOT EXISTS user_has_feed(
    feedID SERIAL REFERENCES feeds,
    userID SERIAL REFERENCES users)'
# query = pgClient.query 'DROP TABLE events'
# console.log 'deleted table?'
# query.on 'end', -> pgClient.end()

app = express()

# set up middleware
app.use bodyParser.json()
app.use logger process.env.LOGGING_LEVEL or 'dev'
app.all '/api/v1/*', [ require('./middlewares/validateRequest') ]

# register routes
app.use '/', require('./routes')

# If no route is matched by now, it must be a 404
app.use (req, res) ->
  res.sendStatus 404

app.listen process.env.PORT or 8000
