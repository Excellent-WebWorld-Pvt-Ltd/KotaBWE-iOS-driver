//
//  EndMeterPaymentInfo.swift
//  DSP Driver
//
//  Created by Admin on 15/12/21.
//  Copyright © 2021 baps. All rights reserved.
//

import UIKit

class EndMeterPaymentInfo: UIViewController {

    //MARK:- ====== Outlets ======
    @IBOutlet weak var lblDateTime: ThemeLabel!
    @IBOutlet weak var lblTripTime: ThemeLabel!
    @IBOutlet weak var lbltotalPayable: ThemeLabel!
    @IBOutlet weak var lblWaitingTime: ThemeLabel!
    @IBOutlet weak var lblDistance: ThemeLabel!
    
    
    var strTripTime = String()
    var strTripFare = String()
    var strWaitingTime = String()
    var strDistance = String()
    var endMeterClousure : (()->())?
    
    
    
    //MARK:- ========
    override func viewDidLoad() {
        super.viewDidLoad()
        DataSetup()

    }
    
    //MARK:- ===== Datasetup =====
    func DataSetup(){
        let str =  "\(Singleton.shared.meterInfo?.startedTime.timeStampToDate() ?? Date())"
        let arrState = str.components(separatedBy: " ")
        if let date = DateFormatHelper.standard.getDate(from:"\(arrState[0]) \(arrState[1])") {
           let strFormatter = DateFormatHelper.fullDateTime.getDateString(from: date)
           print(strFormatter)
            lblDateTime.text = strFormatter
            lblTripTime.text = strTripTime
            lblDistance.text = strDistance
            lblWaitingTime.text = strWaitingTime
            lbltotalPayable.text = strTripFare
       }
    }
    

    //MARK:- ===== Btn Action End Trip ======
    @IBAction func btnActionEndTrip(_ sender: UIButton) {
        self.dismiss(animated: true) {
            if let navigateToHome = self.endMeterClousure{
                navigateToHome()
            }
        }
    }
}
