//
//  MeterManager.swift
//  MTM Driver
//
//  Created by Gaurang on 22/11/22.
//  Copyright © 2022 baps. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

protocol MeterMangerDelegate {
    func meterDidChangeTripFare()
    func meterDidChangeTripTime()
    func meterDidChangeTripDistance()
    func meterDidChangeWaitingTime()
    func meterChangeStartStopButtonStatus()
    func meterPresentInvoiceView()
    func meterGetWaitingTimeText() -> String
}

class MeterManager: NSObject {
    
    static var shared = MeterManager()
    
    override init() {
        super.init()
    }
    
    var delegate: MeterMangerDelegate?
    
    var timer: Timer?
    var waitingTimer: Timer?
    var isPaused = false
    var minKM: Double = 0
    var updateMeterstatusTimer : Timer?
    var total = 0.0
    var isRunning: Bool = false
    var strVehicleName = ""
    var baseFare: Double = 0
    var perKMCharge: Double = 0
    var waitingChargePerMinute: Double = 0
    var bookingFee: Double = 0
    var waitingMinutes: String = ""
    var strSpeed: String = ""
    var arrCarModels = [[String:AnyObject]]()
    var arrMeterCarModels = [[String:AnyObject]]()
    var vehicleModelID: Int = 0
    var isMeterOnHold = false
    var tripTimeDuration = 0
    var waitingTime = 0
    var traveledDistance: Double = 0
    var lastLocation: CLLocation?
    
    var isStartWaitingEnabled: Bool = true
    var isEndWaitingEnabled: Bool = false
    
    var formattedTripTime: String {
        self.tripTimeDuration.getMeterFormattedTime()
    }
    
    var formattedWatingTime: String {
        self.waitingTime.getMeterFormattedTime()
    }
    
    var formattedTripDistance: String {
        String(format:"%.2f", self.traveledDistance)
    }
    
    func setValues(_ info: MeterInfo) {
        isRunning = true
        self.startMeter()
        let tripDuration = Int(info.duration) ?? 0
        var distance = info.distance ?? 0
        if tripDuration > 0 {
            self.tripTimeDuration = tripDuration
        } else {
            self.tripTimeDuration = SessionManager.shared.meterDuration ?? 0
        }
        self.traveledDistance = distance
        let startWatingTime = Int(info.startWaitingTime) ?? 0
        let endWatingTime = Int(info.endWaitingTime) ?? 0
        // Waiting Time: Just started once but not ended yet
        if startWatingTime > 0 && endWatingTime == 0 {
            let differenceWaitingTime = Singleton.shared.currentTime - startWatingTime
            self.waitingTime = differenceWaitingTime
            delegate?.meterDidChangeWaitingTime()
            self.startedWaitingMeterSetup()
        } else if startWatingTime > 0 && endWatingTime > 0 {
            if startWatingTime > endWatingTime {
                self.waitingTime = (startWatingTime - endWatingTime) + (Int(info.waitingTime) ?? 0)
                delegate?.meterDidChangeWaitingTime()
                self.startedWaitingMeterSetup()
            } else {
                // Waiting time: Started and ended
                let differenceWaitingTime = endWatingTime - startWatingTime
                self.waitingTime = differenceWaitingTime
                delegate?.meterDidChangeWaitingTime()
                self.stopWaitingMeterSetup()
            }
        } else if startWatingTime > 0 {
            isStartWaitingEnabled = false
            isEndWaitingEnabled = true
            delegate?.meterChangeStartStopButtonStatus()
            self.waitingTime = startWatingTime
        } else {
            isStartWaitingEnabled = true
            isEndWaitingEnabled = false
            delegate?.meterChangeStartStopButtonStatus()
        }
        self.calculateDistanceAndPrice()
        self.updateMeterBookingStatus()
    }
    
    static func reset() {
        MeterManager.shared.timer?.invalidate()
        MeterManager.shared.waitingTimer?.invalidate()
        MeterManager.shared.waitingTimer = nil
        MeterManager.shared.timer = nil
        SessionManager.shared.meterTravelDistance = nil
        SessionManager.shared.meterDuration = nil
        shared = MeterManager()
    }
    
