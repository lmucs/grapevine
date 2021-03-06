jwt      = require 'jwt-simple'
pgClient = require '../../../database/pg-client'

tokens =
  create: (req, res) ->
    unless req.body.username and req.body.password
      return res.status(400).json 'message': 'username and password required'
    getUser req.body.username, req.body.password, (err, user) ->
      return res.status(400).json err if err
      return res.status(401).json 'message': 'invalid credentials' unless user
      token = generateToken user
      res.status(201).json {token, userID: user.user_id, username: user.username, firstName: user.first_name, lastName: user.last_name}


getUser = (username, password, callback) ->
  pgClient.query
    text: 'SELECT * FROM users WHERE username = $1 AND password = crypt($2, password);',
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