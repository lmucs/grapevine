pg       = require 'pg'
pgClient = new pg.Client process.env.DB_CONNECT_STRING

pgClient.connect()

module.exports = pgClient

