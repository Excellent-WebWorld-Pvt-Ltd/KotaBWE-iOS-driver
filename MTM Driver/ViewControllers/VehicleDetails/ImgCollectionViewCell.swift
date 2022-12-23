//
//  ImgCollectionViewCell.swift
//  DSP Driver
//
//  Created by Admin on 25/11/21.
//  Copyright © 2021 baps. All rights reserved.
//

import UIKit

class ImgCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imgCar: UIImageView!
    @IBOutlet weak var viewBG: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewBG.layer.borderWidth = 2
        self.viewBG.layer.borderColor = UIColor.black.cgColor
        self.viewBG.layer.cornerRadius = 10
        self.viewBG.clipsToBounds = true
    }
    
    
}
