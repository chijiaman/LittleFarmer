//
//  LoginViewController.swift
//  LittleFarmer
//
//  Created by pingRuiLiao on 2015/11/23.
//  Copyright © 2015年 pingRuiLiao. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var imgTitle: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tfPassword.secureTextEntry = true
        let background = UIImageView(frame: CGRect(x: 0, y: 0, width: 414, height: 1472))
        background.image = UIImage(named: "login_Background")
        self.view.addSubview(background)
        
        self.btnSignUp.userInteractionEnabled = false
        self.btnLogin.userInteractionEnabled = false
        // opening
        self.btnLogin.alpha = 0.01
        self.tfPassword.alpha = 0.01
        self.tfUsername.alpha = 0.01
        UIView.animateWithDuration(2.0, animations: { () -> Void in
            background.frame.origin.y = -736

            }) { (didCompleted) -> Void in
                if didCompleted {
                    //print("completed")
                    UIView.animateWithDuration(1.5, animations: { () -> Void in
                        self.imgTitle.alpha = 0.0
                        self.btnLogin.alpha = 1.0
                        self.tfUsername.alpha = 1.0
                        self.tfPassword.alpha = 1.0
                        self.btnSignUp.alpha = 1.0
                    })
                    self.btnLogin.userInteractionEnabled = true
                    self.btnSignUp.userInteractionEnabled = true
                }
        }
    }
    
    @IBAction func btnLoginDidTap(sender: AnyObject) {
        
        PFUser.logInWithUsernameInBackground(tfUsername.text!, password: tfPassword.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                let tbc = self.storyboard?.instantiateViewControllerWithIdentifier("tabBarController") as! UITabBarController
                tbc.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
                tbc.modalPresentationStyle = UIModalPresentationStyle.FullScreen
                self.presentViewController(tbc, animated: true, completion: nil)
                
            } else {
                print("logIn Failed")
            }
        }
    }

    @IBAction func SignUp(sender: AnyObject) {
        let suvc = storyboard?.instantiateViewControllerWithIdentifier("signUpViewController") as! SignUpViewController
        self.presentViewController(suvc, animated: true, completion: nil)
    }
}
