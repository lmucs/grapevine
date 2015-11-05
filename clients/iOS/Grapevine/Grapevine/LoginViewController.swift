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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         // Do any additional setup after loading the view.
        self.activityIndicator.hidden = true
        self.loginFailedLabel.hidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //link back from CreateAccountVC
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
        
    
        let loginUrl = NSURL(string: apiBaseUrl + "/login")
        
        let loginCredentials: [String: AnyObject] = [
            "username": String(self.usernameTextField.text!),
            "password": String(self.passwordTextField.text!)
        ]
        
        debugPrint(loginCredentials)
        
        print("here")
        if NSJSONSerialization.isValidJSONObject(loginCredentials){
            Alamofire.request(.POST, loginUrl!, parameters: loginCredentials, encoding: .JSON)
                .responseJSON { response in
                    if response.1 != nil {
                        print("debug response printing")
                        debugPrint(response)
                        if response.1?.statusCode == 200 {
                            print(response.2.value)
                            let responseToken = Mapper<Token>().map(response.2.value)
                            print("Response token is \(responseToken!.token) \n")
                            self.userToken = responseToken
                            print("Token Object is \(self.userToken.token)")
                            self.performSegueWithIdentifier("loginSegue", sender: self)
                        }
                        else {
                            print("didn't get a 200")
                            self.loginFailedLabel.text = "Invalid Credentials"
                            loginFailed()
                            // handle errors based on response code
                            
                        }
                    }
                    else {
                        print("no response")
                        self.loginFailedLabel.text = "Connection Failed"
                        loginFailed()
                        
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
            let nav = segue.destinationViewController as! UINavigationController
            let eventsView = nav.topViewController as! EventListTableViewController
            print("about to perform segue")
            //print("\(self.userToken.token)")
            //print("\(self.userToken.xkey)")
            let getAllEventsLink = "http://localhost:8000/api/v1/users/:userID/events"
            //var = Mapper().toJSON(self.userToken)
            
            
            
        }
    }
   
    
}