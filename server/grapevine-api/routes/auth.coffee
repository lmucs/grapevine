jwt      = require 'jwt-simple'
pgClient = require '../pg-client'

auth =
  register: (req, res) ->
    checkForExistingUsername req.body.username, (err, usernameExists) ->
      return res.status(400).json err if err
      return res.status(400).json 'message' : 'username already exists' if usernameExists
      insertUser req.body.username, req.body.password, (err) ->
        return res.status(400).json err if err
        res.status(200).json 'message': 'user successfully created'

  login: (req, res) ->
    retrieveUser req.body.username, req.body.password, (err, user) ->
      return res.status(401).json err if err
      res.status(200).json generateToken user

  validateUser: (username) ->
    # spoofing the DB response for simplicity
    dbUser =
      role: 'admin'
      username: 'rachel'
    dbUser

insertUser = (username, password, callback) ->
  pgClient.query
    text: 'INSERT INTO users (username, password) VALUES ($1, $2)',
    values: [username, password]
  , callback

checkForExistingUsername = (username, callback) ->
  pgClient.query
    text: 'SELECT * FROM users where username = $1',
    values: [username]
  , (err, result) ->
    return callback err if err
    return callback null, true if result.rows.length > 0
    callback null, false

retrieveUser = (username, password, callback) ->
  pgClient.query
    text: 'SELECT * FROM users WHERE username = $1 AND password = $2',
    values: [username, password]
  , (err, result) ->
    return callback err if err
    return callback 'message' : 'invalid credentials' if result.rows.length is 0
    callback null, result.rows[0]

generateToken = (user) ->
  expires = expiresIn(7)
  token = jwt.encode { expires }, require('../config/secret')()
  {token, username: user.username, userID: user.userid, expires}

expiresIn = (numDays) ->
  dateObj = new Date
  dateObj.setDate dateObj.getDate() + numDays

module.exports = auth