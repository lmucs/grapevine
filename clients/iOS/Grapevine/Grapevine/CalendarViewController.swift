//
//  CalendarViewController.swift
//  Grapevine
//
//  Created by Matthew Flickner on 10/17/15.
//  Copyright © 2015 Grapevine. All rights reserved.
//

import UIKit
import CVCalendar

class CalendarViewController: UIViewController, CVCalendarViewDelegate, CVCalendarMenuViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var events: [Event]!
    var filteredEvents: [Event]!
    var inMonthView: Bool = true
    
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuView.delegate = self
        self.calendarView.delegate = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.title = (monthIntToMonthString(self.calendarView.presentedDate) + " " + String(self.calendarView.presentedDate.year))
        self.filterEvents(Date(date: NSDate()))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
    }
    
    
    @IBAction func changeView(sender: UIBarButtonItem){
        if self.inMonthView {
            self.toWeekView()
            sender.title = "Month"
        }
        else {
            self.toMonthView()
            sender.title = "Week"
        }
    }
    
    func toWeekView() {
        calendarView.changeMode(.WeekView)
        self.inMonthView = false
    }
    
    func toMonthView() {
        calendarView.changeMode(.MonthView)
        self.inMonthView = true
    }
    
    // Mark: - CVCalendarView Delegate Functions
    
    // Required
    func presentationMode() -> CalendarMode {
        return .MonthView
    }
    
    // Required
    func firstWeekday() -> Weekday {
        return .Sunday
    }
    
    func shouldAnimateResizing() -> Bool {
        return true
    }
    
    func shouldScrollOnOutDayViewSelection() -> Bool {
        return true
    }
    
    func shouldAutoSelectDayOnWeekChange() -> Bool {
        return true
    }
    
    func shouldAutoSelectDayOnMonthChange() -> Bool {
        return true
    }
    
    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: DayView) -> Bool {
        return true
    }
    
    func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool {
        for event in self.events {
            if sameDate(event.startTime.dateCV, date2: dayView.date) {
                return true
            }
        }
        return false
    }
    
    func dotMarker(colorOnDayView dayView: DayView) -> [UIColor] {
        return [UIColor.yellowColor()]
    }
    
    
    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
        return 14
    }
    
    func didShowNextMonthView(date: NSDate){
        let cvDate = CVDate(date: date)
        self.title = monthIntToMonthString(cvDate) + " " + String(cvDate.year)
    }
    
    func didShowPreviousMonthView(date: NSDate){
        let cvDate = CVDate(date: date)
        self.title =  monthIntToMonthString(cvDate) + " " + String(cvDate.year)
    }
    
    func didShowNextWeekView(date: NSDate){
        let cvDate = CVDate(date: date)
        self.title = monthIntToMonthString(cvDate) + " " + String(cvDate.year)
    }
    
    func didShowPreviousWeekView(date: NSDate){
        let cvDate = CVDate(date: date)
        self.title = monthIntToMonthString(cvDate) + " " + String(cvDate.year)
    }
    
    func filterEvents(date: Date){
        print("begin filtering")
        self.filteredEvents = []
        for event in events {
            if event.startTime != nil {
                if sameDate(event.startTime.dateCV, date2: date){
                    filteredEvents.append(event)
                }
            }
            else {
                if event.date != nil {
                    if sameDate(event.date, date2: date){
                        filteredEvents.append(event)
                        //need to sort by time
                    }
                }
            }
        }
        self.tableView.reloadData()
    }
    
    func presentedDateUpdated(date: Date){
        print("date updated")
        
        filterEvents(date)
    }
    
    /*
    func topMarker(shouldDisplayOnDayView dayView: DayView) -> Bool {
    
    }
    */
    
    
    /*
    * Functions available to be implemented if needed
    
    func shouldShowWeekdaysOut() -> Bool {
    
    }
    
    
    func dotMarker(moveOffsetOnDayView dayView: DayView) -> CGFloat {
    
    }
    
    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
        
    }
    
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        
    }
    
    func supplementaryView(viewOnDayView dayView: DayView) -> UIView {
        
    }
    
    func supplementaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        
    }
    */
    
    
    // Mark: - CVCalendar Menu Delegate Optional Functions
    
    func dayOfWeekTextUppercase() -> Bool{
        return true
    }
    
    func dayOfWeekTextColor() -> UIColor {
        return UIColor.blackColor()
    }
    
    /*
    * Functions available to be implemented if needed
    func firstWeekday() -> Weekday {
        
    }
    
    func dayOfWeekTextUppercase() -> Bool {
        
    }
    
    func dayOfWeekFont() -> UIFont {
        
    }
    
    func weekdaySymbolType() -> WeekdaySymbolType {
        
    }
    */
    
    
    // Mark: - Table View Delegate Functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if self.filteredEvents != nil {
            return self.filteredEvents.count
        }
        return 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("calendarEventCell", forIndexPath: indexPath) as! EventTableViewCell
        if self.filteredEvents[indexPath.row].title != nil {
            cell.eventNameLabel.text = self.events[indexPath.row].title
        }
        else {
            cell.eventNameLabel.text = "Untitled Event"
        }
        if let loc = self.events[indexPath.row].location {
            cell.eventLocationLabel.text = loc
        }
        else {
            cell.eventLocationLabel.hidden = true
        }
        
        cell.eventTimeLabel.text = buildEventTimeRange(self.filteredEvents[indexPath.row])
        
        return cell
        
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
    
    @IBAction func backToCalendarViewController(segue:UIStoryboardSegue){
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "eventDetailFromCalendar" {
            let nav = segue.destinationViewController as! UINavigationController
            let detailView = nav.topViewController as! EventDetailViewController
            let path = self.tableView.indexPathForSelectedRow!
            detailView.event = eventAtIndexPath(path)
            
        }
    }


}
