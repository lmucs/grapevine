pgClient = require '../../../database/pg-client'

events =
  create: (req, res) ->
    events = req.body.events
    eventsInsertion =
      text: 'INSERT INTO events (is_all_day, end_time_is_known, time_processed, start_time, end_time, processed_info, url, post, feed_id, tags, location, title, author) VALUES '
      values: []
    return res.status(400).json 'message' : 'list of events required' unless events
    index = 1
    numOfAttributes = 13
    for eventToAdd in events
      eventsInsertion.text += "(#{('$'+i for i in [index...index+numOfAttributes]).join(', ')}),"
      index += numOfAttributes
      Array::push.apply eventsInsertion.values, [
        (eventToAdd.isAllDay or false),
        (eventToAdd.endTimeIsKnown or false)
        (eventToAdd.timeProcessed or (new Date).getTime()),
        (eventToAdd.startTime or 0),
        (eventToAdd.endTime or 0),
        (eventToAdd.chronosOutput or null),
        (eventToAdd.url or null),
        (eventToAdd.post or null),
        (eventToAdd.feedID or 1)
        ("{#{(tag for tag in (eventToAdd.tags or [])).join(',')}}")
        ("{#{(locationDetail for locationDetail in (eventToAdd.location or [])).join(',')}}")
        (eventToAdd.title or null)
        (eventToAdd.author or null)
      ]
    eventsInsertion.text = (eventsInsertion.text)[0...eventsInsertion.text.length-1]
    if eventsInsertion.values.length > 0
      pgClient.query eventsInsertion, (err) ->
        return res.status(400).send 'message': err.detail if err
        res.status(201).send 'message' : 'successfully added events'
    else
      res.status(201).send 'message' : 'no new events created'


module.exports = events