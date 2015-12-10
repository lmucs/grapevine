//
//  EventListTableViewController.swift
//  Grapevine
//
//  Created by Matthew Flickner on 9/15/15.
//  Copyright (c) 2015 Grapevine. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftyJSON
import CVCalendar
import ObjectMapper

class EventListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var userToken: Token!
    var events: [Event] = []
    var lastUpdated: NSDate!
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "My Upcoming Events"
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return events.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("eventCell", forIndexPath: indexPath) as! EventTableViewCell
        let event = self.events[indexPath.row]
        if event.title != nil {
            cell.eventNameLabel.text = event.title
        }
        else {
            cell.eventNameLabel.text = event.author
        }
        
        if !event.isMultiDay {
            cell.eventMultiDayLabel.hidden = true
        }
        else {
            cell.eventMultiDayLabel.hidden = false
        }
        
        
        
        func setDateBoxes(dateTime: CVDate){
            cell.eventMonthLabel.text = monthIntToShortMonthString(self.events[indexPath.row].startTime.dateCV.month)
            cell.eventDayLabel.text = String(self.events[indexPath.row].startTime.dateCV.day)
        }
        
        cell.eventTimeLabel.text = buildEventTimeRange(self.events[indexPath.row])
        setDateBoxes(self.events[indexPath.row].startTime.dateCV)
        return cell

    }
    
    @IBAction func backToEventListViewController(segue:UIStoryboardSegue){
        
    }
    
    @IBAction func updateEvents(sender: UIBarButtonItem){
        sender.enabled = false
        getEventsSince(self.lastUpdated)
        sender.enabled = true
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */
    
    func eventAtIndexPath(path: NSIndexPath) -> Event {
        return self.events[path.row]
    }
    
    // MARK: - Network functions
    
    func getAllUserEvents(){
        
        let getEventsUrl = NSURL(string: apiBaseUrl + "/api/v1/users/" + String(self.userToken.userID!) + "/events")
        let requestHeader: [String: String] = [
            "Content-Type": "application/json",
            "x-access-token": String(self.userToken.token!)
        ]
        print("calling for events now swag")
        Alamofire.request(.GET, getEventsUrl!, encoding: .JSON, headers: requestHeader)
            .responseJSON { response in
                if response.1 != nil {
                    if response.1?.statusCode == 200 {
                        let results = response.2.value! as! NSArray
                        for item in results {
                            debugPrint(item)
                            let responseEvent = Mapper<Event>().map(item)
                            responseEvent?.dateMap(item as! [String : AnyObject])
                            self.events.append(responseEvent!)
                        }
            
                        self.events.sortInPlace({ $0.startTime.dateNS.compare($1.startTime.dateNS) == NSComparisonResult.OrderedAscending })
                        self.tableView.reloadData()
                        self.lastUpdated = NSDate()
                    }
                }
            }

    }
    
    func getEventsSince(date: NSDate){
        let getEventsSinceUrl = NSURL(string: apiBaseUrl + "/api/v1/users/" + String(self.userToken.userID!) + "/events/" + String(Int(self.lastUpdated.timeIntervalSince1970 * 1000)))
        print(getEventsSinceUrl)
        let requestHeader: [String: String] = [
            "Content-Type": "application/json",
            "x-access-token": String(self.userToken.token!)
        ]
        print("calling for new events now swag")
        Alamofire.request(.GET, getEventsSinceUrl!, encoding: .JSON, headers: requestHeader)
            .responseJSON { response in
                debugPrint(response)
                if response.1 != nil {
                    if response.1?.statusCode == 200 {
                        let results = response.2.value! as! NSArray
                        for item in results {
                            debugPrint(item)
                            let responseEvent = Mapper<Event>().map(item)
                            responseEvent?.dateMap(item as! [String : AnyObject])
                            self.events.append(responseEvent!)
                        }
                        
                        self.events.sortInPlace({ $0.startTime.dateNS.compare($1.startTime.dateNS) == NSComparisonResult.OrderedAscending })
                        self.tableView.reloadData()
                        self.lastUpdated = NSDate()
                    }
                }
            }
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "goToCalendar" {
            let nav = segue.destinationViewController as! UINavigationController
            let calendarView = nav.topViewController as! CalendarViewController
            calendarView.events = self.events
        }
        
        if segue.identifier == "goToEventDetailSegue" {
            let path = self.tableView.indexPathForSelectedRow!
            let nav = segue.destinationViewController as! UINavigationController
            let detailView = nav.topViewController as! EventDetailViewController
            detailView.rightBarButton.enabled = false
            detailView.event = eventAtIndexPath(path)
        }
        
        if segue.identifier == "goToFeedManagement" {
            let nav = segue.destinationViewController as! UINavigationController
            let feedView = nav.topViewController as! FeedManagementViewController
            feedView.userToken = self.userToken
            if feedView.myFeeds.count == 0 {
                feedView.getFeeds()
            }
        }
        
        
        
        
    }


}
