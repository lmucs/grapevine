pgClient = require '../../../database/pg-client'
request   = require 'request'

feeds =
  getAll: (req, res) ->
    pgClient.query 'SELECT * FROM feeds', (err, result) ->
      return res.status(400).json err if err
      res.status(200).json result.rows

  insert: (feedName, newtworkName, callback) ->
    pgClient.query
      text: 'INSERT INTO feeds (feed_name, network_name, last_pulled)
             VALUES ($1, $2, $3)
             RETURNING feed_id, feed_name',
      values: [feedName, newtworkName, (new Date).getTime()]
    , callback

  get: (feedName, newtworkName, callback) ->
    pgClient.query
      text: 'SELECT * FROM feeds WHERE feed_name = $1 AND network_name = $2',
      values: [feedName, newtworkName]
    , callback

  findInNetwork: (feedName, newtworkName, callback) ->
    request "https://social-media.herokuapp.com/#{newtworkName}/posts/#{feedName}", callback


module.exports = feeds