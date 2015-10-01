//
//  Event.swift
//  Grapevine
//
//  Created by Matthew Flickner on 9/29/15.
//  Copyright © 2015 Grapevine. All rights reserved.
//

import UIKit

class Event: NSObject {
    var title: String
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
    
    init(title: String){
        self.title = title
        super.init()
    }
    
    init(title: String, url: String) {
        self.title = title
        self.url = url
        super.init()
    }
    
    
}
