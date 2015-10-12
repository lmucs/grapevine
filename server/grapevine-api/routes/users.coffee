jwt      = require 'jwt-simple'
pgClient = require '../pg-client'

users =
  register: (req, res) ->
    users.retrieveUser {username: req.body.username}, (err, user) ->
      return res.status(400).json err if err
      return res.status(400).json 'message' : 'username already exists' if user
      insertUser req.body.username, req.body.password, (err) ->
        return res.status(400).json err if err
        res.status(200).json 'message': 'user successfully created'

  login: (req, res) ->
    users.retrieveUser {username: req.body.username, password: req.body.password}, (err, user) ->
      return res.status(400).json err if err
      return res.status(401).json err if err unless user
      res.status(200).json generateToken user

  retrieveUser: ({username, password}, callback) ->
    queryForUser =
      text: 'SELECT * FROM users WHERE username = $1',
      values: [username]
    if password
      queryForUser.text += 'AND password = $2'
      queryForUser.values.push password
    pgClient.query queryForUser, (err, result) ->
      return callback err if err
      callback null, result.rows[0]

insertUser = (username, password, callback) ->
  pgClient.query
    text: 'INSERT INTO users (username, password) VALUES ($1, $2)',
    values: [username, password]
  , callback

generateToken = (user) ->
  expires = expiresIn(7)
  token = jwt.encode { expires }, require('../config/secret')()
  {token, username: user.username, userID: user.userid, expires}

expiresIn = (numDays) ->
  dateObj = new Date
  dateObj.setDate dateObj.getDate() + numDays

module.exports = users