# load environment variables
dotenv         = require 'dotenv-with-overload'
dotenv._getKeysAndValuesFromEnvFilePath "#{__dirname}/.env"
dotenv._setEnvs()

request = require 'request'
fs = require 'fs'
intervalInSeconds = 10
serverName = 'http://localhost:3000/'
databaseAPI = 'http://localhost:8000/'
twitterURL = 'twitter/posts/'
fbPostURL = 'facebook/posts/'
chrono = require 'chrono-node'
async = require 'async'


twitterScreenNames = [
  'ACTILMU'
  'LMULionTRaXC'
  'IggyLion'
  'Lmulionspolo'
  'lmuhoops'
  'golflmu'
  'lmumsoc'
  'LMUMTennis'
  'RowingLMU'
  'lmusoftball'
  'LMUStrength'
  'lmuwbb'
  'LMUSWIM'
  'lmu_volleyball'
  'LMULions'
  'burnreccenter'
  'lmu_ministry'
  'csa_lmu'
  'lmucsla'
  'CURes_LMU'
  'LMU_CBA'
  'LMUHospitality'
  'lmueis'
  'lmuexecutivemba'
  'LMUFacSen'
  'lmu_fos'
  'LMUFinancialaid'
  'lmugraduate'
  'lmugreeklife'
  'lmulibrary'
  'LMU_History'
  'lmucares'
  'lmuexp'
  'LALoyolan'
  'LoyolaLawSchool'
  'LoyolaMarymount'
  'MEforLMU'
  'LMUMARCOMM'
  'lmumbaprogram'
  'lmunewsroom'
  'LMUCareers'
  'LMU_OISS'
  'LMUPlaceCorps'
  'roarstudios'
  'lmusoe'
  'LMUDoctoral'
  'LMUsftv'
  'seaverlmu'
  'lmuhousing'
  'studyabroadlmu'
  'LMUTFALA'
  'LMUTFANorCal'
  'LMUTower'
  'tsehai'
  'LMUAdmission'
]


fbScreenNames = [
  "actilmu"
  "groups/lmuaaaa"
  "lmualumni"
  "lmustararhs"
  "aspalmu"
  "LMUWomensVolleyball"
  "LMULionTRaXC"
  "lmumensbasketball"
  "GolfLMU"
  "LMUMTennis"
  "LMURowing"
  "LoyolaMarymountUniversitySoftball"
  "LMUSwimming"
  "LMUWomensBasketball"
  "LMUWomensSoccer"
  "LMUWomensTennis"
  "LmuWomensWaterPolo"
  "LMULions"
  "BiologyLMU"
  "LmuBurnsRecreationCenter"
  "lmucampusmin"
  "LMUCAST"
  "groups/39893463773"
  "lmucrs"
  "LMUCSA"
  "LMUCSLA"
  "lmucures"
  "lmucba"
  "lmucommunityrelations"
  "LMUCS"
  "LMUConferences"
  "LMUdanceprogram"
  "lmuhospitality"
  "LMU-English-Department-280903465269783"
  "LMUEIS"
  "LMUEMBA"
  "LMUExtension"
  "LMUFacultySenate"
  "lmufos"
  "LMUGradAdmission"
  "lmugreeklife"
  "lmulibrary"
  "LMUHistoryDepartment"
  "leadershiplmu"
  "LMUInternationalOutreach"
  "irishstudieslmu"
  "KXLU889"
  "Laband-Art-Gallery-255909641096056"
  "LmuLatinoAlumniAssociation"
  "lmulionparents"
  "lmucares"
  "lmusoe"
  "LosAngelesLoyolan"
  "LoyolaLawSchool"
  "LLSAlumniNetwork"
  "lmula"
  "LMU-M-School-497182070316821"
  "ManeEntertainmentLMU"
  "Marymount-Institute-Press-180302548725093"
  "LMUMBAProgram"
  "lmucareers"
  "oisslmu"
  "lmupols"
  "lmuschoolpsychology"
  "roarstudiosla"
  "LMUDoctoral"
  "LMUSFTV"
  "LMUCenterforStudentSuccess"
  "lmuseaver"
  "LMUStudentHousing"
  "LMUTFANorCal"
  "tsehaipublishers"
  "lmuadmission"
  "lmuyoga"
  "lmuyogastudies"
]

lastTweetID = "650742578401011100"
fbTimeStamp = new Date(2015, 9, 31).toISOString()

twitterParams =
  IDs: twitterScreenNames
  timeStamp: lastTweetID

fbParams =
  IDs: fbScreenNames
  timeStamp: fbTimeStamp

