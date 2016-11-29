//
//  NewPostViewController.swift
//  LittleFarmer
//
//  Created by pingRuiLiao on 2015/12/11.
//  Copyright © 2015年 pingRuiLiao. All rights reserved.
//

import UIKit
import Parse

protocol TimelineDelegate {
    func didPost(sure: Bool)
}

class NewPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var cropOption: [String] = []
    var cropStr: String?
    var timelineDelegate: TimelineDelegate?
    let user = PFUser.currentUser()!
    
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var cropPicker: UIPickerView!
    @IBOutlet weak var postContent: UITextView!
    
    override func viewDidLoad() {
        retrieveOptions()
        super.viewDidLoad()
        cropPicker.delegate = self
        cropPicker.dataSource = self
        
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cropOption.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cropOption[row]
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if cropOption[row] != "None" {
            cropStr = cropOption[row]
        } else {
            cropStr = nil
        }
        
        //findCorrespondingCrop(cropOption[row])
    }

    
    func retrieveOptions() {
        let query = PFQuery(className: "Crop")
        query.whereKey("belongTo", equalTo: user.username!)
        query.findObjectsInBackgroundWithBlock { (objects, err) -> Void in
            if err == nil && objects != nil {
                for object in objects! {
                    if let obj = object["name"] as? String {
                        self.cropOption.append(obj)
                    }
                }
            }
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        let compressImgData = UIImageJPEGRepresentation(image, 0.5)
        let img = UIImage(data: compressImgData!)
        postImg.image = img
    }
    
    @IBAction func inputPhoto(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func done(sender: AnyObject) {
        
        if rulesOfTimeLine() {
            let post = PFObject(className: "Timeline")
            if let str = cropStr {
                post["postContent"] = postContent.text + "#" + str
            } else {
                post["postContent"] = postContent.text
            }
            post["username"] = user.username!
            let imgData = UIImageJPEGRepresentation(postImg.image!, 0.5)
            let imageFile = PFFile(name: "image.png", data: imgData!)
            post["postImage"] = imageFile
            post.saveInBackgroundWithBlock({ (success, err) -> Void in
                if success && err == nil {
                    print("save timeline success")
                } else {
                    print("ERROR: saving timeline")
                }
            })
            timelineDelegate?.didPost(true)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        
    }
    
    

    func rulesOfTimeLine() -> Bool {
      
        let rule1 = postImg.image != nil
        let rule2 = postContent.text != nil
        let passed = rule1 && rule2
        return passed
    }
}
