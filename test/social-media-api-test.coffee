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
    it 'We get response from using URLs', (done) ->
      screenName = "https%3A%2F%2Fwww.facebook.com%2FLMU-English-Department-280903465269783%2Ftimeline"
      requestURL = "#{serverName}#{fbPostURL}#{screenName}"
      request requestURL, (err, res, body) ->
        expect(res.statusCode).to.eql 200


