//
//  PostCollectionViewCell.swift
//  LittleFarmer
//
//  Created by pingRuiLiao on 2015/12/11.
//  Copyright © 2015年 pingRuiLiao. All rights reserved.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var howManyLikes: UILabel!
    @IBOutlet weak var postContent: UITextView!
    @IBOutlet weak var lblUsername: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
