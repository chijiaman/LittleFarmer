//
//  Timeline.swift
//  LittleFarmer
//
//  Created by pingRuiLiao on 2015/12/11.
//  Copyright © 2015年 pingRuiLiao. All rights reserved.
//

import Foundation

class Timeline {
    let username: String
    let postImg: UIImage
    let postContent: String
    var cropRelated: Crop?
    init(host: String, img: UIImage, content: String?) {
        username = host
        postImg = img
        postContent = content ?? ""
    }
}