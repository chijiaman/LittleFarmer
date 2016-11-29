//
//  SignUpViewController.swift
//  LittleFarmer
//
//  Created by pingRuiLiao on 2015/11/27.
//  Copyright © 2015年 pingRuiLiao. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {

    @IBOutlet weak var tfUserName: KaedeTextField!
    
    @IBOutlet weak var tfPassword: KaedeTextField!
    
    @IBOutlet weak var tfEmail: KaedeTextField!
    
    @IBOutlet weak var checkForNotRobot: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkForNotRobot.on = false
        // kaede textField setup
        tfUserName.placeholder = "UserName"
        tfUserName.placeholderColor = .darkGrayColor()
        tfUserName.foregroundColor = .lightGrayColor()
        tfUserName.font = UIFont(name: "ArialMT", size: 30.0)
        
        tfPassword.placeholder = "Password"
        tfPassword.placeholderColor = .darkGrayColor()
        tfPassword.foregroundColor = .lightGrayColor()
        tfPassword.secureTextEntry = true
        tfPassword.font = UIFont(name: "ArialMT", size: 30.0)

        
        tfEmail.placeholder = "Email"
        tfEmail.placeholderColor = .darkGrayColor()
        tfEmail.foregroundColor = .lightGrayColor()
        tfEmail.font = UIFont(name: "ArialMT", size: 30.0)

    }

    func signup() {
        let user = PFUser()
        
        user.username = tfUserName.text
        user.password = tfPassword.text
        user.email = tfEmail.text
        // other fields can be set just like with PFObject
        //user["phone"] = "415-392-0202"
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let _ = error {
                print("error")
                // Show the errorString somewhere and let the user try again.
            } else {
                print("success")
                
                // Hooray! Let them use the app now.
            }
        }
    }
    @IBAction func Done(sender: AnyObject) {
        if checkForNotRobot.on {
            if tfUserName.text != "" && tfPassword.text != "" && tfEmail.text != "" {
                signup()
                dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    @IBAction func Cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
