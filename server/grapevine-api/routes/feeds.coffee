pgClient = require '../../../database/pg-client'
request   = require 'request'

feeds =
  updateOne: (req, res) ->
    return res.status(400).json 'message': 'lastPulled timestamp required' unless req.body.lastPulled
    pgClient.query
      text: 'UPDATE feeds SET last_pulled = $1 WHERE feed_id = $2',
      values: [req.body.lastPulled, req.params.feedID]
    , (err) ->
      console.log "MADE THE QUERY BITCH"
      return res.status(400).json err if err
      res.status(200).json 'message' : "successfully updated time last pulled for feed with ID #{req.params.feedID}"

  updateAll: (req, res) ->
    return res.status(400).json 'message': 'lastPulled timestamp required' unless req.body.lastPulled
    pgClient.query
      text: 'UPDATE feeds SET last_pulled = $1',
      values: [req.body.lastPulled]
    , (err) ->
      return res.status(400).json err if err
      res.status(200).json 'message' : 'successfully updated time last pulled for all feeds'

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