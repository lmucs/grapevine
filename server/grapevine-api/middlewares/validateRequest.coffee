jwt = require 'jwt-simple'
retrieveUser = require('../routes/auth').retrieveUser

module.exports = (req, res, next) ->
  token = req.body?.access_token or
          req.query?.access_token or
          req.headers['x-access-token']

  return res.status(401).json 'message': 'access token required' unless token

  try
    decoded = jwt.decode token, require('../config/secret')()
    return res.status(400).json 'message': 'access token has expired.' if decoded.exp <= Date.now()
    retrieveUser decoded.user.username, (err, user) ->
      return res.status(400).json err if err
      if user
        if req.url.indexOf 'admin' >= 0 and user.role is 'admin' or
           req.url.indexOf 'admin' < 0
          next()
        else
          res.status(403).json 'message': 'not authorized'
      else
        res.status(401).json 'message': 'invalid user'
  catch err
    res.status(400).json 'message': err

