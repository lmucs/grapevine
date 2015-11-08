request = require 'request'
fs = require 'fs'
intervalInSeconds = 10
serverName = 'http://localhost:3000/'
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
lastTweetID = "650742578401011100"

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

fbTimeStamp = new Date(2015,9,31).toISOString()

twitterParams =
  IDs: twitterScreenNames
  timeStamp: lastTweetID

fbParams =
  IDs: fbScreenNames
  timeStamp: fbTimeStamp

getEvents = ->
  getTwitterEvents()
  getFBEvents()

getEventsDemo = ->
  tweetIDs = twitterParams.IDs
  sinceID = twitterParams.timeStamp
  for id in tweetIDs
    do(id) ->
      getEventsFromTweets id, sinceID

  fbIDs = fbParams.IDs
  timeStamp = fbParams.timeStamp
  for id in fbIDs
    do(id) ->
      getEventsFromFBPosts id, timeStamp

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
      getEventsFromFBPosts name, timeStamp for id in ids
      callback()
  ]

getEventsFromTweets = (screenName, sinceID) ->
  requestURL = "#{serverName}#{twitterURL}#{screenName}"
  requestURL += '/' + sinceID if sinceID
  request requestURL, (err, res, body) ->
    if res.statusCode is 200
      events = processRawTweets JSON.parse body
      writeEventsToFile(events, 'event_objects.txt')

getEventsFromFBPosts = (screenName, timeStamp) ->
  requestURL = "#{serverName}#{fbPostURL}#{screenName}"
  requestURL += '/' + timeStamp if timeStamp
  request requestURL, (err, res, body) ->
    if res.statusCode is 200 and JSON.parse(body).data?
      rawPosts = JSON.parse(body).data
      console.log JSON.parse body
      events = processRawPosts rawPosts, screenName
      console.log events
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

# Make sure all dates are UNIX timestamps in milliseconds
# Stringify the processedInfo into a string
# Get rid of events from a previous day or from today
extractEvents = (text, postInfo) ->
  events = []
  parsedDate = chrono.parse text
  for date in parsedDate
    myEvent = {}
    myEvent.start_time = date.start.date().getTime()
    myEvent.end_time = date.end.date().getTime() if date.end
    myEvent.post = text
    myEvent.URL = postInfo.url
    myEvent.author = postInfo.author
    myEvent.processedInfo = JSON.stringify date
    events.push myEvent
  events

exports.getEventsFromSocialFeeds = getEvents

getEventsDemo()