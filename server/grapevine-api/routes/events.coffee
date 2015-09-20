events = 
  getAll: (req, res) ->
    # Spoof a DB call
    res.json mockEvents

  getOne: (req, res) ->
    # Spoof a DB call
    res.json mockEvents[0]

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

mockEvents = [
  {
    title: 'basketball game'
    date: '09/15/2015'
    status: 'going to happen'
    id: 123
    timestamp: Date.now()
    location: 'auditorium'
    startTime: 1442261000
    endTime: 1442264714
    repeatsWeekly: false
    tags: ['sports']
    URL: 'example.com/tweet123'
  }
  {
    title: 'party'
    date: '09/20/2015'
    status: 'going to happen'
    id: 456
    timestamp: Date.now()
    location: 'pool'
    startTime: 1442261000
    endTime: 1442264714
    repeatsWeekly: false
    tags: []
    URL: 'example.com/FBpost456'
  }
]

module.exports = events
