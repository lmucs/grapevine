jwt      = require 'jwt-simple'
pgClient = require '../../../database/pg-client'

module.exports = (req, res, next) ->

  token = req.headers['x-access-token']
  return res.status(401).json 'message': 'access token required' unless token

  try
    decodedToken = jwt.decode token, require('../config/secret')()
    return res.status(400).json 'message': 'access token has expired.' if decodedToken.exp <= Date.now()
    retrieveUser decodedToken.user.username, (err, user) ->
      return res.status(400).json err if err
      if user
        if req.url.indexOf('admin') >= 0 and user.role is 'admin' or
           req.url.indexOf('admin') < 0
          next()
        else
          res.status(403).json 'message': 'forbidden'
      else
        res.status(401).json 'message': 'invalid user'
  catch err
    res.status(401).json 'message': 'invalid access token'



retrieveUser = (username, callback) ->
  pgClient.query
    text: 'SELECT * FROM users WHERE username = $1',
    values: [username]
  , (err, result) ->
    return callback err if err
    callback null, result.rows[0]