//
//  MyTabBarController.swift
//  LittleFarmer
//
//  Created by pingRuiLiao on 2015/11/29.
//  Copyright © 2015年 pingRuiLiao. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 0
        let myCropsViewController = tabBar.items![0]
        myCropsViewController.title = "My Crops"
        //let imgDataMyCrops = UIImageJPEGRepresentation(UIImage(named: "tabBar_myCrops")!, 0.8)
        myCropsViewController.image = UIImage(named: "tabBar_myCrops")
        // 1
        let timelineViewController = tabBar.items![1]
        timelineViewController.title = "Timeline"
        //let imgDataTimeline = UIImageJPEGRepresentation(UIImage(named: "tabBar_timeline")!, 0.6)
        timelineViewController.image = UIImage(named: "tabBar_timeline")
        
        // 2
        let farmerViewController = tabBar.items![2]
        farmerViewController.title = "Farmer"
        farmerViewController.image = UIImage(named: "tabBar_farmer")
        
        // Do any additional setup after loading the view.
    }

}
