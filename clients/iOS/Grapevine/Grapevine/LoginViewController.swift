//
//  LoginViewController.swift
//  Grapevine
//
//  Created by Matthew Flickner on 9/15/15.
//  Copyright (c) 2015 Grapevine. All rights reserved.
//

import UIKit
import SwiftyJSON

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
        
        
        
        
        let loginCredentials = ["username": self.usernameTextField.text!, "password": self.passwordTextField.text!]
        var loginJson = NSJSONSerialization.dataWithJSONObject(
            loginCredentials ,
            options: NSJSONWritingOptions(rawValue: 0)
        )
        
        //sender.enabled = false
        let url = NSURL(string: "http://localhost:8000/login")
        let request = NSURLRequest(URL: url!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            self.activityIndicator.hidden = true
            //perform segue
        }
        
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
