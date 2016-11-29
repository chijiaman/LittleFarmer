//
//  TimelineViewController.swift
//  LittleFarmer
//
//  Created by pingRuiLiao on 2015/11/30.
//  Copyright © 2015年 pingRuiLiao. All rights reserved.
//

import UIKit
import PKHUD
import Parse

class TimelineViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIPopoverPresentationControllerDelegate, TimelineDelegate {
    
    var recentTimeline: [Timeline] = []
    var user = PFUser.currentUser()!
    @IBOutlet weak var btnNewTimeline: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = UIColor.whiteColor()
        //retrieveTimelineInBackground()
        collectionView.userInteractionEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        let flowLayOut = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayOut.minimumInteritemSpacing = 6.0
        flowLayOut.minimumLineSpacing = 6.0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        retrieveTimelineInBackground()
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("postCollectionViewCell", forIndexPath: indexPath) as! PostCollectionViewCell
        cell.profileImg.image = UIImage(named: "user")
        cell.postImg.image = recentTimeline[indexPath.row].postImg
        cell.postContent.text = recentTimeline[indexPath.row].postContent
        cell.lblUsername.text = recentTimeline[indexPath.row].username
        //cell.btnLike.addTarget(self, action: "like", forControlEvents: UIControlEvents.TouchUpInside)
        cell.btnLike.setImage(UIImage(named: "hearts_filled"), forState: UIControlState.Selected)
        cell.btnLike.tag = indexPath.row
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return recentTimeline.count
        return recentTimeline.count
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    
    @IBAction func newTimeline(sender: AnyObject) {
        //pop over
        if let npvc = storyboard?.instantiateViewControllerWithIdentifier("newPostViewController") as? NewPostViewController {
            npvc.timelineDelegate = self
            let nav = UINavigationController(rootViewController: npvc)
            nav.modalPresentationStyle = UIModalPresentationStyle.Popover
            if let ppc = nav.popoverPresentationController {
                print("ppc")
                ppc.delegate = self
                //ppc.preferredContentSize = CGSize(width: 250, height: 400)
                ppc.permittedArrowDirections = UIPopoverArrowDirection.Any
                ppc.sourceView = self.btnNewTimeline
                
                self.presentViewController(nav, animated: true, completion: nil)
            }
        }
    }
    func retrieveTimelineInBackground() {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
        let queue = dispatch_get_global_queue(qos, 0)
        dispatch_async(queue) { () -> Void in
            self.retrieveTimeline()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.collectionView.reloadData()
                PKHUD.sharedHUD.hide(afterDelay: 1.0)
            })
        }
    }
    
    func retrieveTimeline() {
        recentTimeline = []
        let query = PFQuery(className: "Timeline")
        query.limit = 10
        query.orderByAscending("createAt")
        let pfobjarr: [PFObject]?
        do {
            pfobjarr = try query.findObjects()
        } catch {
            pfobjarr = nil
        }
        //pfobjarr.sor
        if let objs = pfobjarr {
            for obj in objs {
                let imgFile = obj["postImage"] as! PFFile
                let imgData: NSData?
                do {
                    imgData = try imgFile.getData()
                } catch {
                    imgData = nil
                    print("img not found")
                }
                if let imgd = imgData {
                    print("imgSuccess")
                    let content = obj["postContent"] as? String
                    let username = obj["username"] as! String
                    let timeline = Timeline(host: username, img: UIImage(data: imgd)!, content: content)
                    self.recentTimeline.append(timeline)
                }
            }
        }
        self.recentTimeline = self.recentTimeline.reverse()
    }
    
    func didPost(sure: Bool) {
        if sure {
            print("done")
            retrieveTimelineInBackground()
        }
    }
    


}
