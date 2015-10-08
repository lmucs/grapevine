fs = require 'fs'
request = require 'request'
chrono = require 'chrono-node'

intervalInSeconds = 5
serverName = 'http://localhost:3000/'
twitterURL = 'twitter/posts/'
fbURL = ''
feeds = ['LoyolaMarymount', 'ACTILMU', 'LMULionTRaXC', 'IggyLion', 'Lmulionspolo',
        'lmuhoops', 'golflmu', 'lmumsoc', 'LMUMTennis', 'RowingLMU', 'lmusoftball', 'lmuwbb', 
        'LMUSWIM', 'lmu_volleyball', 'LMULions', 'burnsreccenter', 'lmu_ministry', 'csa_lmu', 'lmucsla', 
        'CURes_LMU', 'LMU_CBA', 'LMUHospitality', 'lmueis', 'lmuexecutivemba', 'LMUFacSen', 'lmu_fos', 'LMUFinancialaid', 
        'lmugraduate', 'lmugreeklife', 'lmulibrary', 'LMU_History', 'lmucares', 'lmuexp', 'LALoyolan', 'LoyolaLawSchool', 
        'MEforLMU', 'LMUMARCOMM', 'lmumbaprogram', 'lmunewsroom', 'LMUCareers', 'LMU_OISS', 'LMUPlaceCorps', 'lmusoe', 'LMUDoctoral',
        'LMUsftv', 'seaverlmu', 'studyabroadlmu', 'LMUAdmission', 'LMUTower', 'LMUTFANorCal', 'LMUTFALA']

#lastPulled = fs.readFileSync('lastPulled.txt').toString();

twitterProcessing = (screenName, sinceID) ->
  requestURL = "#{serverName}#{twitterURL}#{screenName}"
  #requestURL += sinceID if sinceID
  #events = []
  request requestURL , (err, res, body) ->
    if err 
      console.log 'there was an error in the request'
    tweets = JSON.parse body

    for tweet in tweets
      console.log tweet.text
      parsedTweet = chrono.parse tweet.text
      console.log 'parsedTweet' 
      console.log  parsedTweet

      if parsedTweet.length != 0    
        item = {id: tweet.id, text: tweet.text, feed: tweet.user.screen_name}
        fs.appendFile 'log.txt', JSON.stringify(item, null, 4), (err) ->
          if err
            throw err
          console.log 'The "event" was appended to file!'
          return
      else 
        return 

run = ->
  for feed in feeds 
    twitterProcessing feed
  return
  
setInterval run, 1000 * intervalInSeconds