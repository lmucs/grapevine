jwt      = require 'jwt-simple'
pgClient = require '../../../database/pg-client'

tokens =
  create: (req, res) ->
    getUser req.body.username, req.body.password, (err, user) ->
      return res.status(400).json err if err
      return res.status(401).json 'message': 'invalid credentials' unless user
      token = generateToken user
      res.status(201).json {token, userID: user.user_id}


getUser = (username, password, callback) ->
  pgClient.query
    text: 'SELECT * FROM users WHERE username = $1 AND password = $2',
    values: [username, password]
  , (err, result) ->
    return callback err if err
    callback null, result.rows[0]

generateToken = (user) ->
  expires = expiresIn(7)
  token = jwt.encode { expires, user }, require('../config/secret')()
  token

expiresIn = (numDays) ->
  dateObj = new Date
  dateObj.setDate dateObj.getDate() + numDays


module.exports = tokens