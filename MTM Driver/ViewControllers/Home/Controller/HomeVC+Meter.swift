//
//  HomeView+Meter.swift
//  MTM Driver
//
//  Created by Gaurang on 19/10/22.
//  Copyright © 2022 baps. All rights reserved.
//

import Foundation
import SwiftyJSON

extension HomeViewController {
    
    func checkMeterStatus() {
        guard let meterInfo = Singleton.shared.meterInfo else {
            return
        }
        MeterManager.shared.setValues(meterInfo)
        DispatchQueue.main.async {
            let viewCtr = AppViewControllers.shared.meter
            self.push(viewCtr)
           // MeterManager.shared.startMeter()
        }
    }
    
    func presentMeter() {
        if Singleton.shared.meterInfo != nil {
            let viewCtr = AppViewControllers.shared.meter
            self.push(viewCtr)
        }
        else {
            if Singleton.shared.isDriverOnline == false{
                UtilityClass.showAlert(message: "Please start duty first then after you can start your meter trip", isCancelShow: false) {
                }
            }
            else {
                let view = AddMoneyView(isFromMeter: true) { [weak self] mobileNumber in
                    print("PhneNumber: ", mobileNumber)
                    self?.webServicecallStartMeter(MobileNumber: mobileNumber)
                    
                }
                let viewCtr = AppViewControllers.shared.bottomSheet(title: "Meter", view: view, "Please provide your passenger’s phone number to access the meter")
                
                self.present(viewCtr, animated: true)
            }
            
        }
    }
    
    //MARK:- ======= Webservice Call Start Meter ======
    func webServicecallStartMeter(MobileNumber : String){
        Loader.showHUD(with: self.view)
        guard let location = Singleton.shared.driverLocation else {
            LocationManager.shared.openSettingsDialog()
            return
        }
        let startMeterReqModel = MeterRequestModel()
        startMeterReqModel.driver_id = Singleton.shared.driverId
        startMeterReqModel.pickup_lat = "\(location.latitude)"
        startMeterReqModel.pickup_lng = "\(location.longitude)"
        startMeterReqModel.mobile_no = MobileNumber
        
        WebServiceCalls.StartMeterBooking(reqmodel: startMeterReqModel) { response, status in
            Loader.hideHUD()
            if status {
                print(response)
                MeterManager.reset()
                MeterManager.shared.startMeter()
                self.saveMetrData(json: response)
                let viewCtr = AppViewControllers.shared.meter
                self.push(viewCtr)
                
            }
            else {
                AlertMessage.showMessageForError(response["message"].stringValue)
            }
        }
    }
    
    //MARK:- === Save Login Data =====
    func saveMetrData(json: JSON){
        let rootModel = RootMeterBooking.init(fromJson: json)
        Singleton.shared.meterInfo = rootModel?.meterInfo
    }
}
