//
//  CropInfoCollectionViewCell.swift
//  LittleFarmer
//
//  Created by pingRuiLiao on 2015/11/25.
//  Copyright © 2015年 pingRuiLiao. All rights reserved.
//

import UIKit

class CropInfoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cropMainPhoto: UIImageView!
    @IBOutlet weak var lblCropName: UILabel!
    @IBOutlet weak var lblCropStatus: UILabel!
    @IBOutlet weak var lblCropSpecies: UILabel!
    @IBOutlet weak var btn: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
