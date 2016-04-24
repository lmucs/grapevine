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
    
    var userToken: Token?
    var storedToken: NSToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.hidden = true
        self.loginFailedLabel.hidden = true
        setupGrapevineButton(self.loginButton)
        setVisualStrings()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(animated: Bool) {
        fetchToken()
        self.view.hidden = true
        if storedToken != nil {
            self.performSegueWithIdentifier("loginSegue", sender: self)
        }
        self.view.hidden = false
        super.viewDidAppear(animated)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func storeToken(token: Token){
        if let moc = managedObjectContext {
            NSToken.createInManagedObjectContext(moc, token: token)
        }
        // save the context
        do {
            try managedObjectContext!.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func fetchToken(){
        let fetchRequest = NSFetchRequest(entityName: "NSToken")
        do {
            let fetchResults = try managedObjectContext!.executeFetchRequest(fetchRequest) as? [NSToken]
            if fetchResults != nil {
                print(fetchResults!.count)
                if fetchResults!.count == 1 {
                    print(fetchResults![0].firstName)
                    self.storedToken = fetchResults![0]
                }
            }
        }
        catch let error as NSError  {
            print("Could not fetch \(error), \(error.userInfo)")
        }
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
    
    func loginFailed(){
        self.activityIndicator.hidden = true
        self.loginFailedLabel.hidden = false
        setErrorColor(self.usernameTextField)
        setErrorColor(self.passwordTextField)
        self.loginButton.enabled =  true
    }
    
    func login(){
        let loginUrl = NSURL(string: apiBaseUrl + "/api/v1/tokens")
        
        let loginCredentials: [String: AnyObject] = [
            "username": String(self.usernameTextField.text!),
            "password": String(self.passwordTextField.text!)
        ]
        
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
                            self.storeToken(responseToken!)
                            self.userToken = responseToken
                            
                            print("Response token is \(responseToken!.token) \n")
                            print("UserID is \(self.userToken!.userID)")
                            
                            self.performSegueWithIdentifier("loginSegue", sender: self)
                        }
                        else {
                            print("didn't get a 201")
                            self.loginFailedLabel.text = "Invalid Credentials"
                            self.loginFailed()
                            // handle errors based on response code
                        }
                    }
                    else {
                        print("no response")
                        self.loginFailedLabel.text = "Connection Failed"
                        self.loginFailed()
                    }
            }
        }
        else {
            //JSON invalid, throw exception
        }
    }
    

    @IBAction func loginPressed(sender: UIButton){
        sender.enabled = false
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
        login()
    }
    
    @IBAction func backToLoginViewController(segue:UIStoryboardSegue) {
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "loginSegue" {
            let tab = segue.destinationViewController as! GrapevineTabViewController
            let navEvent = tab.childViewControllers[0] as! GrapevineNavigationController
            let eventsView = navEvent.topViewController as! EventListViewController
            
            self.fetchToken()
            
            print(self.storedToken!.userID!)
            print(self.storedToken!.lastName!)
            
            tab.userToken = self.storedToken!
            eventsView.userToken = self.storedToken!
            tab.getAllUserEvents()

        
        }
    }
   
    
}