//
//  StartTime.swift
//  Grapevine
//
//  Created by Matthew Flickner on 11/27/15.
//  Copyright © 2015 Grapevine. All rights reserved.
//

import UIKit
import CVCalendar

class EventTime: NSObject {
    
    var hour: Int!
    var minute: Int!
    var dateCV: CVDate!
    var dateNS: NSDate!
    
    func setAll(date: NSDate){
        self.dateCV = CVDate(date: date)
        self.dateNS = date
        self.hour = NSCalendar.currentCalendar().component(NSCalendarUnit.Hour, fromDate: date)
        print(self.hour)
        self.minute = NSCalendar.currentCalendar().component(NSCalendarUnit.Minute, fromDate: date)
    }
    
    func setHour(date: NSDate){
        self.hour = NSCalendar.currentCalendar().component(NSCalendarUnit.Hour, fromDate: NSDate())
    }
    
    func setMinute(date: NSDate){
        self.minute = NSCalendar.currentCalendar().component(NSCalendarUnit.Minute, fromDate: NSDate())
    }
    
    func setHourAndMinute(date: NSDate){
        setHour(date)
        setMinute(date)
    }
    
    func minuteToString() -> String {
        if self.minute > 9 {
            return String(self.minute)
        }
        return "0" + String(self.minute)
        
    }

}
