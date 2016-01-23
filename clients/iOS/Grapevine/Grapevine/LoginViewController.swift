//
//  LoginViewController.swift
//  Grapevine
//
//  Created by Matthew Flickner on 9/15/15.
//  Copyright (c) 2015 Grapevine. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import CVCalendar
import CoreData

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginFailedLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var userToken: Token!
    var appUser: User!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(managedObjectContext)
        let testToken = NSEntityDescription.insertNewObjectForEntityForName("NSToken", inManagedObjectContext: self.managedObjectContext!) as! NSToken
        testToken.userID = 1
        //testToken.username = "djFlicky"
        testToken.firstName = "Matt"
        testToken.lastName = "Flickner"
        
        
         // Do any additional setup after loading the view.
        self.activityIndicator.hidden = true
        self.loginFailedLabel.hidden = true
        setupGrapevineButton(self.loginButton)
        setVisualStrings()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let fetchRequest = NSFetchRequest(entityName: "NSToken")
        
        do {
            let fetchResults = try managedObjectContext!.executeFetchRequest(fetchRequest) as? [NSToken]
            
            let alert = UIAlertController(title: fetchResults![0].firstName, message: fetchResults![0].lastName, preferredStyle: .Alert)
                
            self.presentViewController(alert, animated: true, completion: nil)
        }
        catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setVisualStrings(){
        self.usernameTextField.placeholder = NSLocalizedString("Username", comment: "")
        self.passwordTextField.placeholder = NSLocalizedString("Password", comment: "")
        self.loginButton.setTitle(NSLocalizedString("Login", comment: ""), forState: .Normal)
        self.createAccountButton.setTitle(NSLocalizedString("Create Account", comment: ""), forState: .Normal)
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    
    @IBAction func backToLoginViewController(segue:UIStoryboardSegue) {
        
    }
    

    @IBAction func loginPressed(sender: UIButton){
        
        func loginFailed(){
            self.activityIndicator.hidden = true
            self.loginFailedLabel.hidden = false
            setErrorColor(self.usernameTextField)
            setErrorColor(self.passwordTextField)
            sender.enabled =  true
        }
        
        sender.enabled = false
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
        
    
        let loginUrl = NSURL(string: apiBaseUrl + "/api/v1/tokens")
        
        let loginCredentials: [String: AnyObject] = [
            "username": String(self.usernameTextField.text!),
            "password": String(self.passwordTextField.text!)
        ]
        
        self.appUser = Mapper<User>().map(loginCredentials)
        
        if NSJSONSerialization.isValidJSONObject(loginCredentials){
            Alamofire.request(.POST, loginUrl!, parameters: loginCredentials, encoding: .JSON)
                .responseJSON { response in
                    if response.1 != nil {
                        print("debug response printing")
                        debugPrint(response)
                        if response.1?.statusCode == 201 {
                            print(response.2.value!)
                            print("here")
                            
                            let responseToken = Mapper<Token>().map(response.2.value)
                            print("Response token is \(responseToken!.token) \n")
                            self.userToken = responseToken
                            print("UserID is \(self.userToken.userID)")
                            self.appUser.userID = self.userToken.userID
                            
                            self.performSegueWithIdentifier("loginSegue", sender: self)
                        }
                        else {
                            print("didn't get a 201")
                            self.loginFailedLabel.text = "Invalid Credentials"
                            loginFailed()
                            self.appUser = nil
                            // handle errors based on response code
                            
                        }
                    }
                    else {
                        print("no response")
                        self.loginFailedLabel.text = "Connection Failed"
                        loginFailed()
                        self.appUser = nil
                        
                    }
                    
            }
        }
        else {
            //JSON invalid, throw exception
        }

    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "loginSegue" {
            let tab = segue.destinationViewController as! GrapevineTabViewController
            let navEvent = tab.childViewControllers[0] as! GrapevineNavigationController
            //let navEvent = segue.destinationViewController as! GrapevineNavigationController
            let eventsView = navEvent.topViewController as! EventListViewController
            tab.userToken = self.userToken
            eventsView.userToken = self.userToken
            tab.getAllUserEvents()

        
        }
    }
   
    
}