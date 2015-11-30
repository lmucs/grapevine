fs = require 'fs'
jsesc = require 'jsesc'

#run date-processing getEventsDemo() before running this script

path = "event_objects.txt"
newPath = "corpus-log.txt"

results = []
idSeen = {}
idSeenValue = {}

process = (filename) ->
   raw_objs_string = fs.readFileSync filename
   raw_objs_string = raw_objs_string.toString 'utf8'
   raw_objs_string = raw_objs_string.replace(/}{/g, '},{') #insert a comma between each object
   objs_string = "[#{raw_objs_string}]" #wrap in a list, to make valid json
   objs = JSON.parse(objs_string)  #parse json

   for obj in objs
      do (obj) ->
         id = obj.URL
         if idSeen[id] != idSeenValue
            results.push obj.post
            idSeen[id] = idSeenValue
   return results

process(path)

console.log results.length

for result in results
   do (result) ->
      result = "\n" + jsesc result
      fs.appendFileSync newPath, result