    func startMeter() {
        isRunning = true
        self.startUpdateDriverMeterStatusTimer()
        self.startTimer()
       /* if SessionManager.shared.tripDuration != nil {
            if let startedTime = Int(Singleton.shared.meterInfo?.startedTime ?? "0") {
                let tripDurationTime = Singleton.shared.currentTime - startedTime
                self.tripTimeDuration = tripDurationTime
            }
        }
        else {
            self.tripTimeDuration = 0
        }
        if Singleton.shared.meterInfo?.startWaitingTime != "0" && Singleton.shared.meterInfo?.endWaitingTime == "0"{
            if let startWaitingTime = Int(Singleton.shared.meterInfo?.startWaitingTime ?? "0"){
               // self.waitingTime = startWaitingTime
                let differenceWaitingTime = Singleton.shared.currentTime - startWaitingTime
                self.waitingTime = differenceWaitingTime
                delegate?.meterDidChangeWaitingTime()
                self.startedWaitingMeterSetup()
            }
        }
        else if Singleton.shared.meterInfo?.startWaitingTime != "0" && Singleton.shared.meterInfo?.endWaitingTime != "0" {
            var IntstartWaitingTime = 0
            var IntendWaitingTime = 0
            if let  startWaitingTime = Int(Singleton.shared.meterInfo?.startWaitingTime ?? "0") {
                  IntstartWaitingTime = startWaitingTime
            }
            if let endWaitingTime = Int(Singleton.shared.meterInfo?.endWaitingTime ?? "0") {
                 IntendWaitingTime = endWaitingTime
            }
            if  IntstartWaitingTime > IntendWaitingTime {
                let differenceWaitingTime = Singleton.shared.currentTime - IntstartWaitingTime
                self.waitingTime = differenceWaitingTime
                delegate?.meterDidChangeWaitingTime()
                self.startedWaitingMeterSetup()
            }
            else {
                let differenceWaitingTime =  IntendWaitingTime - IntstartWaitingTime
                self.waitingTime = differenceWaitingTime
                delegate?.meterDidChangeWaitingTime()
                self.stopWaitingMeterSetup()
            }
            
        }
        else if Singleton.shared.meterInfo?.startWaitingTime != "0"{
            
            if let startWaitingTime = Int(Singleton.shared.meterInfo?.startWaitingTime ?? "0") {
                isStartWaitingEnabled = false
                isEndWaitingEnabled = true
                delegate?.meterChangeStartStopButtonStatus()
                self.waitingTime = startWaitingTime
            }
        } else {
            isStartWaitingEnabled = true
            isEndWaitingEnabled = false
            delegate?.meterChangeStartStopButtonStatus()
        }
        */
    }
    
