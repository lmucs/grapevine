express  = require 'express'
users    = require './users'
events   = require './events'
users    = require './users'
# feeds    = require './feeds'

router   = express.Router()

# Routes that can be accessed by any one
router.post '/register', users.register
router.post '/login',    users.login

#  Routes that can be accessed only by autheticated users
# router.get '/api/v1/events', events.get
# router.get '/api/v1/events/:id', events.getOne
# router.get '/api/v1/feeds/:id'
# router.post '/api/v1/feeds' feeds.follow
# router.delete '/api/v1/feeds/:id' feeds.delete

# Routes that can be accessed only by authenticated & authorized users
# router.post '/api/v1/admin/events', events.post
# router.get '/api/v1/admin/users', users.getAll
# router.get '/api/v1/admin/users/:id', user.getOne

module.exports = router
