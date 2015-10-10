mockEvents  = require './mockEvents'
pg          = require 'pg'

events =
  getAll: (req, res) ->
    pg.connect process.env.DATABASE_URL, (err, client, done) ->
      if err
        done()
        return res.status(500).json {data: err}

      client.query 'INSERT INTO items(text, complete) values($1, $2)', ['foo', 'bar']
      query = client.query('SELECT * FROM items ORDER BY id ASC')
      # Stream results back one row at a time
      query.on 'row', (row) ->
        results.push row
        return
      # After all data is returned, close connection and return results
      query.on 'end', ->
        done()
        res.json results

    # # Spoof a DB call
    # res.json mockEvents

  getOne: (req, res) ->
    # Spoof a DB call
    res.json mockEvents[1]

  create: (req, res) ->
    newEvent = req.body
    # Spoof a DB call
    mockEvents.push newEvent
    res.json newEvent

  update: (req, res) ->
    updatedEvent = req.body
    # Spoof a DB call
    mockEvents[req.params.id] = updatedEvent
    res.json updatedEvent

  delete: (req, res) ->
    # Spoof a DB call
    mockEvents.splice req.params.id, 1
    res.json true


module.exports = events
