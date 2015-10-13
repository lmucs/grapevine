expect = require('chai').expect
request = require 'request'

serverName = 'http://localhost:3000/'
twitterURL = 'twitter/posts/'
fbPostURL = 'facebook/posts/'

describe 'Making social media requests', ->
  describe 'when making Twitter API calls', ->
    it 'we get proper response', ->
      screenName = 'lmuhousing'
      requestURL = "#{serverName}#{twitterURL}#{screenName}"
      request requestURL, (err, res, body) ->
        expect(err).to.eql null


  describe 'when making Facebook API calls', ->
    it 'We get response from using URLs', ->
      requestURL = "#{serverName}#{fbPostURL}#{screenName}"
      requestURL += '/' + timeStamp if timeStamp
      request requestURL, (err, res, body) ->
        expect(err).to.eql null
