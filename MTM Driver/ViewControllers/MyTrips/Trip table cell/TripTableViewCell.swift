//
//  TripTableViewCell.swift
//  DPS
//
//  Created by Gaurang on 23/09/21.
//  Copyright © 2021 Mayur iMac. All rights reserved.
//

import UIKit
import GoogleMaps
import UIView_Shimmer

class TripTableViewCell: UITableViewCell , ShimmeringViewProtocol{

    @IBOutlet weak var viewSeprateLine2: UIView!
    @IBOutlet weak var viewSeprateLine1: UIView!
    @IBOutlet weak var lbltitleDropOff: ThemeLabel!
    @IBOutlet weak var lblTitlePickup: ThemeLabel!
    @IBOutlet weak var lblTitleEarning: ThemeLabel!
    @IBOutlet weak var lblTitleDistance: ThemeLabel!
    @IBOutlet weak var lblTitleTotalTime: UILabel!
    @IBOutlet weak var viewTripId: UIView!
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var pickupLabel: ThemeLabel!
    @IBOutlet weak var dropLabel: ThemeLabel!
    @IBOutlet weak var tripLabel: ThemeLabel!
    @IBOutlet weak var timeLabel: ThemeUnderlinedLabel!
    @IBOutlet weak var totalTimeLabel: ThemeLabel!
    @IBOutlet weak var distanceLabel: ThemeLabel!
    @IBOutlet weak var totalPriceLabel: ThemeLabel!
    @IBOutlet weak var lblStatus: ThemeLabel!
    @IBOutlet weak var imgPickDrop: UIImageView!
    @IBOutlet weak var bottomStack: UIView!
    
    var shimmeringAnimatedItems: [UIView] {
            [
                mapContainerView,
                pickupLabel,
                dropLabel,
                tripLabel,
                totalTimeLabel,
                distanceLabel,
                totalPriceLabel,
                lblStatus,
                timeLabel,
                lblTitlePickup,
                lbltitleDropOff,
                lblTitleTotalTime,
                lblTitleDistance,
                lblTitleEarning,
                imgPickDrop,
                viewTripId,
                viewSeprateLine1,
                viewSeprateLine2
            ]
        }
    
    //MARK:- ==== Variables ======
    var isFRomUpcoming = false
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }

    func configuration(hasMap: Bool, info: BookingHistoryResponse) {
        
        mapContainerView.isHidden = !hasMap
        bottomStack.isHidden = info.status == .cancelled
        lblStatus.text = info.status.title
        lblStatus.textColor = info.status.color
        pickupLabel.text = info.pickupLocation
        dropLabel.text = info.dropoffLocation
        tripLabel.text = "ID: \(info.id ?? "")"
        totalTimeLabel.text = info.tripDuration.secondsToTimeFormate()
        distanceLabel.text = info.distance.toDistanceString()
        totalPriceLabel.text = info.driverAmount.toCurrencyString()
            
            //info.grandTotal.toCurrencyString()
        
       
        
        let str =   "\(info.acceptTime.timeStampToDate() ?? Date())"
        let arrState = str.components(separatedBy: " ")
        
        if isFRomUpcoming == true {
            if let dateStr = info.pickupDateTime {
                print(dateStr.timeStampToDate()?.getDayDifferentTextWithTime() ?? "")
                timeLabel.text = dateStr.timeStampToDate()?.getDayDifferentTextWithTime()
                timeLabel.isHidden = false
            } else {
                timeLabel.isHidden = true
            }
        }
        else {
            if let date = DateFormatHelper.standard.getDate(from:"\(arrState[0]) \(arrState[1])") {
                timeLabel.text = date.getDayDifferentTextWithTime()
           } else {
               timeLabel.text = "---"
           }
        }
    }
}
