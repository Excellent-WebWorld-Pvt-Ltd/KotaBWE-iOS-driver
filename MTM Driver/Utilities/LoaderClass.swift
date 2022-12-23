//
//  LoaderClass.swift
//  Pappea Driver
//
//  Created by EWW-iMac Old on 01/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class Loader{
    
    class func showHUD(with mainView: UIView = Helper.currentWindow) {
        let obj = DataClass.getInstance()
        obj?.viewBackFull = UIView(frame: mainView.bounds)
        obj?.viewBackFull?.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        let imgGlass = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))//239    115    40
        imgGlass.backgroundColor = UIColor.white //UIColor(red: 239/255, green: 115/255, blue: 40/255, alpha: 1.0)//
        self._loadAnimationNamed("Loading", view: imgGlass, dataClass: obj)
        imgGlass.center = obj?.viewBackFull?.center ?? CGPoint(x: 0, y: 0)
        imgGlass.layer.cornerRadius = 15.0
        imgGlass.layer.masksToBounds = true
        obj?.viewBackFull?.addSubview(imgGlass)
        mainView.addSubview(obj?.viewBackFull ?? UIView())
    }
    
    class func _loadAnimationNamed(_ named: String?, view mainView: UIView?, dataClass obj: DataClass?) {

        obj?.laAnimation = AnimationView(name: named ?? "")
        obj?.laAnimation?.frame = mainView?.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)//CGRect(x: (mainView?.center.x ?? 0.0) / 2 - 3, y: 20, width: 140, height: 140)
        obj?.laAnimation?.contentMode = .scaleAspectFill
        obj?.laAnimation?.center = mainView?.center ?? CGPoint(x: 0, y: 0)
        obj?.laAnimation?.play(fromProgress: 0,
                              toProgress: 1,
                              loopMode: LottieLoopMode.loop,
                              completion: { (finished) in
                                if finished {

                                } else {

                                }
        })
        obj?.laAnimation?.layer.masksToBounds = true
        mainView?.setNeedsLayout()
        if let laAnimation = obj?.laAnimation {
            mainView?.addSubview(laAnimation)
        }
    }
    
    class func hideHUD() {
        let obj = DataClass.getInstance()

        DispatchQueue.main.async(execute: {
            obj?.viewBackFull?.removeFromSuperview()
        })
    }
}

var instance: DataClass? = nil
class DataClass {

    var str = ""

    var laAnimation: AnimationView?
    var viewBackFull: UIView?


    class func getInstance() -> DataClass? {
        let lockQueue = DispatchQueue(label: "self")
        lockQueue.sync {
            if instance == nil {
                instance = DataClass()
            }
        }
        return instance
    }
}
