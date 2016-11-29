//
//  CropViewController.swift
//  LittleFarmer
//
//  Created by pingRuiLiao on 2015/11/25.
//  Copyright © 2015年 pingRuiLiao. All rights reserved.
//

import UIKit
import Parse


protocol cropInformationDataSource {
    func passCropBack(crop: Crop, index: Int)
}


class CropViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var dataSource: cropInformationDataSource?
    var indexPassed: Int?
    var crop = Crop()
    var speciesData: [String] = []
    let statusData = ["已上市", "上市中", "未上市"]
    
    @IBOutlet weak var tfCropName: JiroTextField!
    @IBOutlet weak var btnMainImg: UIButton!
    @IBOutlet weak var statusPicker: UIPickerView!
    @IBOutlet weak var speciesPicker: UIPickerView!
    override func viewDidLoad() {
        retrieveParseData()
        super.viewDidLoad()
        statusPicker.delegate = self
        statusPicker.dataSource = self
        speciesPicker.delegate = self
        speciesPicker.dataSource = self
        statusPicker.tag = 2
        speciesPicker.tag = 1
        setupUI()
        if crop.isValid() {
            tfCropName.text = crop.name
            btnMainImg.setImage(crop.mainImg, forState: UIControlState.Normal)
            if let indexOfStatus = statusData.indexOf(crop.status!) {
                statusPicker.selectRow(indexOfStatus, inComponent: 0, animated: false)
            }
        }
    }
    
    func retrieveParseData() {
        speciesData = []
        let query = PFQuery(className:"Species")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                for obj in objects! {
                    if let str = obj["name"] as? String {
                        self.speciesData.append(str)
                    }
                }
                self.speciesPicker.reloadAllComponents()
                if self.crop.isValid() {
                    if let indexOfSpecies = self.speciesData.indexOf(self.crop.species!) {
                        self.speciesPicker.selectRow(indexOfSpecies, inComponent: 0, animated: false)
                    }
                    
                }
            }
            
        }
        
        
    }
    
    func setupUI() {
        
        // textField Crop Name
        tfCropName.font = UIFont(name: "ArialMT", size: 20.0)
        //tfCropName.backgroundColor = .whiteColor()
        tfCropName.placeholderColor = .darkGrayColor()
        tfCropName.placeholder = "Crop Name"
        tfCropName.borderColor = UIColor.whiteColor()

        // picker
        statusPicker.backgroundColor = UIColor.whiteColor()
        speciesPicker.backgroundColor = UIColor.whiteColor()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
            return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return speciesData.count
        } else {
            return statusData.count
        }
    }
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return speciesData[row]
        } else {
            return statusData[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if pickerView.tag == 1 {
            crop.species = speciesData[row]
        } else {
            crop.status = statusData[row]
        }
    }
    
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView.tag == 1 {
            let species = speciesData[row]
            let titleSpecies = NSAttributedString(string: species, attributes: [NSFontAttributeName: UIFont(name: "Georgia", size: 26.0)!, NSForegroundColorAttributeName: UIColor.blueColor()])
            return titleSpecies
        } else {
            let status = statusData[row]
            let titleStatus = NSAttributedString(string: status, attributes: [NSFontAttributeName: UIFont(name: "Georgia", size: 26.0)!, NSForegroundColorAttributeName: UIColor.blueColor()])
            return titleStatus
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.btnMainImg.setImage(image, forState: UIControlState.Normal)
        let imgData = UIImageJPEGRepresentation(image, 0.5)
        self.crop.mainImg = UIImage(data: imgData!)!
    }

    @IBAction func btnMainImgDidTap(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            print("Button capture")
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }

    }
    
    @IBAction func Done(sender: AnyObject) {
        print("name: \(crop.name)\n status: \(crop.status)\n species: \(crop.species)\n")
        crop.name = tfCropName.text
        if crop.isValid() {
            
            dataSource?.passCropBack(crop, index: indexPassed!)
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
    }
    @IBAction func Cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addToTimeline(sender: AnyObject) {
        
    }
}
