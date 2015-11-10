pgClient = require '../../../database/pg-client'

events =
  create: (req, res) ->
    eventsInsertion =
      text: 'INSERT INTO events (title, time_processed, location, start_time, end_time, author, processed_info, tags, url, post, feed_id) VALUES '
      values: []
    events = req.body.events
    return res.status(400).json 'message' : 'list of events required' unless events
    for eventToAdd in events
      eventsInsertion.text += '($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11),'
      Array::push.apply eventsInsertion.values, [(eventToAdd.title or null),
                                                 (eventToAdd.timeProcessed or null),
                                                 (eventToAdd.location or null),
                                                 (eventToAdd.startTime or null),
                                                 (eventToAdd.endTime or null),
                                                 (eventToAdd.author or null),
                                                 (eventToAdd.processedInfo or null),
                                                 (eventToAdd.tags or null),
                                                 (eventToAdd.url or null),
                                                 (eventToAdd.post or null),
                                                 (eventToAdd.feedID or 1)]
    eventsInsertion.text = (eventsInsertion.text)[0...eventsInsertion.text.length-1]
    pgClient.query eventsInsertion, (err) ->
      return res.status(400).send 'message': err.detail if err
      res.status(200).send 'message' : 'successfully added events'

module.exports = events