pgClient = require '../pg-client'

events =
  getAllFromFeed: (req, res) ->
    pgClient.query
      text: 'SELECT * FROM events WHERE feedid = $1',
      values: [req.params.feedID]
    , (err, result) ->
      return res.status(400).json err if err
      res.status(200).json result.rows

  getLatestFromFeed: (req, res) ->
    pgClient.query
      text: 'SELECT * FROM events WHERE feedid = $1 AND timeProcessed > $2',
      values: [req.params.feedID, req.params.timestamp]
    , (err, result) ->
      return res.status(400).json err if err
      res.status(200).json result.rows

module.exports = events
