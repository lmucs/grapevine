//
//  ForgotPasswordViewController.swift
//  Grapevine
//
//  Created by Matthew Flickner on 3/11/16.
//  Copyright © 2016 Grapevine. All rights reserved.
//

import UIKit
import Alamofire

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var requestResetButton: UIButton!
    @IBOutlet weak var feedbackLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.feedbackLabel.hidden = true
        self.requestResetButton.enabled = false
        setupGrapevineButton(self.requestResetButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func enableButton(sender: UITextField){
        print("here")
        if isValidEmail(self.emailAddressTextField.text!){
            self.requestResetButton.enabled = true
        }
        else {
            self.requestResetButton.enabled = false
        }
    }
    
    @IBAction func requestResetButtonClicked(sender: UIButton){
        sender.enabled = false
        let email: String = self.emailAddressTextField.text!
        let forgotUrl = apiBaseUrl + "/api/v1/forgot"
        let emailToReset: [String: AnyObject] = [
            "email": email
        ]
        print("api call")
        sender.enabled = true
        /*if NSJSONSerialization.isValidJSONObject(emailToReset){
            Alamofire.request(.POST, forgotUrl, parameters: emailToReset, encoding: .JSON)
                .responseJSON { response in
                    if response.1 != nil {
                        if response.1?.statusCode == 201 {
                            print(response.2.value!)
                            print("here")
                            self.feedbackLabel.text = "Email sent!"
                            setSuccessColor(self.feedbackLabel)
                        }
                        else {
                            print("didn't get a 201")
                            self.feedbackLabel.text = "Incorrect Email Address"
                            sender.enabled = true
                            // handle errors based on response code
                        }
                    }
                    else {
                        print("no response")
                        self.feedbackLabel.text = "Connection Failed"
                        setErrorColor(self.feedbackLabel)
                        sender.enabled = true
                    }
            }
        }
        else {
            //JSON invalid, throw exception
        }
        */

        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
