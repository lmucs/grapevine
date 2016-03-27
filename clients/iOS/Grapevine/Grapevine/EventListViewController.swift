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

class EventListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITabBarControllerDelegate {
    
    var userToken: NSToken!
    var events = [Event]()
    var searchFilteredEvents = [Event]()
    var lastUpdated: NSDate!
    var refreshView: UIView!
    var refreshControl = UIRefreshControl()
    
    var tabBarView: GrapevineTabViewController!
    
    var isShowingMultiDayEvents: Bool = true
    var isShowingAllDayEvents: Bool = true
    var searchActive: Bool = false
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        
        let imageView = UIImageView(image:textLogoSmall)
        imageView.contentMode = .ScaleAspectFit
        self.navigationItem.titleView = imageView
        
        
        if let parent = self.navigationController as? GrapevineNavigationController {
            if let grandparent = parent.tabBarController as? GrapevineTabViewController {
                self.tabBarView = grandparent
                tabBarView.delegate = self
            }
        }
        else {
            // we should not get here
        }
        
        self.refreshControl.addTarget(self, action: #selector(updateEvents), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView?.addSubview(refreshControl)
        loadCustomRefreshContents()
        self.refreshControl.beginRefreshing()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadCustomRefreshContents() {
        let refreshContents = NSBundle.mainBundle().loadNibNamed("RefreshView", owner: self, options: nil)
        self.refreshView = refreshContents[0] as! UIView
        self.refreshView.frame = refreshControl.bounds
        self.refreshControl.addSubview(refreshView)
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        if let navController = viewController as? GrapevineNavigationController {
            if let eventsList = navController.topViewController as? EventListViewController {
                eventsList.tableView.setContentOffset(CGPoint.zero, animated:true)
            }
        }
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("My Upcoming Events", comment: "")
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if self.refreshControl.refreshing && self.searchActive {
            return self.searchFilteredEvents.count + 1
        }
        if self.refreshControl.refreshing {
            return self.events.count
        }
        if self.searchActive {
            if self.events.count == 0 {
                return 1
            }
            return self.searchFilteredEvents.count
        }
        if self.events.count == 0 {
            return 1
        }
        return self.events.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        func setupEventCell() -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("eventCell", forIndexPath: indexPath) as! EventTableViewCell
            var event = self.events[indexPath.row]
            if searchActive {
                event = self.searchFilteredEvents[indexPath.row]
            }
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
        
        
        func setupOtherCell(cellText: String, animateIndicator: Bool) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("noEventsCell", forIndexPath: indexPath) as! NoEventsTableViewCell
            cell.label.text = cellText
            if animateIndicator {
                cell.activityIndicator.startAnimating()
            }
            else {
                cell.activityIndicator.hidden = true
                cell.leftImage.hidden = true
                cell.rightImage.hidden = true
            }
            cell.label.numberOfLines = 0
            return cell
        }
        
        if self.refreshControl.refreshing && self.events.count == 0  {
            if indexPath.row == 0 {
                let userWelcome: String = self.userToken!.firstName! + " " + self.userToken!.lastName!
                let cellText: String = String(format: NSLocalizedString("Loading Events Now", comment: ""), userWelcome)
                return setupOtherCell(cellText, animateIndicator: false)
            }
            return setupEventCell()
        }

        
        if self.events.count == 0 {
            let userWelcome: String = self.userToken.firstName + " " + self.userToken.lastName!
            let cellText: String = String(format: NSLocalizedString("You have no events", comment: ""), userWelcome)
            return setupOtherCell(cellText, animateIndicator: false)
        }
        
        return setupEventCell()

    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            removeEvent(indexPath.row)
        }
    }
    
    func removeEvent(row: Int) {
        let indexPath = NSIndexPath(forItem: row, inSection: 0)
        if searchActive {
            let eventToRemove = self.searchFilteredEvents[row]
            self.searchFilteredEvents.removeAtIndex(row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            for (index, event) in self.events.enumerate(){
                if event.eventId == eventToRemove.eventId {
                    print(self.events[index].title)
                    self.events.removeAtIndex(index)
                    break
                }
            }
        }
        else {
            self.events.removeAtIndex(row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        
        self.tabBarView.myEvents = self.events
        self.tabBarView.calendarView.events = self.events
        //self.tableView.reloadData()
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
    
    func eventAtIndexPath(path: NSIndexPath) -> Event {
        if searchActive {
            return self.searchFilteredEvents[path.row]
        }
        return self.events[path.row]
    }
    
    // MARK: - SearchBar
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        if self.refreshControl.refreshing {
            self.searchActive = false
        }
        else {
            self.searchActive = true
        }
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.searchActive = false
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchActive = false
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchActive = false
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // Later will implement keeping certain event in if they still match the search string
        self.searchFilteredEvents.removeAll()
        if self.events.count == 0 {
            return
        }
        for event in self.events {
            if (event.title.lowercaseString.rangeOfString(searchText.lowercaseString) != nil ||
                event.author.lowercaseString.rangeOfString(searchText.lowercaseString) != nil ||
                event.description.lowercaseString.rangeOfString(searchText.lowercaseString) != nil)
            {
                self.searchFilteredEvents.append(event)
            }
        }
        if self.searchFilteredEvents.count == 0 {
            self.searchActive = false
        }
        else {
            self.searchActive = true
        }
        self.tableView.reloadData()
    }
    
    // MARK: - IBActions
    
    @IBAction func backToEventListViewController(segue:UIStoryboardSegue){
        
    }
    
    @IBAction func updateEvents(sender: AnyObject){
        tabBarView.getEventsSince(self.lastUpdated)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "goToEventDetailSegue" {
            let path = self.tableView.indexPathForSelectedRow!
            let nav = segue.destinationViewController as! GrapevineNavigationController
            let detailView = nav.topViewController as! EventDetailViewController
            //detailView.rightBarButton.enabled = false
            detailView.event = eventAtIndexPath(path)
        }
        
        if segue.identifier == "goToSettings" {
            let nav = segue.destinationViewController as! GrapevineNavigationController
            let settingsView = nav.topViewController as! SettingsTableViewController
            settingsView.userToken = self.userToken
            settingsView.shouldShowMultiDayEvents = self.isShowingMultiDayEvents
            settingsView.shouldShowAllDayEvents = self.isShowingAllDayEvents
        }
        
        
        
        
    }


}
