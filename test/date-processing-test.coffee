expect = require('chai').expect
chrono = require 'chrono-node'
refDate = new Date 2015, 8, 5

describe 'Chrono Parse ', ->
  describe 'when parsing forms of the same day', ->
    it 'parses them correctly', ->
      nextSunday = new Date 2015, 8, 6, 12
      sundayFull = chrono.parse('Next Sunday', refDate)[0].start.date()
      sundayShort = chrono.parse('Next sun', refDate)[0].start.date()
      expect(sundayFull).to.eql nextSunday
      expect(sundayShort).to.eql nextSunday

      nextMonday = new Date 2015, 8, 7, 12
      mondayFull = chrono.parse('Next Monday', refDate)[0].start.date()
      mondayShort = chrono.parse('Next mon', refDate)[0].start.date()
      expect(mondayFull).to.eql nextMonday
      expect(mondayShort).to.eql nextMonday

      nextTuesday = new Date 2015, 8, 8, 12
      tuesdayFull = chrono.parse('Next Tuesday', refDate)[0].start.date()
      tuesdayShort = chrono.parse('Next tues', refDate)[0].start.date()
      expect(tuesdayFull).to.eql nextTuesday
      expect(tuesdayShort).to.eql nextTuesday

      nextWednesday = new Date 2015, 8, 9, 12
      wednesdayFull = chrono.parse('Next Wednesday', refDate)[0].start.date()
      wednesdayShort = chrono.parse('Next wed', refDate)[0].start.date()
      expect(wednesdayFull).to.eql nextWednesday
      expect(wednesdayShort).to.eql nextWednesday

      nextThursday = new Date 2015, 8, 10, 12
      thursdayFull = chrono.parse('Next Thursday', refDate)[0].start.date()
      thursdayShort = chrono.parse('Next thur', refDate)[0].start.date()
      expect(thursdayFull).to.eql nextThursday
      expect(thursdayShort).to.eql nextThursday

      nextFriday = new Date 2015, 8, 11, 12
      fridayFull = chrono.parse('Next Friday', refDate)[0].start.date()
      fridayShort = chrono.parse('Next fri', refDate)[0].start.date()
      expect(fridayFull).to.eql nextFriday
      expect(fridayShort).to.eql nextFriday

      nextSaturday = new Date 2015, 8, 12, 12
      saturdayFull = chrono.parse('Next Saturday', refDate)[0].start.date()
      saturdayShort = chrono.parse('Next sat', refDate)[0].start.date()
      expect(saturdayFull).to.eql nextSaturday
      expect(saturdayShort).to.eql nextSaturday

  describe 'when a date has a starting and ending time', ->
    it 'it will infer the meridian correctly if start hour is less than end hour', ->
      testString = 'Today from 5-7pm we will be be eating ice cream.'
      parsedDate = chrono.parse(testString, refDate)
      startTime  = parsedDate[0].start.date()
      endTime    = parsedDate[0].end.date()
      expect(startTime).to.eql new Date 2015, 8, 5, 17
      expect(endTime).to.eql new Date 2015, 8, 5, 19

    it 'it crosses over from am to pm', ->
      testString = 'Today from 11am-2pm we will be be eating ice cream.'
      parsedDate = chrono.parse(testString, refDate)
      startTime  = parsedDate[0].start.date()
      endTime    = parsedDate[0].end.date()
      expect(startTime).to.eql new Date 2015, 8, 5, 11
      expect(endTime).to.eql new Date 2015, 8, 5, 14

    it 'it can infer am for start time if start time is greater than end pm time', ->
      testString = 'Today from 11-2pm we will be be eating ice cream.'
      parsedDate = chrono.parse(testString, refDate)
      startTime  = parsedDate[0].start.date()
      endTime    = parsedDate[0].end.date()
      expect(startTime).to.eql new Date 2015, 8, 5, 11
      expect(endTime).to.eql new Date 2015, 8, 5, 14

    it 'it can go detect if an event goes from one day to another', ->
      testString = 'Today from 11pm-2am we will be eating ice cream.'
      parsedDate = chrono.parse(testString, refDate)
      startTime  = parsedDate[0].start.date()
      endTime    = parsedDate[0].end.date()
      expect(startTime).to.eql new Date 2015, 8, 5, 23
      expect(endTime).to.eql new Date 2015, 8, 6, 2

