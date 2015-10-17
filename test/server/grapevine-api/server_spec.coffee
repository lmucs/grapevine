should   = require 'should'
assert   = require 'assert'
request  = require 'supertest'
sinon    = require 'sinon'

describe 'Social Media API', ->

  before (done) ->
    @app = require '../../../server/grapevine-api/server'
    @db  = require '../../../database/schema'
    @db.register done

  beforeEach (done) ->
    @db.clean done

  after (done) ->
    @db.clean done
    @app.close()

  context 'when an invalid route is used', ->

    it 'responds with a 404 not found', (done) ->
      request 'http://localhost:8000'
        .get '/invalid/route'
        .end (err, res) ->
          throw err if err
          (res.status).should.be.eql 404
          done()

  context 'when a valid route is used', ->


    context 'when a client POSTs to the register endpoint', ->

      context 'when the username or password are omitted', ->
        it 'responds with a 400 bad request', (done) ->
          request 'http://localhost:8000'
            .post '/register'
            .end (err, res, body) ->
              throw err if err
              (res.status).should.be.eql 400
              (res.body.message).should.be.eql 'username and password required'
              done()

      context 'when a valid username and password are given', ->
        it 'responds with a 200 OK, an access token, and the user ID', (done) ->
          request 'http://localhost:8000'
            .post '/register'
            .send {username: 'foo', password: 'bar'}
            .end (err, res, body) ->
              throw err if err
              (res.status).should.be.eql 200

              token = res.body.token
              should.exist token
              ((token.match /[a-z0-9\.\-\_]+/gi)[0]).should.be.eql token

              userID = res.body.userID
              should.exist userID

              done()

      context 'when someone tries to register an existing username', ->
        it 'responds with a 400 bad request', (done) ->
          request 'http://localhost:8000'
            .post '/register'
            .send {username: 'foo', password: 'bar'}
            .end (err, res, body) ->
              throw err if err
              request 'http://localhost:8000'
                .post '/register'
                .send {username: 'foo', password: 'baz'}
                .end (err, res, body) ->
                  throw err if err
                  (res.status).should.be.eql 400
                  done()

    context 'when a client POSTs to the login endpoint', ->

      context 'when the username or password are omitted', ->
        it 'responds with a 401 unauthorized', (done) ->
          request 'http://localhost:8000'
            .post '/login'
            .end (err, res) ->
              throw err if err
              (res.status).should.be.eql 401
              done()