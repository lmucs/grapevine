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
    # check if feed is in feeds
    #    if it is, then create an association with feed and user
    #    else check if it is a valid feed
    #         if valid: insert into feeds
    #         else: return 404 to response
    getFeed req.body?.feedName, req.body?.sourceName, (err, result) ->
      return res.status(400).json err if err
      feedToFollow = result.rows[0]
      console.log feedToFollow
      if feedToFollow
        createUserFeedAssociation req.params.userID, feedToFollow.feedid, (err) ->
          return res.status(400).json err if err
          res.status(200).json 'message' : "successfully followed feed #{feedToFollow.feedname}"
      else
        request "http://localhost:3000/#{req.body?.sourceName}/posts/#{req.body?.feedName}", (err, response, body) ->
          return res.status(400).json err if err
          if response.statusCode is 200
            pgClient.query
              text: 'INSERT INTO feeds (feedName, sourceName) VALUES ($1, $2)',
              values: [req.body?.feedName, req.body?.sourceName]
            , (err) ->
              return res.status(400).json err if err
              getFeed req.body?.feedName, req.body?.sourceName, (err, result) ->
                return res.status(400).json err if err
                console.log result.rows[0]
                createUserFeedAssociation req.params.userID, result.rows[0].feedID, (err) ->
                  return res.status(400).json err if err
                  res.status(200).json 'message': "successfully followed feed #{feedToFollow.feedName}"
          else
            res.status(404).json 'message': "#{req.body?.sourceName} does not contain feed #{req.body?.feedName}"

  unfollowFeed: (req, res) ->
    pgClient.query
      text: 'INSERT INTO user_follows_feed (userID, feedID) VALUES ($1, $2)',
      values: [req.params.userID, req.params.feedID]
    , (err, result) ->
      return res.status(400).json err if err
      res.status(200)

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