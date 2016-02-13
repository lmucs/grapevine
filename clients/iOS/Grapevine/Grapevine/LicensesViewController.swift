//
//  LicensesViewController.swift
//  Grapevine
//
//  Created by Matthew Flickner on 2/11/16.
//  Copyright © 2016 Grapevine. All rights reserved.
//

import UIKit

class LicensesViewController: UIViewController {
    
    @IBOutlet weak var licenseField: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let alamoFireLicense = NSLocalizedString("AlamofireLicense", comment: "")
        let swiftyJsonLicense = NSLocalizedString("SwiftyJsonLicense", comment: "")
        let objectMapperLicense = NSLocalizedString("ObjectMapperLicense", comment: "")
        
        licenseField.text = alamoFireLicense + "\n \n" + swiftyJsonLicense + "\n \n" + objectMapperLicense

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
