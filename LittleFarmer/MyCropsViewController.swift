//
//  MyCropsViewController.swift
//  LittleFarmer
//
//  Created by pingRuiLiao on 2015/11/25.
//  Copyright © 2015年 pingRuiLiao. All rights reserved.
//

import UIKit
import Parse
import PKHUD

class MyCropsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, cropInformationDataSource {
    
    var user = PFUser.currentUser()
    var crops: [Crop] = []
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
        let queue = dispatch_get_global_queue(qos, 0)
        dispatch_async(queue) { () -> Void in
            self.retrieveCrops()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.collectionView.reloadData()
                PKHUD.sharedHUD.hide(afterDelay: 1.0)
            })
        }
        //retrieveCrops()
        collectionView.userInteractionEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let flowLayOut = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayOut.minimumInteritemSpacing = 6.0
        flowLayOut.minimumLineSpacing = 6.0
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
        
    }
    
    func passCropBack(crop: Crop, index: Int) {
        if index >= crops.count {
            crops.append(crop)
            // Parse - background
            let pfobj = PFObject(className: "Crop")
            pfobj["name"] = crop.name
            pfobj["belongTo"] = PFUser.currentUser()?.username
            pfobj["species"] = crop.species
            pfobj["status"] = crop.status
            
            // Saving main Img on Parse
            let imageData = UIImageJPEGRepresentation(crop.mainImg, 0.5)
            //let imageData = UIImagePNGRepresentation(imageOneData)
            let imageFile = PFFile(name:"image.png", data:imageData!)
            pfobj["mainImg"] = imageFile
            pfobj.saveInBackgroundWithBlock { (success, err) -> Void in
                if success && err == nil {
                    print("save crop success")
                } else {
                    print("error")
                }
            }
            
        } else {
            let query = PFQuery(className: "Crop")
            query.whereKey("name", equalTo: crops[index].name!)
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if let obj = objects?.first {
                    obj["name"] = crop.name
                    obj["species"] = crop.species
                    obj["status"] = crop.status
                    let imgData = UIImageJPEGRepresentation(crop.mainImg, 0.5)
                    let imgFile = PFFile(name: "image.png", data: imgData!)
                    obj["mainImg"] = imgFile
                    obj.saveInBackground()
                    
                }
            })
            crops[index] = crop
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cropInfoCollectionViewCell", forIndexPath: indexPath) as! CropInfoCollectionViewCell
        cell.alpha = 0.8
        cell.lblCropName.text = crops[indexPath.row].name
        cell.lblCropStatus.text = crops[indexPath.row].status
        cell.lblCropSpecies.text = crops[indexPath.row].species
        // img
        cell.cropMainPhoto.image = crops[indexPath.row].mainImg
        cell.btn.addTarget(self, action: "editCrop:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.btn.tag = indexPath.row
        return cell
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return ary.count
        return crops.count
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func editCrop(tapped: CropInfoCollectionViewCell) {
        print("edit")
        let cvc = storyboard?.instantiateViewControllerWithIdentifier("cropViewController") as! CropViewController
        cvc.crop = crops[tapped.tag]
        cvc.indexPassed = tapped.tag
        cvc.dataSource = self
        cvc.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        cvc.modalPresentationStyle = UIModalPresentationStyle.FullScreen
        presentViewController(cvc, animated: true, completion: nil)
    }
    
    func retrieveCrops() {
        
        let username = user?.username
        print("retrieve crops \(username)")
        let query = PFQuery(className:"Crop")
        query.whereKey("belongTo", equalTo: username!)
        
        let pfObjArr: [PFObject]?
        do {
            pfObjArr = try query.findObjects()
        } catch {
            pfObjArr = nil
        }
        if let objects = pfObjArr {
            crops = []
            
            for object in objects {
                print(crops.count)
                let newCrop = Crop()
                newCrop.name = object["name"] as? String
                newCrop.species = object["species"] as? String
                newCrop.status = object["status"] as? String
                let pff = object["mainImg"] as! PFFile
                let imgData: NSData?
                do {
                    imgData = try pff.getData()
                } catch {
                    imgData = nil
                }
                if let imgd = imgData {
                    print("img Success")
                    newCrop.mainImg = UIImage(data: imgd)!
                }
                self.crops.append(newCrop)
            }
        }
        

    }
    
    
    
    @IBAction func AddCrop(sender: AnyObject) {
        let cvc = storyboard?.instantiateViewControllerWithIdentifier("cropViewController") as! CropViewController
        cvc.crop = Crop()
        cvc.indexPassed = crops.count
        cvc.dataSource = self
        cvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        self.presentViewController(cvc, animated: true, completion: nil)
        
    }
    
    
    
    
}
