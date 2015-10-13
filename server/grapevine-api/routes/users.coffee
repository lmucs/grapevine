pgClient = require '../pg-client'

users =
  create: (req, res) ->
    findExistingUser req.body.username, (err, user) ->
      return res.status(400).json err if err
      return res.status(400).json 'message' : 'username already exists' if user

      insertUser req.body.username, req.body.password, (err) ->
        return res.status(400).json err if err
        res.status(200).json 'message': 'user successfully created'

  getFeeds: (req, res) ->
    pgClient.query
      text: 'SELECT feeds.feedid, feeds.feedname
             FROM feeds, user_follows_feed
             WHERE feeds.feedid = user_follows_feed.feedid AND user_follows_feed.userid = $1',
      values: [req.params.userID]
    , (err, result) ->
      return res.status(400).json err if err
      res.status(200).json result.rows

  followFeed: (req, res) ->
    # check for feed, insert if doesn't exist
    # associate userID and feedID

    # pgClient.query
    #   text: 'INSERT INTO user_follows_feed (userID, feedID) VALUES ($1, $2)',
    #   values: [req.params.userID, req.params.feedID]
    # , (err, result) ->
    #   return res.status(400).json err if err
    #   res.status(200)

  unfollowFeed: (req, res) ->
    # TODO

findExistingUser = (username, callback) ->
  pgClient.query
    text: 'SELECT * FROM users WHERE username = $1',
    values: [username]
  , (err, result) ->
    return callback err if err
    callback null, result.rows[0]

insertUser = (username, password, callback) ->
  pgClient.query
    text: 'INSERT INTO users (username, password) VALUES ($1, $2)',
    values: [username, password]
  , callback

module.exports = users