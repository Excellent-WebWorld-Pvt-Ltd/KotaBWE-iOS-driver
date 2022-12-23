//
//  UtilityClass.swift
//  Pappea Driver
//
//  Created by Apple on 19/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import Kingfisher
import CoreLocation

class UtilityClass: NSObject {

    typealias alertCompletion = (() -> Void)?
    
    class func showAlert(message: String, isCancelShow: Bool = false, completion: alertCompletion = nil) {
        let alert = UIAlertController(title: Helper.appName, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            if completion != nil {
                completion!()
            }
        }
//        ok.setValue(UIColor.blue, forKey: "titleTextColor")
        alert.addAction(ok)
        if isCancelShow {
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alert.addAction(cancel)
        }
        AppDelegate.shared.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }

    class func image(_ originalImage: UIImage?, scaledTo size: CGSize) -> UIImage? {

        
        //avoid redundant drawing
        if originalImage?.size.equalTo(size) ?? false {
            return originalImage
        }

        //create drawing context
        UIGraphicsBeginImageContextWithOptions(size, _ : false, _ : 0.0)

        //draw
        originalImage?.draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))

        //capture resultant image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        //return image
        return image
    }

    typealias CompletionHandler = (_ success:Bool) -> Void

    class func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    class func imageGet(url : String , img:UIImageView , _ IndClr : UIColor = UIColor.black , _ PlaceHolderImage : UIImage = UIImage()){
         img.kf.indicatorType = .activity
         let activity =  img.kf.indicator?.view as? UIActivityIndicatorView ?? UIActivityIndicatorView()
        activity.color = UIColor.black
         
         img.kf.indicator?.startAnimatingView()
         let url = URL(string:(url))
         img.kf.setImage(with: url, placeholder: PlaceHolderImage, options: [], progressBlock: nil) { (response) in
            
             img.kf.indicator?.stopAnimatingView()
         }
     }

    
    class func calculateDistanceInMiles(OldCoordinate : CLLocationCoordinate2D, NewCoordinate : CLLocationCoordinate2D) -> String{

        let coordinate0 = CLLocation(latitude:OldCoordinate.latitude, longitude:OldCoordinate.longitude)
        let coordinate1 = CLLocation(latitude: NewCoordinate.latitude, longitude:NewCoordinate.longitude)
            let distanceInMeters = coordinate0.distance(from: coordinate1)
            print(distanceInMeters/1000)
            if(distanceInMeters <= 1609)
            {
                let s =   String(format: "%.2f", distanceInMeters)
                    //+ " Miles"
                print("miles",s)
                return s
            }
            else
            {
                let s =   String(format: "%.2f", distanceInMeters)
                print("miles",s)
                return s
//                self.fantasyDistanceLabel.text = s + " Miles"
            }
           
        }
    
    class func getCurrentDateTime() -> String{
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
     class func timeString(time: TimeInterval) -> String {
            let hour = Int(time) / 3600
            let minute = Int(time) / 60 % 60
            let second = Int(time) % 60

            // return formated string
            return String(format: "%02i:%02i:%02i", hour, minute, second)
    }
    
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    
    func getStringFrom(seconds: Int) -> String {
        return seconds < 10 ? "0\(seconds)" : "\(seconds)"
    }
    
    
    class func dialNumber(number : String) {

     if let url = URL(string: "tel://\(number)"),
       UIApplication.shared.canOpenURL(url) {
          if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler:nil)
           } else {
               UIApplication.shared.openURL(url)
           }
       } else {
                // add error message here
       }
    }
    
    static var isSimulator: Bool {
        #if targetEnvironment(simulator)
            return true
        #else
            return false
        #endif
    }
    
    static func triggerHapticFeedback(_ notificationType: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(notificationType)
    }
    
    
}
