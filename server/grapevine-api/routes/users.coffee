pgClient = require '../pg-client'
request  = require 'request'

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
    feedName   = req.body?.feedName
    sourceName = req.body?.sourceName
    unless feedName and sourceName
      res.status(400).json 'message': 'bad feedName or sourceName'

    getFeed feedName, sourceName, (err, result) ->
      return res.status(400).json err if err
      feed = result.rows[0]
      if feed
        createUserFeedAssociation req.params.userID, feed.feedid, (err) ->
          return res.status(400).json err if err
          res.status(200).json
            'message' : "successfully followed feed #{feed.feedname}
                         for userID #{req.params.userID}"
      else
        checkValidFeed feedName, sourceName, (err, response, body) ->
          if err or response.statusCode isnt 200
            return res.status(404).json
              'message': "#{sourceName} does not contain feed #{feedName}"
          insertFeed feedName, sourceName, (err) ->
            return res.status(400).json err if err
            getFeed feedName, sourceName, (err, result) ->
              return res.status(400).json err if err
              createUserFeedAssociation req.params.userID, result.rows[0].feedid, (err) ->
                return res.status(400).json err if err
                res.status(200).json
                  'message': "successfully followed feed #{result.rows[0].feedname}
                              for userID #{req.params.userID}"

  unfollowFeed: (req, res) ->
    getFeed req.params.feedName, req.params.sourceName, (err, result) ->
      return res.status(400).json err if err
      feed = result.rows[0]
      if feed
        pgClient.query
          text: 'DELETE FROM user_follows_feed WHERE userID = $1 AND feedID = $2',
          values: [req.params.userID, feed.feedid]
        , (err) ->
          return res.status(400).json err if err
          res.status(200).json
            'message': "successfully unfollowed #{req.params.feedName}
                        for #{req.params.userID}"
      else
        res.status(404).json 'message': "#{req.params.feedName} does not exist"

checkValidFeed = (feedName, sourceName, callback) ->
  request "http://localhost:3000/#{sourceName}/posts/#{feedName}", callback

insertFeed = (feedName, sourceName, callback) ->
  pgClient.query
    text: 'INSERT INTO feeds (feedName, sourceName) VALUES ($1, $2)',
    values: [feedName, sourceName]
  , callback

getFeed = (feedName, sourceName, callback) ->
  pgClient.query
    text: 'SELECT * FROM feeds WHERE feedName = $1 AND sourceName = $2',
    values: [feedName, sourceName]
  , callback

createUserFeedAssociation = (userID, feedID, callback) ->
  pgClient.query
    text: 'INSERT INTO user_follows_feed (userID, feedID) VALUES ($1, $2)',
    values: [userID, feedID]
  , callback

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