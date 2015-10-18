//
//  CalendarViewController.swift
//  Grapevine
//
//  Created by Matthew Flickner on 10/17/15.
//  Copyright © 2015 Grapevine. All rights reserved.
//

import UIKit
import CVCalendar

class CalendarViewController: UIViewController, CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuView.delegate = self
        self.calendarView.delegate = self
        self.title = (monthIntToMonthString(self.calendarView.presentedDate) + " " + String(self.calendarView.presentedDate.year))
        
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
    
    // CVCalendarView Delegate Functions
    
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
        return true
    }
    
    func dotMarker(colorOnDayView dayView: DayView) -> [UIColor] {
        return [UIColor.redColor()]
    }
    
    
    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
        return 9
    }
    
    func didShowNextMonthView(date: NSDate){
        let cvDate = CVDate(date: date)
        self.title = monthIntToMonthString(cvDate) + " " + String(cvDate.year)
    }
    
    func didShowPreviousMonthView(date: NSDate){
        let cvDate = CVDate(date: date)
        self.title =  monthIntToMonthString(cvDate) + " " + String(cvDate.year)
    }
    
    /*
    * Functions available to be implemented if needed
    
    func shouldShowWeekdaysOut() -> Bool {
    
    }
    
    func didSelectDayView(dayView: DayView){
    
    }
    
    func presentedDateUpdated(date: Date){
    
    }
    
    func topMarker(shouldDisplayOnDayView dayView: DayView) -> Bool {
    
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
    
    //CVCalendar Menu Delegate Optional Functions
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
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
