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
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         // Do any additional setup after loading the view.
        self.activityIndicator.hidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //link back from CreateAccountVC
    @IBAction func backToLoginViewController(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func login(sender: UIButton){
        print("login button pressed")
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
        sender.enabled = false
        
        
        let url = NSURL(string: "http://localhost:8000/login")
        
        let loginCredentials: [String: AnyObject] = [
            "username": String(self.usernameTextField.text),
            "password": String(self.passwordTextField.text)
        ]
        print("here")
        //if NSJSONSerialization.isValidJSONObject(loginCredentials){
            Alamofire.request(.POST, url!, parameters: loginCredentials, encoding: .JSON)
                .responseJSON { response in
                    print("Response JSON: \(response)")
            }
            /* if login valid {
             *     query for events
             *     perform segue to main page
             * }
             * else {
             *     sender.enabled = true
             *     activityIndicator.hidden = true
             * }
            */
            
        //}
        //else {
            // throw JSON encoding exception
        //}
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "loginSegue" {
            //any actions required for login go here
            
        }
        
    }


}
