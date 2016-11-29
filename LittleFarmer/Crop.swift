//
//  Crop.swift
//  LittleFarmer
//
//  Created by pingRuiLiao on 2015/11/27.
//  Copyright © 2015年 pingRuiLiao. All rights reserved.
//

import Foundation
import UIKit

class Crop {
    var name: String?
    //var price: Int?
    var species: String?
    var status: String?
    var belongTo: String?
    var mainImg: UIImage
    
    init() {
        mainImg = UIImage(named: "fruit")!
    }
    
    func isValid() -> Bool {
        if name == nil || species == nil || status == nil {
           return false
        }
        return true
    }
}