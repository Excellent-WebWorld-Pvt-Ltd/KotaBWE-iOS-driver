//
//  NoInternetView.swift
//  MTM Driver
//
//  Created by Gaurang on 16/11/22.
//  Copyright © 2022 baps. All rights reserved.
//

import UIKit
import Lottie

class NoInternetView: UIView {
    
    static var instance: NoInternetView?
    
    static func show() {
        let view = NoInternetView(frame: UIScreen.main.bounds)
        instance = view
        Helper.currentWindow.addSubview(view)
    }
    
    static func hide() {
        instance?.removeFromSuperview()
        instance = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let animationView = AnimationView(name: "connecting")
        animationView.frame.size = CGSize(width: 80, height: 80)
        self.addSubview(animationView)
        animationView.center = self.center
        animationView.play(toFrame: .infinity, loopMode: .loop)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
}