exports.getEventsDemo = ->
  tweetIDs = twitterParams.IDs
  sinceID = twitterParams.timeStamp
  for id in tweetIDs
    do (id) ->
      getEventsFromTweets id, sinceID

  fbIDs = fbParams.IDs
  timeStamp = fbParams.timeStamp
  for id in fbIDs
    do (id) ->
      getEventsFromFBFeed id, timeStamp

getEvents = ->
  request {url: "#{databaseAPI}/api/v1/tokens"} , (err, res) ->
    options =
      url: '#{databaseAPI}/api/v1/feeds'
      headers: 'x-access-token': res.body.token
    request options, (err, res) ->
      console.log res

getTwitterEvents = ->
  ids = []
  sinceID = null
  events = []
  async.series [
    (callback) ->
      ## Make API CAll
      ids = resultsOfCall.id
      sinceID = resultsOfCall.sinceID
      callback()
    (callback) ->
      getEventsFromTweets name, sinceID for id in ids
      callback()
  ]

getFBEvents = ->
  ids = []
  timeStamp = null
  events = []
  async.series [
    (callback) ->
      ## Make API CAll
      ids = resultsOfCall.id
      timeStamp = resultsOfCall.timeStamp
      callback()
    (callback) ->

      getEventsFromFBFeed name, timeStamp for id in ids
      callback()
  ]

setIntervalX = (callback, delay, repetitions) ->
  counter = 0
  intervalID = setInterval((->
    callback()
    if ++counter == repetitions
      clearInterval intervalID
    return
  ), delay)
  return

getEventsFromTweets = (screenName, sinceID) ->
  requestURL = "#{serverName}#{twitterURL}#{screenName}"
  requestURL += '/' + sinceID if sinceID
  request requestURL, (err, res, body) ->
    if res.statusCode is 200
      events = processRawTweets JSON.parse body
      request
        url: "#{databaseAPI}api/v1/tokens"
        method: 'POST'
        headers:
          'content-type': 'application/json'
        body: JSON.stringify {username: process.env.USERNAME, password: process.env.PASSWORD}
      , (err, response, body) ->
        throw err if err
        request
          url: "#{databaseAPI}admin/v1/events"
          method: 'POST'
          headers:
            'content-type': 'application/json'
            'x-access-token': (JSON.parse body).token
          body: JSON.stringify({'events': events})
        , (err, response, body) ->
          console.log err
          console.log body

getEventsFromFBFeed = (screenName, timeStamp) ->
  requestURL = "#{serverName}#{fbPostURL}#{screenName}"
  requestURL += '/' + timeStamp if timeStamp
  console.log "request URL #{requestURL}"
  request requestURL, (err, res, body) ->
    if res.statusCode is 200 and JSON.parse(body).data?
      rawPosts = JSON.parse(body).data
      events = processRawPosts rawPosts, screenName
      console.log "WRITING EVENTS TO A FILE"
      writeEventsToFile(events, 'event_objects.txt')

writeEventsToFile = (events, path) ->
  for event in events
    fs.appendFile path, JSON.stringify(event, null, 4), (err) ->
      throw err if err

processRawTweets = (tweets) ->
  events = []
  for tweet in tweets
    tweetText = tweet.text
    author = tweet.user.screen_name
    url = getTwitterURL(author, tweet.id_str)
    tweetInfo = {url, author}
    events = [events..., extractEvents(tweetText, tweetInfo)...]
  events

processRawPosts = (posts, author) ->
  events = []
  for post in posts
    postText = post.message ? ""
    url = getFacebookURL(post.id)
    postInfo = {author, url}
    events = [events..., extractEvents(postText, postInfo)...]
  events

getFacebookURL = (id) ->
  [user, post] = id.split("_")
  "https://www.facebook.com/#{user}/posts/#{post}"

getTwitterURL = (screenName, tweetID) ->
  "https://twitter.com/#{screenName}/status/#{tweetID}"

# Get rid of events that have already happened
extractEvents = (text, postInfo) ->
  events = []
  parsedDates = chrono.parse text
  currentTime = (new Date).getTime()
  for date in parsedDates
    startDate = date.start.date()
    if startDate.getTime() > currentTime
      events.push
        timeProcessed: new Date().getTime()
        startTimeIsKnown: date.start.knownValues.hour?
        endTimeIsKnown: date.end?
        startTime: startDate.getTime()
        endTime: if date.end then date.end.date().getTime() else null
        post: text
        url: postInfo.url
        author: postInfo.author
        processedInfo: JSON.stringify date
        tags: [] #TODO: CLASSIFIER WORK HERE
  events


exports.getEventsFromSocialFeeds = getEvents
exports.getEventsFromFBFeed = getEventsFromFBFeed
exports.getEventsFromTweets = getEventsFromTweets

