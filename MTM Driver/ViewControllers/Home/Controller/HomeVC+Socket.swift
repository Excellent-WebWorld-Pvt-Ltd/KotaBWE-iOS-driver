//
//  DashboardSocketCalls.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 29/04/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

extension HomeViewController: SocketConnected {
    
    // ----------------------------------------------------
    // MARK:- --- All Socket Methods ---
    // ----------------------------------------------------
    // Socket Off All
    func allSocketOffMethods() {
        SocketIOManager.shared.socket.off(socketApiKeys.driverarrived.rawValue)
        SocketIOManager.shared.socket.off(socketApiKeys.driverarivedPickupLocation.rawValue)
        SocketIOManager.shared.socket.off(socketApiKeys.CompleteTrip.rawValue)
       //SocketIOManager.shared.socket.off(socketApiKeys.liveTraking.rawValue)
        SocketIOManager.shared.socket.off(socketApiKeys.trackTrip.rawValue)
        SocketIOManager.shared.socket.off(socketApiKeys.updateDriverLocation.rawValue)
        SocketIOManager.shared.socket.off(socketApiKeys.WhenRequestArrived.rawValue)        // Socket Off 1
        SocketIOManager.shared.socket.off(socketApiKeys.AcceptRequest.rawValue)             // Socket Off 2
        SocketIOManager.shared.socket.off(socketApiKeys.StartTrip.rawValue)                 // Socket Off 3
        SocketIOManager.shared.socket.off(socketApiKeys.onTheWayBookingRequest.rawValue)    // Socket Off 4
        SocketIOManager.shared.socket.off(socketApiKeys.receiveTips.rawValue)               // Socket Off 5
        SocketIOManager.shared.socket.off(socketApiKeys.cancelTrip.rawValue)                // Socket Off 6
        SocketIOManager.shared.socket.off(clientEvent: .disconnect)// Socket Disconnect
        SocketIOManager.shared.socket.off(socketApiKeys.CancelBeforeAccept.rawValue)
        SocketIOManager.shared.socket.off(socketApiKeys.error.rawValue)
    }

    /// Socket On All
    func allSocketOnMethods() {
        onSocketTrackTrip()
        onSocketCancelTripBeforeAccept()
       // onSocketLiveTraking()
        onSocketCompleteTrip()
        onsocketUpdateLocation()
        onSocket_ReceiveBookingRequest()        // Socket On 1
        onSocket_AfterAcceptingRequest()        // Socket On 2
        onSocket_StartTrip()                    // Socket On 3
        onSocket_OnTheWayBookLater()            // Socket On 4
        onSocket_ReceiveTips()                  // Socket On 5
        onSocket_CancelTrip()
        onSocketDriverArrived()
        onSocketDriverArrivedAtPickupLocaction()
        onSocketError()
        // Socket On 6
    }
    
    // ----------------------------------------------------
    // MARK:- --- Socket Emit Methods ---
    // MARK:-
    // ----------------------------------------------------
    
    // Socket Emit 1
    func emitSocket_UpdateDriverLatLng(param: [String : Any]) {
        SocketIOManager.shared.socketEmit(for: socketApiKeys.updateDriverLocation.rawValue, with: param)
    }
    
    
    func emitSocketTrackTrip(param : [String:Any]) {
        SocketIOManager.shared.socketEmit(for: socketApiKeys.trackTrip.rawValue, with: param)
    }
    
