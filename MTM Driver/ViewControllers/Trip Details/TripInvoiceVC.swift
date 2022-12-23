//
//  TripInvoiceVC.swift
//  DSP Driver
//
//  Created by Harsh Dave on 25/10/21.
//  Copyright © 2021 baps. All rights reserved.
//

import UIKit

class TripInvoiceVC: BaseViewController {

   
   //MARK:- ===== Outlets ======
    @IBOutlet weak var vwDotedLine: UIView!
    @IBOutlet weak var vwOutline1: UIView!
    @IBOutlet weak var vwOutline2: UIView!
    @IBOutlet weak var lblPickupLocation: UILabel!
    @IBOutlet weak var lblDropOffLocation: UILabel!
    @IBOutlet weak var lblTotalPrice: ThemeLabel!
    @IBOutlet weak var lblTotalTime: ThemeLabel!
    @IBOutlet weak var lblVehicleName: ThemeLabel!
    @IBOutlet weak var lblVehiclePlateNo: ThemeLabel!
    @IBOutlet weak var lblServiceType: ThemeLabel!
    @IBOutlet weak var lblDateTime: ThemeLabel!
    @IBOutlet weak var lblTax: ThemeLabel!
    @IBOutlet weak var lblTotalPayable: ThemeLabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblTip: ThemeLabel!
    @IBOutlet weak var lblDiscount: ThemeLabel!
    @IBOutlet weak var lblBookingFee: ThemeLabel!
    @IBOutlet weak var lblSubTotal: ThemeLabel!
    
    
    //MARK:- ====== Variables =====
    var objBooking : BookingHistoryResponse!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation(.normal(title: "Invoice", leftItem: .back))
        dataSetup()
    }
    
    func dataSetup(){
        lblPickupLocation.text = objBooking.pickupLocation
        lblDropOffLocation.text = objBooking.dropoffLocation
        //tripLabel.text = "ID: \(info.id ?? "")"
        lblTotalTime.text = objBooking.tripDuration.secondsToTimeFormate()
        lblDistance.text = objBooking.distance.toDistanceString()
        lblTotalPrice.text = objBooking.driverAmount.toCurrencyString()
        
        let str =   "\(objBooking.acceptTime.timeStampToDate() ?? Date())"
        let arrState = str.components(separatedBy: " ")
        
        if let date = DateFormatHelper.standard.getDate(from:"\(arrState[0]) \(arrState[1])") {
           let strFormatter = DateFormatHelper.fullDateTime.getDateString(from: date)
           print(strFormatter)
           let arrDateTime = strFormatter.components(separatedBy: ", ")
           lblDateTime.text = arrDateTime[0] + " " + arrDateTime[1]

       } else {

       }
        lblDiscount.text = objBooking.discount != "" ? objBooking.discount.toCurrencyString() : "0.00".toCurrencyString()
        lblTax.text = objBooking.tax.toCurrencyString()
        lblServiceType.text = objBooking.vehicleTypeName
        lblVehiclePlateNo.text = objBooking.vehiclePlateNumber
        lblTip.text = objBooking.tips.toCurrencyString()
        lblDistance.text = objBooking.distance.toDistanceString()
        lblBookingFee.text = objBooking.bookingFee.toCurrencyString()
        lblSubTotal.text = objBooking.subTotal.toCurrencyString()
        lblTotalPayable.text = objBooking.driverAmount.toCurrencyString()
        lblVehicleName.text = objBooking.vehicleName + " " + objBooking.vehicleModel
    }
    
    
}
