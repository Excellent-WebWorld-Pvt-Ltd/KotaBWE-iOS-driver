//
//  MTSLider+ext.swift
//  MTM Driver
//
//  Created by Gaurang on 21/11/22.
//  Copyright © 2022 baps. All rights reserved.
//

import UIKit

extension MTSlideToOpenView {
    
    func applyThemeStyle() {
        self.thumbnailViewStartingDistance = 16
        self.textLabel.textAlignment = .center
        self.sliderCornerRadius = 0
        self.thumnailImageView.backgroundColor = .clear
        self.thumnailImageView.image = UIImage(named: "ic_Slide")
        self.draggedView.backgroundColor = .clear
        self.textColor = .white
        self.textFont = UIFont.bold(ofSize: 12.0)
        self.backgroundColor = .themeColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
