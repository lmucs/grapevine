should   = require 'should'
assert   = require 'assert'
request  = require 'supertest'
sinon    = require 'sinon'

describe 'Grapevine API', ->

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

    context 'when a client POSTs to the /register endpoint', ->

      context 'when the username or password are omitted', ->
        it 'responds with a 400 bad request', (done) ->
          request 'http://localhost:8000'
            .post '/register'
            .end (err, res) ->
              throw err if err
              (res.status).should.be.eql 400
              (res.body.message).should.be.eql 'username and password required'
              done()

      context 'when a valid username and password are given', ->
        it 'responds with a 200 OK, an access token, and the user ID', (done) ->
          request 'http://localhost:8000'
            .post '/register'
            .send {username: 'foo', password: 'bar'}
            .end (err, res) ->
              throw err if err
              (res.status).should.be.eql 200

              token = res.body.token
              should.exist token
              ((token.match /[a-z0-9\.\-\_]+/gi)[0]).should.be.eql token

              userID = res.body.userID
              should.exist userID

              done()

      context 'when someone tries to register an existing username', ->
        beforeEach (done) ->
          request 'http://localhost:8000'
            .post '/register'
            .send {username: 'foo', password: 'bar'}
            .end (err, res) ->
              throw err if err
              done()

        it 'responds with a 400 bad request', (done) ->
          request 'http://localhost:8000'
            .post '/register'
            .send {username: 'foo', password: 'baz'}
            .end (err, res) ->
              throw err if err
              (res.status).should.be.eql 400
              (res.body.message).should.be.eql 'username foo already exists,
                                                please choose another'
              done()

    context 'when a client POSTs to the /login endpoint', ->

      context 'when the username or password are omitted', ->
        it 'responds with a 401 unauthorized', (done) ->
          request 'http://localhost:8000'
            .post '/login'
            .end (err, res) ->
              throw err if err
              (res.status).should.be.eql 401
              (res.body.message).should.be.eql 'invalid credentials'
              done()

      context 'when the given username/password combination
               does not exist in the database', ->
        it 'responds with a 401 unauthorized', (done) ->
          request 'http://localhost:8000'
            .post '/login'
            .send {username: 'invalidUsername', password: 'invalidPassword'}
            .end (err, res) ->
              throw err if err
              (res.status).should.be.eql 401
              (res.body.message).should.be.eql 'invalid credentials'
              done()

      context 'when the given username/password combination
               does exist in the database', ->
        beforeEach (done) ->
          request 'http://localhost:8000'
            .post '/register'
            .send {username: 'foo', password: 'bar'}
            .end (err, res) ->
              throw err if err
              done()

        it 'responds with a 200 OK, an access token, and the user ID', (done) ->
          request 'http://localhost:8000'
            .post '/login'
            .send {username: 'foo', password: 'bar'}
            .end (err, res) ->
              throw err if err
              (res.status).should.be.eql 200

              token = res.body.token
              should.exist token
              ((token.match /[a-z0-9\.\-\_]+/gi)[0]).should.be.eql token

              userID = res.body.userID
              should.exist userID

              done()

    context 'when a client GETs from the /api/v1/feeds endpoint', ->

      context 'when the client omits the access token', ->
        it 'responds with a 401 unauthorized', (done) ->
          request 'http://localhost:8000'
            .get '/api/v1/feeds'
            .end (err, res) ->
              throw err if err
              (res.status).should.be.eql 401
              (res.body.message).should.be.eql 'access token required'
              done()

      context 'when the client does not omit the access token', ->

        context 'when an invalid access token is given', ->
          it 'responds with a 401 unauthorized', (done) ->
            request 'http://localhost:8000'
              .get '/api/v1/feeds'
              .set 'x-access-token', 'invalid-access-token'
              .end (err, res) ->
                throw err if err
                (res.status).should.be.eql 401
                (res.body.message).should.be.eql 'invalid access token'
                done()

        context 'when a valid access token is given', ->
          beforeEach (done) ->
            request 'http://localhost:8000'
              .post '/register'
              .send {username: 'foo', password: 'bar'}
              .end (err, res) =>
                throw err if err
                @token = res.body.token
                done()
          it 'responds with a 200 OK and all feeds Grapevine currently pulls from', (done) ->
            @db.query 'INSERT INTO feeds (feed_name, source_name) VALUES (\'LMUHousing\', \'twitter\')'
            request 'http://localhost:8000'
              .get '/api/v1/feeds'
              .set 'x-access-token', @token
              .end (err, res) ->
                throw err if err
                (res.status).should.be.eql 200
                feeds = res.body
                (feeds.length).should.be.eql 1
                (feeds[0].feed_name).should.be.eql 'LMUHousing'
                (feeds[0].source_name).should.be.eql 'twitter'
                done()



