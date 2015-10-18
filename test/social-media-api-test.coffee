expect = require('chai').expect
request = require 'request'

serverName = 'http://localhost:3000/'
twitterURL = 'twitter/posts/'
fbPostURL = 'facebook/posts/'


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

describe 'Making social media requests', ->
  describe 'when making Twitter API calls', ->
    it 'we get proper response', ->
      screenName = 'lmuhousing'
      requestURL = "#{serverName}#{twitterURL}#{screenName}"
      request requestURL, (err, res, body) ->
        expect(err).to.eql null


  describe 'when making Facebook API calls', ->
    for name in fbScreenNames
      it "We get a 200 from #{name}", (done) ->
        screenName = "https%3A%2F%2Fwww.facebook.com%2F#{name}"
        requestURL = "#{serverName}#{fbPostURL}#{screenName}"
        request requestURL, (err, res, body) ->
          expect(res.statusCode).to.eql 200
          done()


