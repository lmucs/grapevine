//
//  Feed.swift
//  Grapevine
//
//  Created by Matthew Flickner on 12/7/15.
//  Copyright © 2015 Grapevine. All rights reserved.
//

import UIKit
import ObjectMapper

class Feed: NSObject, Mappable {
    
    var networkName: String!
    var feedName: String!
    
    // Required to implement ObjectMapper
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        self.networkName <- map["network_name"]
        self.feedName <- map["feed_name"]
        self.networkName <- map["networkName"]
        self.feedName <- map["feedName"]
    }
    
    func buildFeedLinkString() -> String {
        if self.networkName == "facebook" {
            return "https://www.facebook.com/" + self.feedName
        }
        if self.networkName == "twitter" {
            return "https://www.twitter.com/" + self.feedName
        }
        
        return ""
    }
}
