//
//  BackgroundImageView.swift
//  Pappea Driver
//
//  Created by Apple on 11/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

class BackgroundImageView: UIView {

    
    lazy var imgView = UIImageView()
  
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
         let statusBarSize = UIApplication.shared.statusBarFrame.size.height
        
        imgView.frame = CGRect(x: 0, y: -statusBarSize, width: ScreenSize.SCREEN_WIDTH, height: ScreenSize.SCREEN_HEIGHT)
        imgView.image = UIImage(named: "Bg")
        imgView.contentMode = .scaleAspectFit
        
        if !imgView.subviews.contains(imgView) {
            self.addSubview(imgView)
        }
        
        self.sendSubviewToBack(imgView)
        
    }
    

}
