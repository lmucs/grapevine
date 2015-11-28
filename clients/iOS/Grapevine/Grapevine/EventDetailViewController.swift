//
//  EventDetailViewController.swift
//  Grapevine
//
//  Created by Matthew Flickner on 11/17/15.
//  Copyright © 2015 Grapevine. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {
    
    var event: Event!
    
    @IBOutlet weak var eventLinkButton : UIButton!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var eventTitleLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        if self.event != nil {
            let date = event.startTime.dateCV
            self.eventTitleLabel.text = self.event.title
            self.eventTitleLabel.numberOfLines = 0
            self.eventDateLabel.text = monthIntToMonthString(date) + " " + String(date.day) + ", " + String(date.year)
            self.eventTimeLabel.text = buildEventTimeRange(event)
            self.eventLinkButton.setTitle(self.event.url, forState: .Normal)
            self.eventLinkButton.titleLabel?.numberOfLines = 0
            //self.eventLinkLabel.numberOfLines = 0

        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openLink(sender: AnyObject) {
        var link = eventLinkButton.titleLabel!.text!
        let urlStartHttp: String = "http://"
        let urlStartHttps: String = "https://"
        if !(link.hasPrefix(urlStartHttp) || link.hasPrefix(urlStartHttps)) {
            link = urlStartHttp + link
        }
        print(link)
        UIApplication.sharedApplication().openURL(NSURL(string: link)!)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
