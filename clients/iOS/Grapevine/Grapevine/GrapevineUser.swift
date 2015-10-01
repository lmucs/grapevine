//
//  GrapevineUser.swift
//  Grapevine
//
//  Created by Matthew Flickner on 10/1/15.
//  Copyright © 2015 Grapevine. All rights reserved.
//

import UIKit

class GrapevineUser: NSObject {
    
    var username: String
    var password: String
    
    init(username: String, password: String){
        self.username = username
        self.password = password
    }
    
    func toJson(){
        
    }

}
