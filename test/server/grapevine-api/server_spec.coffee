should   = require 'should'
assert   = require 'assert'
request  = require 'supertest'
sinon    = require 'sinon'

describe 'Social Media API', ->

  before ->
    @app = require '../../../server/grapevine-api/server'

  after ->
    @app.close()

  context 'when a valid route is used', ->

    context 'when a client POSTs to the login endpoint', ->

      context 'when the username or password are omitted', ->
        it 'responds with a 401', (done) ->
          request 'http://localhost:8000'
            .post '/login'
            .end (err, res) ->
              throw err if err
              (res.status).should.be.eql 401
              done()

      context 'when the username and password are included', ->
        it 'responds with a 200 and responds with an access token', (done) ->
          request 'http://localhost:8000'
            .post '/login'
            .send {username: "foo", password: "bar"}
            .end (err, res) ->
              throw err if err
              token = res.body.token
              ((token.match /[a-z0-9\.\-\_]+/gi)[0]).should.be.eql token
              done()

  context 'when an invalid route is used', ->

    it 'responds with a 404', (done) ->
      request 'http://localhost:8000'
        .get '/invalidRoute'
        .end (err, res) ->
          throw err if err
          (res.status).should.be.eql 404
          done()