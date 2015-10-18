request = require 'request'
intervalInSeconds = 5
serverName = 'http://localhost:3000/'
twitterURL = 'twitter/posts/'
fbPostURL = 'facebook/posts/'
chrono = require 'chrono-node'

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
  "roarnetwork"
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


fbTimeStamp = new Date().getTime()

###twitterParams =
  IDs: twitterScreenNames
  timeStamp: lastTweetID
###

fbParams =
  IDs: fbScreenNames
  timeStamp: fbTimeStamp

extractEvents = (text, author) ->
  events = []
  parsedDate = chrono.parse text
  for date in parsedDate
    myEvent = {}
    myEvent.startTime = date.start.date()
    myEvent.endTime = date.end.date() if date.end
    myEvent.text = text
    myEvent.author = author
    myEvent.processedInfo = date
    events.push myEvent
  console.log "We finished doing it for #{author}"
  console.log events
  events

processRawTweets = (tweets) ->
  events = []
  console.log tweets
  for tweet in tweets
    tweetText = tweet.text
    author = tweet.user.screen_name
    events = [events..., extractEvents(tweetText, author)...]
  events

processRawPosts = (posts, screenName) ->
  events = []
  for post in posts
    postText = post.message
    events = [events..., extractEvents(postText, screenName)...]
  events

getEventsFromTweets = (screenName, sinceID) ->
  requestURL = "#{serverName}#{twitterURL}#{screenName}"
  requestURL += '/' + sinceID if sinceID
  request requestURL, (err, res, body) ->
    events = processRawTweets JSON.parse body
    console.log events

getEventsFromFBPosts = (screenName, timeStamp) ->
  console.log "We want the stuff from #{screenName}"
  requestURL = "#{serverName}#{fbPostURL}#{screenName}"
  requestURL += '/' + timeStamp if timeStamp
  request requestURL, (err, res, body) ->
    console.log 'We got the stuff!!'
    rawPosts = JSON.parse(body).data
    console.log rawPosts
    events = processRawPosts rawPosts, screenName
    console.log events

getEventsFromSocialFeeds = ( fbParams) ->
  #twitterNames = twitterParams.IDs
  #twitterTimeStamp = twitterParams.timeStamp
  fbNames = fbParams.IDs
  console.log fbNames
  fbTimeStamp = fbParams.timeStamp
  #getEventsFromTweets name, twitterTimeStamp for name in twitterNames
  getEventsFromFBPosts name, fbTimeStamp for name in fbNames


setInterval getEventsFromSocialFeeds(fbParams),
  1000 * intervalInSeconds