//
//  NSToken.swift
//  Grapevine
//
//  Created by Matthew Flickner on 1/22/16.
//  Copyright © 2016 Grapevine. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class NSToken: NSManagedObject {
    
    @NSManaged var token: String!
    @NSManaged var userID: NSNumber!
    @NSManaged var username: String!
    @NSManaged var firstName: String!
    @NSManaged var lastName: String!

    class func createInManagedObjectContext(moc: NSManagedObjectContext, token: Token) -> NSToken {
        let newToken = NSEntityDescription.insertNewObjectForEntityForName("NSToken", inManagedObjectContext: moc) as! NSToken
        newToken.token = token.token
        newToken.userID = token.userID as NSNumber
        newToken.firstName = token.firstName
        newToken.lastName = token.lastName
        
        return newToken
    }
    
}
