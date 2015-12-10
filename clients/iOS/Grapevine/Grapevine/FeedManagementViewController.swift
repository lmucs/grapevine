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
import ObjectMapper

class FeedManagementViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var myFeeds: [Feed] = [Feed]()
    var userToken: Token!
    
    
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
        return myFeeds.count
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Add Feed"
        }
        return "My Feeds"
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            //return search cell
            let cell = tableView.dequeueReusableCellWithIdentifier("addFeedCell", forIndexPath: indexPath) as! EventTableViewCell
            tableView.rowHeight = 120
            cell.button.enabled = false
            cell.button.addTarget(self, action: "addFeed:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.segControl.addTarget(self, action: "selectNetwork:", forControlEvents: UIControlEvents.ValueChanged)
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
        tableView.rowHeight = 80
        let cell = tableView.dequeueReusableCellWithIdentifier("feedCell", forIndexPath: indexPath) as! FeedTableViewCell
        cell.feedNameLabel.text = self.myFeeds[indexPath.row].feedName
        if self.myFeeds[indexPath.row].networkName == "facebook" {
            cell.feedNetwork.image = UIImage(named: "facebook_brand_logo")
        }
        else {
            cell.feedNetwork.image = UIImage(named: "twitter_brand_logo")
        }
        
        //cell.addTarget(self, action: "clickFeed:", forControlEvents: UIControlEvents.TouchUpInside)
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        clickFeed(indexPath)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            unfollowFeed(indexPath)
        }
    }
    
    func feedAtIndexPath(path: NSIndexPath) -> Feed {
        return self.myFeeds[path.row]
    }
    
    func clickFeed(path: NSIndexPath){
        let feed = feedAtIndexPath(path)
        let linkStr = feed.buildFeedLinkString()
        UIApplication.sharedApplication().openURL(NSURL(string: linkStr)!)
    }
    
    @IBAction func selectNetwork(sender:UISegmentedControl){
        let indexPath = NSIndexPath(forRow:0, inSection:0)
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! EventTableViewCell
        if cell.textField.text != "" {
            cell.button.enabled = true
        }
        
    }
    
    @IBAction func newFeedNameFieldChanged(sender: UITextField){
        let indexPath = NSIndexPath(forRow:0, inSection:0)
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! EventTableViewCell
        if (cell.textField.text != "" && cell.segControl.selectedSegmentIndex > -1){
            cell.button.enabled = true
        }
        if (cell.textField.text == ""){
            cell.button.enabled = false
        }
    }
    
    
    func facebookOrTwitter(segControl: UISegmentedControl) -> String {
        switch segControl.selectedSegmentIndex {
            case 0:
                return "facebook"
            case 1:
                return "twitter"
            default:
                return "";
        }
    }
    
    
    @IBAction func addFeed(sender: UIButton){
        sender.enabled = false
        
        let indexPath = NSIndexPath(forRow:0, inSection:0)
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! EventTableViewCell
        let feedName = cell.textField.text
        let addFeedUrl = NSURL(string: apiBaseUrl + "/api/v1/users/" + String(self.userToken.userID) + "/feeds")
        
        let feedInfo: [String: AnyObject] = [
            "feedName": String(feedName!),
            "networkName": String(facebookOrTwitter(cell.segControl))
        ]
        let requestHeader: [String: String] = [
            "Content-Type": "application/json",
            "x-access-token": String(self.userToken.token!)
        ]

        if NSJSONSerialization.isValidJSONObject(feedInfo){
            Alamofire.request(.POST, addFeedUrl!, parameters: feedInfo, encoding: .JSON, headers: requestHeader)
                .responseJSON { response in
                    if response.1 != nil {
                        debugPrint(response)
                        if response.1?.statusCode == 201 {
                            print("here")
                            let newFeed = Mapper<Feed>().map(feedInfo as! [String: String])
                            print(newFeed!.feedName)
                            
                            self.myFeeds.insert(newFeed!, atIndex: 0)
                            cell.textField.text = ""
                            cell.segControl.selectedSegmentIndex = -1
                            self.tableView.reloadData()
                            
                        }
                        else {
                            
                            setErrorColor(cell.textField)
                            cell.segControl.selectedSegmentIndex = -1
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
    
    
    func unfollowFeed(indexPath: NSIndexPath){
        let feedToUnfollow = myFeeds[indexPath.row]
        let removeFeedUrl = NSURL(string: apiBaseUrl + "/api/v1/users/" + String(self.userToken.userID) + "/feeds/" + feedToUnfollow.networkName + "/" + feedToUnfollow.feedName)
        let requestHeader: [String: String] = [
            "Content-Type": "application/json",
            "x-access-token": String(self.userToken.token!)
            
        ]
        
        Alamofire.request(.DELETE, removeFeedUrl!, encoding: .JSON, headers: requestHeader)
            .responseJSON { response in
                debugPrint(response)
                if response.1 != nil {
                    if response.1?.statusCode == 200 {
                        print("deleted")
                        self.myFeeds.removeAtIndex(indexPath.row)
                        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                        
                        //let set: NSIndexSet = NSIndexSet(indexesInRange: NSMakeRange(0,2))
                        //self.tableView.reloadSections(set, withRowAnimation: UITableViewRowAnimation.Automatic)
                        
                    }
                }
        }
        
    }
    
    
    func getFeeds(){
        self.myFeeds = [Feed]()
        let getFeedUrl = NSURL(string: apiBaseUrl + "/api/v1/users/" + String(self.userToken.userID) + "/feeds")
        let requestHeader: [String: String] = [
            "x-access-token": String(self.userToken.token!)
        ]
        
        Alamofire.request(.GET, getFeedUrl!, encoding: .JSON, headers: requestHeader)
                .responseJSON { response in
                    debugPrint(response)
                    if response.1 != nil {
                        if response.1?.statusCode == 200 {
                            print("here")
                            let results = response.2.value! as! NSArray
                            for item in results {
                                debugPrint(item)
                                let responseFeed = Mapper<Feed>().map(item)
                                print(responseFeed!.feedName)
                                self.myFeeds.append(responseFeed!)
                            }
                            self.tableView.reloadData()
                        }
                        else {
                            print("didn't get a 200")
                            
                            // handle errors based on response code
                        }
                    }
                    else {
                        print("no response")
                    }
            }
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
