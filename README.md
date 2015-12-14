<img src="https://github.com/lmucs/grapevine/blob/master/images/grapevine.PNG?raw=true" width=90 height=90>
# Grapevine


Grapevine is an application that automatically populates a user's calendar with events from Twitter and Facebook. Events are extracted by an intelligent agent that listens to feeds that the user follows.

## Extracting Events
Users provide Grapevine with a list of feeds on Facebook and Twitter that they wish to follow. We pull any new posts and tweets from Facebook and Twitter and identify meaningful events.

<img src="https://github.com/lmucs/grapevine/blob/master/images/frozen-fb-post-cropped.png">

 If there is a date in the post, then it is an event.
 
 <img src="https://github.com/lmucs/grapevine/blob/master/images/frozen-fb-post-faded-cropped.png">


If it finds any events, it stores them and pushes the events to the user. These events are put on the user's Grapevine calendar.

TODO - Insert calendar views of the same event for Android, iOS, and web.

Events have information such as start time and end time, tags, who posted the event, and a link to the original post.




TODO - server info, App Store / Google Play info

TODO - getting your own installation, npm install ....

## About

It was created as part of the CMSI 401 class at Loyola Marymount University during the fall 2015 semester. Check out the [wiki](https://github.com/lmucs/grapevine/wiki) and the [final presentation](http://rtoal.github.io/cmsi401-fall2015-presentation/#/18).

**The Team**

* Rachel Rivera
* Nicole Anguiano
* Cameron Billingham
* Juan Carrillo
* Jeff Fennell
* Matt Flickner
* Joaquín Loustau

## Acknowledgments
Grapevine makes use of the following libraries, without which Grapevine would be impossible.
* [Chrono-Node](https://github.com/wanasit/chrono)
* [NLTK Python Libraries](http://www.nltk.org/)
* [Caldroid](https://github.com/roomorama/Caldroid)
* [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper)
* [Alamofire](https://github.com/Alamofire/Alamofire)
* [AlamofireObjectMapper](https://github.com/tristanhimmelman/AlamofireObjectMapper)
* [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
* [CVCalendar](https://github.com/Mozharovsky/CVCalendar)
* [CocoaPods](https://cocoapods.org/)
