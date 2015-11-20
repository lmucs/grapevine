pgClient = require '../../../database/pg-client'
request  = require 'request'

user_feeds =

  createAssociation: (userID, feedID, callback) ->
    pgClient.query
      text: 'INSERT INTO user_follows_feed (user_id, feed_id)
             VALUES ($1, $2)',
      values: [userID, feedID]
    , callback

  deleteAssociation: (userID, feedID, callback) ->
    pgClient.query
      text: 'DELETE FROM user_follows_feed
             WHERE user_id = $1 AND feed_id = $2',
      values: [userID, feedID]
    , callback

module.exports = user_feeds