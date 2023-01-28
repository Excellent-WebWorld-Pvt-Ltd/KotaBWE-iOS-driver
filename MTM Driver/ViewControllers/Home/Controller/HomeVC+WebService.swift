//
//  DashboardWebserviceList.swift
//  Pappea Driver
//
//  Created by Apple on 22/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation
import UIKit

extension HomeViewController {
    
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods Cancel Trip After Accepted Trip
    //-------------------------------------------------------------
    func cancelTripAfterAccept() {
        let model = CompleteModel()
        model.booking_id = Singleton.shared.bookingInfo?.id ?? ""
        WebServiceCalls.CancelTripService(cancelTripDetailModel: model) { (response, status) in
            Singleton.shared.bookingInfo = nil
            if status {
                self.getFirstView()
            } else {
                UtilityClass.showAlert(message: response.dictionary?["message"]?.stringValue ?? "Cancel trip is not possible due to some reason, \nPlease restart application.")
            }
        }
    }
    //-------------------------------------------------------------
    // MARK: - Webservice Methods Change Duty
    //-------------------------------------------------------------
    func webserviceForChangeDuty() {
        guard let location = Singleton.shared.driverLocation else {
            Singleton.shared.isDriverOnline.toggle()
            NotificationCenter.postCustom(.updateOnlineSwitch)
            LocationManager.shared.openSettingsDialog()
            return
        }
        let model = ChangeDutyStatus()
        model.driver_id = Singleton.shared.driverId
        model.lat = "\(location.latitude)"
        model.lng = "\(location.longitude)"
        Loader.showHUD()
        WebServiceCalls.changeDuty(transferMoneyModel: model) { (response, status) in
            Loader.hideHUD()
            if status {
                let duty = response.dictionaryValue["duty"]?.stringValue ?? ""
                let isOnline = duty == "online"
                if isOnline != Singleton.shared.isDriverOnline {
                    Singleton.shared.isDriverOnline = isOnline
                    self.setupOnlineOfflineView()
                }
            } else {
                ThemeAlertVC.present(from: self, ofType: .simple(message: response["message"].stringValue))
                Singleton.shared.isDriverOnline = !Singleton.shared.isDriverOnline
                self.setupOnlineOfflineView()
            }
            NotificationCenter.postCustom(.updateOnlineSwitch)
        }
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods For Completeing Current Booking
    //-------------------------------------------------------------
    func webserviceCallForCompleteTrip(dictOFParam : AnyObject) {

        let model = CompleteModel()
        model.booking_id = dictOFParam["booking_id"] as! String
        model.dropoff_lat = dictOFParam["dropoff_lat"] as! String
        model.dropoff_lng = dictOFParam["dropoff_lng"] as! String
        Loader.showHUD()
        WebServiceCalls.CompleteTripService(MobileNoDetailModel: model) { (response, status) in
            Loader.hideHUD()
            if status {
                
                let res = RootCompleteTrip(fromJson: response)
                let objcompleteTrip = res.data
                Singleton.shared.bookingInfo = nil
                Singleton.shared.CompleteTrip = objcompleteTrip
                self.getLastView(bookingId: model.booking_id)
                self.driverData.driverState = .available
                self.resetMap()
               
            } else {
                 AlertMessage.showMessageForError(response["message"].stringValue)
            }
        }
    }
    
    func webserviceForCardList() {
        if let loginInfo = SessionManager.shared.userProfile {
            LoginDetail = loginInfo
        }
        CardListReqModel.driver_id = LoginDetail.responseObject.id
        WebServiceCalls.cardList(transferMoneyModel: CardListReqModel) { (json, status) in
            if status {
                let CardListDetails = AddCardModel.init(fromJson: json)
                do {
                    try UserDefaults.standard.set(object: CardListDetails, forKey: "cards")
                } catch {
                    Loader.hideHUD()
                    AlertMessage.showMessageForError("error")
                }
            }
            else {
                AlertMessage.showMessageForError("error")
            }
        }
    }
    
    func webserviceForVehicleList() {
        
        let param: [String: Any] = ["": ""]
        WebServiceCalls.VehicleTypeListApi(strType: param) { (json, status) in
            if status  {
                print(json)
                let VehicleListDetails = VehicleListResultModel.init(fromJson: json)
                Singleton.shared.vehicleListData = VehicleListDetails
            }
            else {
                AlertMessage.showMessageForError(json["message"].stringValue)
            }
        }
    }
}
