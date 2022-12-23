//
//  ThemeContainerView.swift
//  DPS
//
//  Created by Gaurang on 27/09/21.
//  Copyright © 2021 Mayur iMac. All rights reserved.
//

import UIKit

class ThemeContainerView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setViews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setViews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
    }

    func setViews() {
        backgroundColor = .themeBackground
        clipsToBounds = true
    }

}

class ThemeRoundCornerView  : UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        self.roundCorners([.topLeft,.topRight], radius: 10.0)
    }
}


