//
//  AddFeedViewController.swift
//  Grapevine
//
//  Created by Matthew Flickner on 11/24/15.
//  Copyright © 2015 Grapevine. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftyJSON

class FeedManagementViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var myFeeds: [String]!
    var token: Token!
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
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
        else {
            if myFeeds != nil {
                return myFeeds.count
            }
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            //return search cell
            let cell = tableView.dequeueReusableCellWithIdentifier("addFeedCell", forIndexPath: indexPath) as! EventTableViewCell
            tableView.rowHeight = 90
            cell.button.enabled = false;
            cell.button.addTarget(self, action: "addFeed:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.segControl.addTarget(self, action: "facebookOrTwitter:", forControlEvents: UIControlEvents.ValueChanged)
            return cell
        }
        tableView.rowHeight = 44
        let cell = tableView.dequeueReusableCellWithIdentifier("feedCell", forIndexPath: indexPath) as! EventTableViewCell
        cell.button.addTarget(self, action: "removeFeed:", forControlEvents: UIControlEvents.TouchUpInside)
        return cell
        
    }
    
    @IBAction func selectNetwork(sender:UISegmentedControl) {
        let indexPath = NSIndexPath(forRow:0, inSection:0)
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! EventTableViewCell
        cell.button.enabled = true
        print(facebookOrTwitter(sender))
        
    }
    
    func facebookOrTwitter(segControl: UISegmentedControl) -> String {
        switch segControl.selectedSegmentIndex {
            case 0:
                return "Facebook"
            case 1:
                return "Twitter"
            default:
                return "";
        }
    }
    
    
    @IBAction func addFeed(sender: UIButton){
        sender.enabled = false
        
        let indexPath = NSIndexPath(forRow:0, inSection:0)
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! EventTableViewCell
        let feedName = cell.textField.text
        let addFeedUrl = NSURL(string: apiBaseUrl + "api/v1/users/" + String(self.token.userID) + "/feeds")
        let feedInfo: [String: AnyObject] = [
            "feedName": String(feedName),
            "networkName": String(facebookOrTwitter(cell.segControl))
        ]
        
        /*
        let requestHeaders: [String: String] = [
            
        ]
        */

        if NSJSONSerialization.isValidJSONObject(feedInfo){
            Alamofire.request(.POST, addFeedUrl!, parameters: feedInfo, encoding: .JSON/*, headers: */)
                .responseJSON { response in
                    if response.1 != nil {
                        print("response printing")
                        debugPrint(response)
                        if response.1?.statusCode == 200 {
                            print("here")
                            
                        }
                        else {
                            print("didn't get a 200")
                            setErrorColor(cell.textField)
                            sender.enabled = true
                            // handle errors based on response code
                            
                        }
                    }
                    else {
                        print("no response")
                        sender.enabled = true
                        
                    }
                    
            }
        }
        else {
            print("JSON serialization failed, we should never be here")
        }

        
        
    }
    
    @IBAction func unfollowFeed(sender: UIButton){
        print("unfollow support coming soon")
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
