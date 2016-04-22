//
//  CreateAccountViewController.swift
//  Grapevine
//
//  Created by Matthew Flickner on 9/15/15.
//  Copyright (c) 2015 Grapevine. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import CoreData

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var feedbackLabel: UILabel!
    
    var userToken: Token!
    var storedToken: NSToken?
    var appUser: User!
    var goodToCreate = [String : Bool]()
    let firstName = "firstName"
    let lastName = "lastName"
    let username = "userName"
    let email = "email"
    let password = "password"
    let repeatPassword = "repeatPassword"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.feedbackLabel.hidden = true
        self.activityIndicator.hidden = true
        setupGrapevineButton(self.createAccountButton)
        disableGrapevineButton(self.createAccountButton)
        setVisualStrings()
        loadGoodToCreate()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateAccountViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func setVisualStrings(){
        self.firstNameTextField.placeholder = NSLocalizedString("First Name", comment: "")
        self.lastNameTextField.placeholder = NSLocalizedString("Last Name", comment: "")
        self.usernameTextField.placeholder = NSLocalizedString("Username", comment: "")
        self.passwordTextField.placeholder = NSLocalizedString("Password", comment: "")
        self.repeatPasswordTextField.placeholder = NSLocalizedString("Repeat Password", comment: "")
        self.emailAddressTextField.placeholder = NSLocalizedString("Email Address", comment: "")
        
        self.createAccountButton.setTitle(NSLocalizedString("Create Account", comment: ""), forState: .Normal)
    }
    
    func loadGoodToCreate(){
        self.goodToCreate[firstName] = false
        self.goodToCreate[lastName] = false
        self.goodToCreate[username] = false
        self.goodToCreate[password] = false
        self.goodToCreate[repeatPassword] = false
        self.goodToCreate[email] = false
    }
    
    func checkFields(){
        for (_, boolean) in goodToCreate {
            if boolean == false {
                return
            }
        }
        enableGrapevineButton(self.createAccountButton)
        
    }
    
    func nameCheck(nameField: UITextField) -> Bool {
        if nameField.text != "" {
            return true
        }
        return false
    }
    
    @IBAction func firstNameDone(sender: AnyObject) {
        if nameCheck(self.firstNameTextField) {
            setSuccessColor(self.firstNameTextField)
            self.goodToCreate[firstName] = true
            checkFields()
            return
        }
        setErrorColor(self.firstNameTextField)
    }
    
    @IBAction func lastNameDone(sender: AnyObject) {
        if nameCheck(self.lastNameTextField){
            setSuccessColor(lastNameTextField)
            self.goodToCreate[lastName] = true
            checkFields()
            return
        }
        setErrorColor(lastNameTextField)
    }
    
    func isValidUsername(testStr: String) -> Bool {
        let usernameRegEx = "^[a-z0-9_-]{3,16}$"
        let usernameTest = NSPredicate(format:"SELF MATCHES %@", usernameRegEx)
        return usernameTest.evaluateWithObject(testStr)
    }
    
    func usernameCheck(usernameField: UITextField) -> Bool{
        usernameField.text = usernameField.text!.lowercaseString
        if isValidUsername(usernameField.text!) {
            setSuccessColor(usernameField)
            return true
        }
        else {
            setErrorColor(usernameField)
            return false
        }
    }
    
    @IBAction func usernameDone(sender : AnyObject) {
        if (isValidUsername(self.usernameTextField.text!) && usernameCheck(self.usernameTextField)){
            setSuccessColor(self.usernameTextField)
            self.goodToCreate[username] = true
            checkFields()
            return
        }
        setErrorColor(self.usernameTextField)
    }
    
    func isValidPassword(testStr: String) -> Bool {
        let passwordRegEx = "^[a-z0-9_-]{8,256}$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluateWithObject(testStr)
    }
    
    
    func passwordsMatch() -> Bool{
        if self.passwordTextField.text == self.repeatPasswordTextField.text {
            return true
        }
        return false
    }
    
    @IBAction func passwordDone(sender: AnyObject) {
        if isValidPassword(self.passwordTextField.text!) {
            if(self.repeatPasswordTextField.text != ""){
                if passwordsMatch(){
                    setSuccessColor(self.repeatPasswordTextField)
                    self.goodToCreate[repeatPassword] = true
                }
                else {
                    setErrorColor(self.repeatPasswordTextField)
                    setErrorColor(self.passwordTextField)
                    return
                }
            }
            setSuccessColor(self.passwordTextField)
            self.goodToCreate[password] = true
            checkFields()
            return
        }
        setErrorColor(self.passwordTextField)
        
    }
    
    @IBAction func repeatPasswordDone(sender: AnyObject) {
        if isValidPassword(self.repeatPasswordTextField.text!) {
            if(self.passwordTextField.text != ""){
                if passwordsMatch(){
                    setSuccessColor(self.passwordTextField)
                    self.goodToCreate[password] = true
                }
                else {
                    setErrorColor(self.repeatPasswordTextField)
                    setErrorColor(self.passwordTextField)
                    return
                }
            }
            setSuccessColor(self.repeatPasswordTextField)
            self.goodToCreate[repeatPassword] = true
            checkFields()
            return
        }
        setErrorColor(repeatPasswordTextField)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // credit to http://stackoverflow.com/questions/27998409/email-phone-validation-in-swift/27998447#27998447
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
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
    
    
    @IBAction func emailDone(sender: AnyObject) {
        let emailField = self.emailAddressTextField
        if isValidEmail(emailField.text!){
            setSuccessColor(emailField)
            self.goodToCreate[email] = true
            checkFields()
            return
        }
        setErrorColor(emailField)
    }

    
    @IBAction func createAccount(sender: UIButton){
        func createAccountFailed(){
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidden = true
            self.feedbackLabel.hidden = false
            self.feedbackLabel.text = NSLocalizedString("Error Creating Account", comment: "")
        }
        
        sender.enabled = false
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidden = false
        
        let createAccountUrl = NSURL(string: apiBaseUrl + "/api/v1/users")
        
        let newAccountInfo: [String: AnyObject] = [
            "username": String(self.usernameTextField.text!),
            "password": String(self.passwordTextField.text!),
            "firstName": String(self.firstNameTextField.text!),
            "lastName": String(self.lastNameTextField.text!),
            "email": String(self.emailAddressTextField.text!)
        ]
        
        if NSJSONSerialization.isValidJSONObject(newAccountInfo){
            Alamofire.request(.POST, createAccountUrl!, parameters: newAccountInfo, encoding: .JSON)
                .responseJSON { response in
                    if response.1 != nil {
                        debugPrint(response)
                        if response.1?.statusCode == 201 {
                            print(response.2.value!)
                            let responseToken = Mapper<Token>().map(response.2.value)
                            self.storeToken(responseToken!)
                            self.userToken = responseToken
                            print(self.userToken.userID)
                            self.performSegueWithIdentifier("createAccountSegue", sender: self)
                        }
                        else {
                            createAccountFailed()
                            self.feedbackLabel.numberOfLines = 0
                            self.feedbackLabel.text = String(response.2.value!)
                        }
                    }
                    else {
                        createAccountFailed()
                        print("call failed")
                    }
                    
            }
        }
        else {
            print("Json serialization failed. Critical Error. We should not be here.")
        }
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "createAccountSegue" {
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
