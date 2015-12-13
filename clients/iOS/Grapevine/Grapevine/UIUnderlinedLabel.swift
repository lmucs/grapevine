//
//  UIUnderlinedLabel.swift
//  Grapevine
//
//  Created by Matthew Flickner on 12/9/15.
//  Copyright © 2015 Grapevine. All rights reserved.
//

import UIKit

class UIUnderlinedLabel: UILabel {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    //credit to http://stackoverflow.com/questions/28053334/how-to-underline-a-uilabel-in-swift
    override var text: String! {
        didSet {
            if text != nil {
                let textRange = NSMakeRange(0, text.characters.count)
                let attributedText = NSMutableAttributedString(string: text)
                attributedText.addAttribute(NSUnderlineStyleAttributeName , value:NSUnderlineStyle.StyleSingle.rawValue, range: textRange)
                // Add other attributes if needed
                self.attributedText = attributedText
            }
        }
    }

}
