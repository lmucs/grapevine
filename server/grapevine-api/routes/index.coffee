express  = require 'express'
auth     = require './auth'
users    = require './users'
events   = require './events'
feeds    = require './feeds'

router   = express.Router()

# Routes that can be accessed by any one
router.post '/register', users.create
router.post '/login',    auth.login

#  Routes that can be accessed only by autheticated users
router.get    '/api/v1/events/:feedID',              events.getAllFromFeed
router.get    '/api/v1/events/:feedID/:timestamp',   events.getLatestFromFeed
router.get    '/api/v1/feeds',                       feeds.getAll
# router.post   '/api/v1/feeds',                       feeds.create
router.get    '/api/v1/users/:userID/feeds',         users.getFeeds
router.post   '/api/v1/users/:userID/feeds',         users.followFeed
router.delete '/api/v1/users/:userID/feeds/:feedID', users.unfollowFeed

# Routes that can be accessed only by authenticated & authorized users
# post event?
# get all users?

module.exports = router
