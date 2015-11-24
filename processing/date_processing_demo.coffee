# load environment variables
dotenv         = require 'dotenv-with-overload'
dotenv._getKeysAndValuesFromEnvFilePath "#{__dirname}/.env"
dotenv._setEnvs()

dateProcessor = require './date-processing'
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

tweetIDs = twitterParams.IDs
sinceID = twitterParams.timeStamp
for id in tweetIDs
  do (id) ->
    dateProcessor.getEventsFromFeed 'twitter', id, sinceID

fbIDs = fbParams.IDs
timeStamp = fbParams.timeStamp
for id in fbIDs
  do (id) ->
    dateProcessor.getEventsFromFeed 'facebook', id, timeStamp


  #   url: "#{databaseAPI}api/v1/tokens"
  #   method: 'POST'
  #   headers:
  #     'content-type': 'application/json'
  #   body: JSON.stringify {username: process.env.USERNAME, password: process.env.PASSWORD}
  # , (err, response, body) ->
  #   throw err if err
  #   console.log body
  #   request
  #     url: "#{databaseAPI}admin/v1/feeds"
  #     method: 'GET'
  #     headers:
  #       'content-type': 'application/json'
  #       'x-access-token': (JSON.parse body).token
  #   , (err, response, body) ->
  #     parsedBody = JSON.parse body
  #     for feed in parsedBody.facebook
  #       console.log feed
  #       dateProcessor.getEventsFromFeed 'facebook', feed.feedName, fbParams.timeStamp
