//
//  HelperMethods.swift
//  Grapevine
//
//  Created by Matthew Flickner on 10/22/15.
//  Copyright © 2015 Grapevine. All rights reserved.
//

import Foundation
import CVCalendar

// User feedback on text fields

func setErrorColor(textField: UITextField) {
    let errorColor : UIColor = UIColor.redColor()
    textField.layer.borderColor = errorColor.CGColor
    textField.layer.borderWidth = 1.5
}

func setSuccessColor(textField: UITextField) {
    let successColor : UIColor = UIColor( red: 0.3, green: 0.5, blue:0.3, alpha: 1.0 )
    textField.layer.borderColor = successColor.CGColor
    textField.layer.borderWidth = 1.5
}


func monthIntToMonthString(date: CVDate) -> String {
    switch date.month {
    case 1:
        return "January"
    case 2:
        return "February"
    case 3:
        return "March"
    case 4:
        return "April"
    case 5:
        return "May"
    case 6:
        return "June"
    case 7:
        return "July"
    case 8:
        return "August"
    case 9:
        return "September"
    case 10:
        return "October"
    case 11:
        return "November"
    case 12:
        return "Decemeber"
    default:
        return "Not a month"
    }
}



