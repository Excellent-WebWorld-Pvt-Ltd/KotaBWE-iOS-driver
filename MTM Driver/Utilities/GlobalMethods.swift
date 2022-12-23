//
//  UtilityClass.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 30/04/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

struct GlobalMethods {
   
    typealias CompletionHandler = (() -> ())?
   
    static let window = (UIApplication.shared.delegate as! AppDelegate).window
    
    private init(){}
    
   
    //-------------------------------------
    // MARK:- Custom Alert
    //-------------------------------------
    
    static func showAlert(_ title: String,
                            message: String,
                            isCancelAvailable: Bool,
                            okHandler: CompletionHandler = nil,
                            cancelHandler: CompletionHandler = nil) -> Void
    {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Okay".localized, style: .default, handler: { (action) in
            if okHandler != nil { okHandler!()}
        }))
        if isCancelAvailable{
            alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: { (action) in
                if cancelHandler != nil { cancelHandler!() }
            }))
        }
        window?.rootViewController?.present(alert, animated: true, completion: nil)
        
    }
    
}
