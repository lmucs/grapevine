//
//  SettingsViewController.swift
//  Grapevine
//
//  Created by Matthew Flickner on 12/21/15.
//  Copyright © 2015 Grapevine. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var userToken: NSToken?
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var showMultiDaySwitch: UISwitch!
    @IBOutlet weak var showAllDaySwitch: UISwitch!
    
    var shouldShowMultiDayEvents: Bool = true
    var shouldShowAllDayEvents: Bool = true
    
    //let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGrapevineButton(logoutButton)
        showMultiDaySwitch.on = self.shouldShowMultiDayEvents
        showAllDaySwitch.on = self.shouldShowAllDayEvents
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutPressed(sender: UIButton!){
        sender.enabled = false
        // would also need to invalid token eventually
        managedObjectContext?.deleteObject(self.userToken!)
        do {
            try managedObjectContext!.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        let loginViewController = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        UIApplication.sharedApplication().keyWindow?.rootViewController = loginViewController
    }
    
    @IBAction func multiDaySwitchToggled(sender: UISwitch){
        sender.enabled = false
        self.shouldShowMultiDayEvents = sender.on
        sender.enabled = true
    }
    
    @IBAction func allDaySwitchToggled(sender: UISwitch){
        sender.enabled = false
        self.shouldShowAllDayEvents = sender.on
        sender.enabled = true
    }
    
    @IBAction func backToSettingsViewController(segue:UIStoryboardSegue){
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "backFromSettings" {
            let eventView = segue.destinationViewController as! EventListViewController
            let navController = eventView.parentViewController as! GrapevineNavigationController
            let tabController = navController.parentViewController as! GrapevineTabViewController
            tabController.shouldShowMultiDayEvents = self.shouldShowMultiDayEvents
            tabController.shouldShowAllDayEvents = self.shouldShowAllDayEvents
            tabController.filterEvents()
            tabController.updateChildViewsData()
        }
    }


}
