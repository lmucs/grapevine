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
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        token <- map["token"]
    }
    
    
}
