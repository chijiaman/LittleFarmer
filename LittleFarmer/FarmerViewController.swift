//
//  FarmerViewController.swift
//  LittleFarmer
//
//  Created by pingRuiLiao on 2015/11/27.
//  Copyright © 2015年 pingRuiLiao. All rights reserved.
//

import UIKit
import Parse

class FarmerViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var user = PFUser.currentUser()!
    var editable = false
    @IBOutlet weak var lblFarmer: UILabel!
    @IBOutlet weak var lblRegion: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var profileImg: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // retrieve user profile image data
        if let pff = user["profileImage"] as? PFFile {
            let imgData: NSData?
            do {
                imgData = try pff.getData()
            } catch {
                imgData = nil
            }
            if let imgd = imgData {
                print("profile Image Success")
                self.profileImg.image = UIImage(data: imgd)
            } else {
                self.profileImg.image = UIImage(named: "user")
            }
        }
        lblFarmer.text = user.username
        lblRegion.text = "台灣"
        lblEmail.text = user.email
        let tapGesture = UITapGestureRecognizer(target: self, action: "changeProfilePhoto")
        profileImg.addGestureRecognizer(tapGesture)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        triggerFirePlace()
    }
    
    func triggerFirePlace() {
        let filePath = NSBundle.mainBundle().pathForResource("fireplace", ofType: "gif")
        let fireplace = NSData(contentsOfFile: filePath!)
        let fireRect = CGRect(x: 120, y: 500, width: 168, height: 143)
        //let imageView = UIImageView(frame: fireRect)
        let webView = UIWebView(frame: fireRect)
        webView.loadData(fireplace!, MIMEType: "image/gif", textEncodingName: String(), baseURL: NSURL())
        webView.userInteractionEnabled = false
        webView.alpha = 0.55
        self.view.addSubview(webView)
        // PROBLEM :
        
        
    }
    
    func changeProfilePhoto() {
        print("did Tap")
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func passImgOnParse() {
        
        let imgData = UIImageJPEGRepresentation(profileImg.image!, 0.5)
        let pffile = PFFile(name: "image.png", data: imgData!)
        user["profileImage"] = pffile
        user.saveInBackgroundWithBlock { (success, err) -> Void in
            if success && err == nil {
                print("save userprofileimg success")
            } else {
                print("ERROR: saving userprofileimg")
            }
        }
        
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        profileImg.image = image
        passImgOnParse()
    }
    
    
    @IBAction func logOut(sender: AnyObject) {
        PFUser.logOut()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
