pgClient = require '../../../database/pg-client'
request  = require 'request'
async    = require 'async'

feeds =
  update: (req, res) ->
    return res.status(400).json 'message': 'lastPulled timestamp required' unless req.body.lastPulled
    pgClient.query
      text: 'UPDATE feeds SET last_pulled = $1',
      values: [req.body.lastPulled]
    , (err) ->
      return res.status(400).json err if err
      res.status(200).json 'message' : 'successfully updated time last pulled'

  getAll: (req, res) ->
    pgClient.query 'SELECT * FROM feeds', (err, result) ->
      return res.status(400).json err if err
      res.status(200).json result.rows

  insert: (feedName, newtworkName, id, callback) ->
    if newtworkName is 'twitter'
      request.post "http://social-media.herokuapp.com/twitter/feeds/#{feedName}",
      pgClient.query
        text: 'INSERT INTO feeds (feed_name, network_name, feed_id, last_pulled)
               VALUES ($1, $2, $3, $4)
               RETURNING feed_id, feed_name',
        values: [feedName, newtworkName, id, (new Date()).getTime()]
      , callback
    else
      pgClient.query
        text: 'INSERT INTO feeds (feed_name, network_name, last_pulled)
               VALUES ($1, $2, $3)
               RETURNING feed_id, feed_name',
        values: [feedName, newtworkName, (new Date()).getTime()]
      , callback

  get: (feedName, newtworkName, callback) ->
    pgClient.query
      text: 'SELECT * FROM feeds WHERE feed_name = $1 AND network_name = $2',
      values: [feedName, newtworkName]
    , callback

  findInNetwork: (feedName, newtworkName, callback) ->
    request "https://social-media.herokuapp.com/#{newtworkName}/posts/#{feedName}", callback


module.exports = feeds