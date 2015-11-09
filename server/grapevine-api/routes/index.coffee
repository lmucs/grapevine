express  = require 'express'
tokens   = require './tokens'
users    = require './users'
feeds    = require './feeds'
events   = require './events'

router   = express.Router()

# Routes that can be accessed by any one
router.post '/api/v1/users',  users.create
router.post '/api/v1/tokens', tokens.create

#  Routes that can be accessed only by autheticated users
router.get    '/api/v1/feeds',                               feeds.getAll
router.get    '/api/v1/users/:userID/events',                users.getAllEvents
router.get    '/api/v1/users/:userID/events/:after',         users.getLatestEvents
router.post   '/api/v1/users/:userID/feeds',                 users.followFeed
router.delete '/api/v1/users/:userID/feeds/:network/:feed',  users.unfollowFeed

# Routes that can be accessed only by authenticated & authorized users
router.post '/admin/v1/events', events.create

module.exports = router