jwt      = require 'jwt-simple'
pgClient = require '../pg-client'

auth =

  # register: (req, res) ->

  login: (req, res) ->
    validatedUser = auth.getValidatedUser req.body.username, req.body.password
    if validatedUser
      res.json generateToken validatedUser
    else
      res.status(401).json 'message': 'Invalid credentials'

  getValidatedUser: (username, password) ->
    pgClient.query {
      text: 'SELECT * FROM users WHERE username = $1 AND password = $2',
      values: [username, password]
    }, (err, result) ->
      console.log result.rows[0]

    # # spoofing the DB response for simplicity
    # return {} unless username and password
    # dbUser =
    #   role: 'admin'
    #   username: 'rachel'
    # dbUser

  validateUser: (username) ->
    # spoofing the DB response for simplicity
    dbUser =
      role: 'admin'
      username: 'rachel'
    dbUser

generateToken = (user) ->
  expires = expiresIn(7)
  token = jwt.encode { expires }, require('../config/secret')()
  {token, user, expires}

expiresIn = (numDays) ->
  dateObj = new Date
  dateObj.setDate dateObj.getDate() + numDays

module.exports = auth