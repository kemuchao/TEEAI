//
//  TEEHomeCollectionViewCell.swift
//  TEEAI
//
//  Created by TEE on 2018/12/18.
//  Copyright © 2018 柯木超. All rights reserved.
//

import UIKit

class TEEHomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    var device:TEEDevice!{
        didSet{
            iconImageView.setImageWithImage(fileUrl: validString(device.icon), placeImage: UIImage(named: "home_icon_select"))
            name.text = device.name
        }
    }
}
