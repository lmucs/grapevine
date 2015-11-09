jwt      = require 'jwt-simple'
pgClient = require '../../../database/pg-client'

module.exports = (req, res, next) ->

  getDecodedToken = (token) ->
    unless token
      res.status(401).json 'message': 'access token required'
      return null
    try
      decodedToken = jwt.decode token, require('../config/secret')()
      if decodedToken.exp <= Date.now
        res.status(400).json 'message': 'access token has expired'
        return null
      return decodedToken
    catch err
      res.status(401).json 'message': 'invalid access token'
      return null

  # no authentication or authorization required for these routes
  return next() if req.method is 'POST' and
                   req.url in ['/api/v1/tokens', '/api/v1/users']

  # can't continue unless we can decode the given access token
  decodedToken = getDecodedToken req.headers['x-access-token']
  return unless decodedToken

  retrieveUser decodedToken.user.username, (err, user) ->
    return res.status(400).json err if err
    if user
      if req.url.indexOf 'admin' >= 0 and user.role is 'admin' or
         req.url.indexOf 'admin' < 0
        return next()
      else
        res.status(403).json 'message': 'not authorized'
    else
      res.status(401).json 'message': 'invalid user'


retrieveUser = (username, callback) ->
  pgClient.query
    text: 'SELECT * FROM users WHERE username = $1',
    values: [username]
  , (err, result) ->
    return callback err if err
    callback null, result.rows[0]