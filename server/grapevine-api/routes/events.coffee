pgClient = require '../../../database/pg-client'

events =
  create: (req, res) ->
    events = req.body?.events
    for eventToAdd in events
      console.log eventToAdd
    res.status(200).json 'blah': 'blah'



module.exports = events
