//
//  MessageBarController.swift
//  HealthyBlackMen
//
//  Created by HealthyBlackMen on 10/05/17.
//  Copyright © 2017 HealthyBlackMen. All rights reserved.
//
import UIKit
import QuartzCore
import Alamofire
import SwiftMessages

class MessageBarController: NSObject {
    
    
    func MessageShow(title : NSString , alertType : MessageView.Layout , alertTheme : Theme , TopBottom : Bool) -> Void {
        //Hide All popup when present any one popup
        // SwiftMessages.hideAll()
        
        //Top Bottom
        //1 = Top , 2 = Bottom
        
        let alert = MessageView.viewFromNib(layout: alertType)
        alert.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        alert.titleLabel?.numberOfLines = 0
        alert.bodyLabel?.font =  UIFont.systemFont(ofSize: 13)
        alert.bodyLabel?.numberOfLines = 2
        
        //Alert Type
        alert.configureTheme(alertTheme)
        alert.configureDropShadow()
        alert.button?.isHidden = true
        
        //Set title value
        //       alertTheme.hashValue
        alert.configureContent(title: "", body: title as String)
        
        var successConfig = SwiftMessages.Config()
        successConfig.duration = .seconds(seconds: 5)
        //Type for present popup is bottom or top
        (TopBottom == true) ? (successConfig.presentationStyle = .top):(successConfig.presentationStyle = .bottom)
        //successConfig.duration = .seconds(seconds: 0.25)
        
        //Configaration with Start with status bar
        successConfig.presentationContext =  .window(windowLevel: UIWindow.Level(rawValue: UIWindow.Level.alert.rawValue))
        
        
        SwiftMessages.show(config: successConfig, view: alert)
        
    }
    
}



struct AlertMessage {
    static var messageBar = MessageBarController()
    
    static  func showMessageForError(_ strTitle: String) {
        guard strTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != "" else { return }
         messageBar.MessageShow(title: strTitle as NSString, alertType: MessageView.Layout.cardView, alertTheme: .error, TopBottom: true)
    }
    static func showMessageForSuccess(_ strTitle: String) {
        guard strTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != "" else { return }

        messageBar.MessageShow(title: strTitle as NSString, alertType: MessageView.Layout.cardView, alertTheme: .success, TopBottom: true)
    }
    
    static func showMessageForInformation(_ strTitle: String) {
        guard strTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != "" else { return }
        
        messageBar.MessageShow(title: strTitle as NSString, alertType: MessageView.Layout.cardView, alertTheme: .info, TopBottom: true)
    }
}
