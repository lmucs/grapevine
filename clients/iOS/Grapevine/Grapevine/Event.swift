//
//  Event.swift
//  Grapevine
//
//  Created by Matthew Flickner on 9/29/15.
//  Copyright © 2015 Grapevine. All rights reserved.
//

import UIKit
import ObjectMapper

class Event: NSObject, Mappable {
    var title: String!
    //var date: NSDate
    //var status: String
    //var id: Int
    //var timeProcessed: NSDate
    //var location: Location
    //var startTime: NSDate
    //var endTime: NSDate
    //var repeatsWeekly: Bool
    //var tags: [String]
    var url: String!
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        url <- map["url"]
    }
    
    
}
