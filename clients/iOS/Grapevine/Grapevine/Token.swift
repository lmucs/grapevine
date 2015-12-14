//
//  Token.swift
//  Grapevine
//
//  Created by Matthew Flickner on 10/6/15.
//  Copyright © 2015 Grapevine. All rights reserved.
//

import UIKit
import ObjectMapper

class Token: NSObject, Mappable {
    
    var token: String!
    var userID: Int!
    var username: String!
    var firstName: String!
    var lastName: String!
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        self.token <- map["token"]
        self.userID <- map["userID"]
        self.username <- map["username"]
        self.firstName <- map["firstName"]
        self.lastName <- map["lastName"]
        
    }
    
    
}
