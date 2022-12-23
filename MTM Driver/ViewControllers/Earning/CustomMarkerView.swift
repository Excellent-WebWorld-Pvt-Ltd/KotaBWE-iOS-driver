//
//  CustomMarkerView.swift
//  DSP Driver
//
//  Created by Admin on 01/12/21.
//  Copyright © 2021 baps. All rights reserved.
//

import UIKit

class CustomMarkerView: UIView {

    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewBG.layer.cornerRadius = self.viewBG.frame.height / 2
        self.viewBG.clipsToBounds = true
    }
}
