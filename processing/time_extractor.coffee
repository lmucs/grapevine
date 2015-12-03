chrono = require 'chrono-node'

exports.extractTimeAttributes = (text, timeCreated) ->
  # chrono extracts relative date information given the post and the time the post was created
  # ('tomorrow' means something different depending on when the post was created)
  parsedDates = chrono.parse text, new Date timeCreated
  if parsedDates.length > 0
    #TODO: fix this hack
    chronosDateInfo = parsedDates[parsedDates.length - 1]
    post:           text
    timeProcessed:  new Date().getTime()
    chronosOutput:  JSON.stringify chronosDateInfo
    isAllDay:       not chronosDateInfo.start.knownValues.hour?
    endTimeIsKnown: chronosDateInfo.end?
    startTime:      chronosDateInfo.start.date().getTime()
    endTime:        chronosDateInfo.end?.date().getTime() or 0
  else
    null