    // Socket Emit 2
    func emitSocket_AcceptRequest(param: [String : Any]) {
        SocketIOManager.shared.socketEmit(for: socketApiKeys.AcceptRequest.rawValue, with: param)
    }
    
    
    func onSocketCompleteTrip() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.CompleteTrip.rawValue) { json in
            print(json)
        }
    }
    
    func onSocketDriverArrived() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.driverarrived.rawValue) { json in
            print(json)
        }
    }
    
    func emitSocket_DriverArrivedAtPickupLocation(param: [String : Any]) {
        SocketIOManager.shared.socketEmit(for: socketApiKeys.driverarivedPickupLocation.rawValue, with: param)
    }
    
    func onSocketDriverArrivedAtPickupLocaction() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.driverarivedPickupLocation.rawValue) { json in
            print(json)
        }
    }
    
    func onsocketUpdateLocation() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.updateDriverLocation.rawValue) { json in
            // print(json)
        }
    }
    
    // Socket Emit 3
    func emitSocket_RejectRequest(bookingId: String) {
        Loader.hideHUD()
        var param = [String: Any]()
        param["driver_id"] = Singleton.shared.driverId
        param["booking_id"] = bookingId
        Singleton.shared.bookingInfo = nil
        SocketIOManager.shared.socketEmit(for: socketApiKeys.RejectRequest.rawValue, with: param)
        self.stopProgress()
        self.getFirstView()
        RingManager.shared.stopSound()
        self.resetMap()
    }
    
    func emitSocket_ForwardRequest(bookingId: String) {
        var param = [String: Any]()
        param["driver_id"] = Singleton.shared.driverId
        param["booking_id"] = bookingId
        SocketIOManager.shared.socketEmit(for: socketApiKeys.RejectRequest.rawValue, with: param)
    }
    
    // Socket Emit 4
    func emitSocket_StartTrip(param: [String : Any]) {
        SocketIOManager.shared.socketEmit(for: socketApiKeys.StartTrip.rawValue, with: param)
    }
    
    // Socket Emit 5
    func emitSocket_OnTheWayBookingRequest(param: [String : Any]) {
        SocketIOManager.shared.socketEmit(for: socketApiKeys.onTheWayBookingRequest.rawValue, with: param)
    }
    
    // Socket Emit 6
    func emitSocket_AskForTips(param: [String:Any]) {
        SocketIOManager.shared.socketEmit(for: socketApiKeys.askForTips.rawValue, with: param)
    }
    
    // ----------------------------------------------------
    // MARK:- --- Socket On Methods ---
    // ----------------------------------------------------
   
    // Socket On 1
    func onSocket_ReceiveBookingRequest() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.WhenRequestArrived.rawValue) { [unowned self] json in
            print(#function)
            print("\n \(json)")
            let booking = bookingAcceptedeDataModel(fromJson: json.array?.first)
            if Singleton.shared.bookingInfo == nil {
                Singleton.shared.bookingInfo = booking.bookingInfo
                self.presentView(forState: .request)
                RingManager.shared.playSound()
                self.setProgress()
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                if let id  = booking.bookingInfo.id {
                    self.emitSocket_ForwardRequest(bookingId: id)
                }
            }
        }
    }
    
    //MARK:- ==== On socket Track Trip ====
    func onSocketError() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.error.rawValue) { json in
            print(json)
            let message = json.array?.first?.getApiMessage()
            if message != ""{
                ThemeAlertVC.present(from: self, ofType: .simple(title: "", message: message ?? ""))
            }
        }
        SocketIOManager.shared.socketCall(for: socketApiKeys.pickupTimeError.rawValue) { json in
            print(json)
            let message = json.array?.first?.getApiMessage()
            if message != ""{
                ThemeAlertVC.present(from: self, ofType: .simple(title: "", message: message ?? ""))
            }
        }
    }
    
    func onSocketTrackTrip() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.trackTrip.rawValue) { json in
            print(#function)
        }
    }
    
    // Socket On 2
    func onSocket_AfterAcceptingRequest() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.AcceptRequest.rawValue){ json in
            print(#function)
            print("\n \(json)")
            let booking = bookingAcceptedeDataModel(fromJson: json.array?.first)
            guard booking.bookingInfo.bookingType != "book_later" else {
                return
            }
            Singleton.shared.bookingInfo = booking.bookingInfo
            self.stopProgress()
            if let bookingView = self.presentView as? DriverInfoView {
                self.bookingData = Singleton.shared.bookingInfo!
                self.driverData.driverState = .requestAccepted
                self.presentView(forState: .requestAccepted)
                self.resetMap()
                bookingView.setDriverData(status:.requestAccepted)
            }
            let message = json.first?.1.dictionary?["message"]?.stringValue
            AlertMessage.showMessageForSuccess(message ?? "Booking Request Accepted")
        }
    }
    
    // Socket On 3
    func onSocket_StartTrip() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.StartTrip.rawValue){ json in
            print(#function)
            print("\n \(json)")
            self.bookingData = Singleton.shared.bookingInfo!
            self.driverData.driverState = .inTrip
            if let bookingView = self.presentView as? DriverInfoView {
                bookingView.setDriverData(status:.inTrip)
                self.resetMap()
                
            }
        }
    }
    
    func onSocketLiveTraking() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.liveTraking.rawValue) { json in
            print(#function)
            print("\n \(json)")
        }
    }
    

    // Socket On 4
    func onSocket_OnTheWayBookLater() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.onTheWayBookingRequest.rawValue){ json in
            print(#function)
            print("\n \(json)")
            //AlertMessage.showMessageForSuccess(#function)
            
            let booking = bookingAcceptedeDataModel(fromJson: json.array?.first)
            Singleton.shared.bookingInfo = booking.bookingInfo
            self.stopProgress()
            self.bookingData = Singleton.shared.bookingInfo!
            self.driverData.driverState = .requestAccepted
            self.presentView(forState: .requestAccepted)
            self.resetMap()
            let message = json.first?.1.dictionary?["message"]?.stringValue
           AlertMessage.showMessageForSuccess(message ?? "Booking Request Accepted")
        }
        }
    
    
    // Socket On 5
    func onSocket_ReceiveTips() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.receiveTips.rawValue){ json in
            print(#function)
            print("\n \(json)")
            
            self.resetMap()
            
            if let msg = json.array?.first?.dictionary?["message"] {
               AlertMessage.showMessageForSuccess(msg.stringValue)
            }
            
            var param = [String: Any]()            
            param["booking_id"] = Singleton.shared.bookingInfo?.id
            param["dropoff_lat"] = Singleton.shared.bookingInfo?.dropoffLat
            param["dropoff_lng"] = Singleton.shared.bookingInfo?.dropoffLng
            self.webserviceCallForCompleteTrip(dictOFParam: param as AnyObject)
        }
    }
    
    // Socket On 6
    func onSocket_CancelTrip() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.cancelTrip.rawValue){ [unowned self] json in
            print(#function)
            RingManager.shared.stopSound()
            print("\n \(json)")
            guard let infoDict = json.array?.first,
                  Singleton.shared.bookingInfo?.id == infoDict["booking_id"].stringValue else {
                return
            }
            Singleton.shared.bookingInfo = nil
            if let msg = infoDict["message"].string {
                AlertMessage.showMessageForInformation(msg)
                self.getFirstView()
                self.driverData.driverState = .available
                self.resetMap()
            }
        }
    }
    
    func onSocketCancelTripBeforeAccept() {
        SocketIOManager.shared.socketCall(for: socketApiKeys.CancelBeforeAccept.rawValue){ json in
            print(#function)
            RingManager.shared.stopSound()
            Singleton.shared.bookingInfo = nil
            print("\n \(json)")
            if let msg = json.array?.first?.dictionary?["message"] {
                AlertMessage.showMessageForError(msg.stringValue)
                self.getFirstView()
                self.driverData.driverState = .available
                self.resetMap()
            }
        }
    }
    
    @objc func trackTrip(){
        guard SocketIOManager.shared.isConnected else {
            return
        }
        guard let location = Singleton.shared.driverLocation else {
            LocationManager.shared.openSettingsDialog()
            return
        }
        
        if Singleton.shared.bookingInfo != nil {
            let param: [String: Any] = [
                "customer_id":  Singleton.shared.bookingInfo?.customerId ?? "",
                "lat": "\(location.latitude)",
                "lng": "\(location.longitude)"
            ]
            emitSocketTrackTrip(param: param)
            updateTravelledPath(currentLoc: location)
        }
    }
    
    
    
    @objc func updateDriverLocation(){
        
        if Singleton.shared.userProfile != nil {
            if let driver = Singleton.shared.userProfile?.responseObject {
                guard let location = Singleton.shared.driverLocation else {
                    LocationManager.shared.openSettingsDialog()
                    return
                }
                let param = [
                    "driver_id" : "\(driver.id ?? "")",
                    "lat" : "\(location.latitude)",
                    "lng" : "\(location.longitude)"
                
                ] as [String:AnyObject]
                
                if SocketIOManager.shared.socket.status == .connected {
//                    emitSocket_UpdateDriverLatLng(param: param)
                }

            }
        }
    }
}
extension MeterDisplayVC {
    
    func allSocketOffMethod(){
        SocketIOManager.shared.socket.off(socketApiKeys.updateMeterBooking.rawValue)
        SocketIOManager.shared.socket.off(socketApiKeys.startWaitingTimeForMeter.rawValue)
        SocketIOManager.shared.socket.off(socketApiKeys.endWaitingTimeForMeter.rawValue)

    }
    
    // Socket Emit 4
    func emitSocket_UpdateMeterBookingStatus(param: [String : Any]) {
        SocketIOManager.shared.socketEmit(for: socketApiKeys.updateMeterBooking.rawValue, with: param)
    }
    
    // Socket Emit 5
    func emitSocket_StartWaitingTimeForMeter(param: [String : Any]) {
        SocketIOManager.shared.socketEmit(for: socketApiKeys.startWaitingTimeForMeter.rawValue, with: param)
    }
    
    // Socket Emit 6
    func emitSocket_EndWaitingTimeForMeter(param: [String:Any]) {
        SocketIOManager.shared.socketEmit(for: socketApiKeys.endWaitingTimeForMeter.rawValue, with: param)
    }
}
