//
//  AddFeedViewController.swift
//  Grapevine
//
//  Created by Matthew Flickner on 11/24/15.
//  Copyright © 2015 Grapevine. All rights reserved.
//

import UIKit

class FeedManagementViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var myFeeds: [String]!
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Mark: - Table View Delegate Functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if section == 0 {
            return 1
        }
        else if myFeeds != nil {
            return myFeeds.count
        }
        return 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            //return search cell
            let cell = tableView.dequeueReusableCellWithIdentifier("calendarEventCell", forIndexPath: indexPath) as! EventTableViewCell
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("calendarEventCell", forIndexPath: indexPath) as! EventTableViewCell
        return cell
        
    }
    
    @IBAction func addFeed(sender: UIButton){
        sender.enabled = false
        
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
