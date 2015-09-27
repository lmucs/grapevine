should   = require 'should'
assert   = require 'assert'
request  = require 'supertest'

describe 'Social Media API', ->

  before ->
    @app = require '../../../server/social-media-api/server'

  after ->
    @app.close()

  context 'when a valid route is given', ->

    it 'responds with a 200', (done) ->
      request 'http://localhost:3000'
        .get '/facebook/posts/SampleFeedName'
        .end (err, res) ->
          throw err if err
          (res.status).should.be.eql 404
          done()
  
  context 'when an invalid route is given', ->

    context 'when the route is not prefixed with the 
             name of the social media source (facebook/twitter)', ->
      it 'responds with a 404', (done) ->
        request 'http://localhost:3000'
          .get '/posts/SampleFeedName'         
          .end (err, res) ->
            throw err if err
            (res.status).should.be.eql 404
            done()

    context 'when the route does not specify posts vs events', ->
      it 'responds with a 404', (done) ->
        request 'http://localhost:3000'
          .get '/facebook/SampleFeedName'           
          .end (err, res) ->
            throw err if err
            (res.status).should.be.eql 404
            done()

    context 'when the route does not contain the feed name', ->
      it 'responds with a 404', (done) ->
        request 'http://localhost:3000'
          .get '/twitter/posts'
          .end (err, res) ->
            throw err if err
            (res.status).should.be.eql 404
            done()