    func startUpdateDrivermeterStatusTimer() {
        if(updateMeterstatusTimer == nil){
            updateMeterstatusTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (timer) in
                if  SocketIOManager.shared.socket.status == .connected {
                    self.updateMeterBookingStatus()
                }
            })
        }
    }
    
    func endMeterTimer(){
        updateMeterstatusTimer?.invalidate()
        updateMeterstatusTimer = nil
        
    }
    
    func startTimer(){
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
        }
    }
    
    func playPauseWaitingTime(){
        if isPaused{
            
            waitingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(waitingTimerSetup), userInfo: nil, repeats: true)
            isPaused = false
            
        } else {
            
            waitingTimer?.invalidate()
            isPaused = true
        }
    }
    
    func timeString(time: TimeInterval) -> String {
        let hour = Int(time) / 3600
        let minute = Int(time) / 60 % 60
        let second = Int(time) % 60
        
        // return formated string
        return String(format: "%02i:%02i:%02i", hour, minute, second)
    }
    
    
    @objc func countdown() {
        self.tripTimeDuration += 1
        delegate?.meterDidChangeTripTime()
        SessionManager.shared.meterDuration = self.tripTimeDuration
    }
    
    @objc func updateLabel()
    {
        delegate?.meterDidChangeTripDistance()
        if timer != nil {
            self.calculateDistanceAndPrice()
        }
        
    }
    
    @objc func waitingTimerSetup(){
        if  waitingTimer != nil {
            waitingTime += 1
            delegate?.meterDidChangeWaitingTime()
            self.waitingMinutes = "\(waitingTime)"
        }
    }
    
    //MARK:- === Calculation Distance and price ====
    func calculateDistanceAndPrice() {
        guard let meterInfo = Singleton.shared.meterInfo,
              let bookingFree = meterInfo.bookingFee.toDouble() else {
            return
        }
        if self.traveledDistance <= self.minKM {
            self.bookingFee = bookingFree
        } else {
            if self.traveledDistance <= minKM {
                if let perKMCharge = meterInfo.perKMCharge.toDouble() {
                    let distanceTravelled = self.traveledDistance.rounded(toPlaces: 2)
                    total = (distanceTravelled * perKMCharge) + bookingFree
                    //baseFare + bookingFee
                }
            } else {
                if let perKMCharge = meterInfo.perKMCharge.toDouble() {
                    let distanceTravelled = self.traveledDistance.rounded(toPlaces: 2)
                    total = (distanceTravelled * perKMCharge) + bookingFree
                    //baseFare + bookingFee
                }
            }
        }
        
        var waitingMinutes = "0.0"
        if (waitingTime > 0) {
            let totalWaitingMinutes = self.waitingTime / 60
            guard let minutes = delegate?
                .meterGetWaitingTimeText().components(separatedBy: ":"), minutes.count > 1 else {
                return
            }
            waitingMinutes = minutes[1]
            
            
            if (waitingMinutes != "")
            {
                let waitingTimePerCharge = meterInfo.waitingTimePerMinCharge.toDouble()
                total = total + (Double(totalWaitingMinutes) * waitingTimePerCharge!)
            }
        }
        delegate?.meterDidChangeTripFare()
    }
    
    func startedWaitingMeterSetup(){
        self.isRunning = false
        isStartWaitingEnabled = false
        isEndWaitingEnabled = false
        delegate?.meterChangeStartStopButtonStatus()
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.isStartWaitingEnabled = false
            self.isEndWaitingEnabled = true
            self.delegate?.meterChangeStartStopButtonStatus()
        }
        isPaused = true
        playPauseWaitingTime()
    }
    
    func stopWaitingMeterSetup() {
        self.isRunning = true
        isStartWaitingEnabled = false
        isEndWaitingEnabled = false
        delegate?.meterChangeStartStopButtonStatus()
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.isStartWaitingEnabled = true
            self.isEndWaitingEnabled = false
            self.delegate?.meterChangeStartStopButtonStatus()
        }
        ////
        isPaused = false
        playPauseWaitingTime()
    }
    
    @objc func updateMeterBookingStatus(){
        guard Singleton.shared.userProfile != nil else {
            return
        }
        if let driver = Singleton.shared.userProfile?.responseObject {
            let param = [
                "driver_id" : "\(driver.id ?? "")",
                "booking_id" : Singleton.shared.meterId,
                "customer_id" : Singleton.shared.meterInfo?.customerID ?? "",
                "trip_time" : "\(self.tripTimeDuration)",
                "trip_distance" : String(format:"%.2f", traveledDistance),
                "waiting_time" : "\(self.waitingTime)",
                "fare" : "\(String(format:"%.2f", total))"
                
            ] as [String:AnyObject]
            if SocketIOManager.shared.socket.status == .connected {
                SocketIOManager.shared.socketEmit(for: socketApiKeys.updateMeterBooking.rawValue, with: param)
            }
            SessionManager.shared.meterTravelDistance = traveledDistance
            SessionManager.shared.meterDuration = tripTimeDuration
        }
    }
    
    
    func startUpdateDriverMeterStatusTimer() {
        if(updateMeterstatusTimer == nil){
            updateMeterstatusTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (timer) in
                if  SocketIOManager.shared.socket.status == .connected {
                    self.updateMeterBookingStatus()
                }
            })
        }
    }
    
    @objc func startWaitingTimeMeter(){
        guard let driver = Singleton.shared.userProfile?.responseObject else {
            return
        }
        let param = [
            "driver_id" : driver.id ?? "",
            "booking_id" : Singleton.shared.meterId,
            "customer_id" : Singleton.shared.meterInfo?.customerID ?? ""
            
        ] as [String:AnyObject]
        
        if SocketIOManager.shared.socket.status == .connected {
            SocketIOManager.shared.socketEmit(for: socketApiKeys.startWaitingTimeForMeter.rawValue, with: param)
        }
    }
    
    @objc func endWaitingTimeMeter() {
        guard let driver = Singleton.shared.userProfile?.responseObject else {
            return
        }
        let param: [String: Any] = [
            "driver_id" : "\(driver.id ?? "")",
            "booking_id" : Singleton.shared.meterId,
            "customer_id" : Singleton.shared.meterInfo?.customerID ?? ""
        ]
        
        print(param)
        
        if SocketIOManager.shared.socket.status == .connected {
            SocketIOManager.shared.socketEmit(for: socketApiKeys.endWaitingTimeForMeter.rawValue, with: param)
        }
    }

    func locationUpdate(location: CLLocation) {
        guard self.isRunning else {
            self.lastLocation = nil
            return
        }
        if let lastLocation = self.lastLocation {
            let distance = lastLocation.distance(from: location)/1000
            if distance > 0 {
                MeterManager.shared.traveledDistance += distance
                if Helper.isLogEnabled {
                    print(String(format: "The distance to my buddy is %.02fkm", MeterManager.shared.traveledDistance))
                }
                self.calculateDistanceAndPrice()
                delegate?.meterDidChangeTripDistance()
            }
        }
        lastLocation = location
    }
    
    func webServiceCallEndMeter(){
        guard let location = Singleton.shared.driverLocation else {
            LocationManager.shared.openSettingsDialog()
            return
        }
        Loader.showHUD()
        let reqModel = EndMeterRequestModel()
        reqModel.meter_id = Singleton.shared.meterId
        reqModel.distance = String(traveledDistance)
        reqModel.fare = String(format:"%.2f", total)
        reqModel.duration = "\(self.tripTimeDuration)"
        reqModel.waiting_time = "\(self.waitingTime)"
        reqModel.dropoff_lat = "\(location.latitude)"
        reqModel.dropoff_lng = "\(location.longitude)"
        WebServiceCalls.EndMeterBooking(reqModel: reqModel) { response, status in
            Loader.hideHUD()
            if status {
                print(response)
                self.delegate?.meterPresentInvoiceView()
                self.endMeterTimer()
                Singleton.shared.meterInfo = nil
                MeterManager.reset()
            }
            else {
                AlertMessage.showMessageForError(response["message"].stringValue)
            }
        }
    }
}

extension Int {
    
    func getMeterFormattedTime() -> String {
        let hours = self / 3600
        let minutes = (self % 3600) / 60
        let seconds = (self % 3600) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
}
