//
//  RootMeterBooking.swift
//  DSP Driver
//
//  Created by Admin on 06/12/21.
//  Copyright © 2021 baps. All rights reserved.
//

import Foundation
import SwiftyJSON


// MARK: - Welcome
class RootMeterBooking: Codable {

    var status: Bool?
    var message: String?
    var meterInfo: MeterInfo?

    init?(fromJson json: JSON){
        guard json.isEmpty == false else {
            return
        }
        status = json["status"].boolValue
        message = json["message"].stringValue
        meterInfo = MeterInfo(fromJson: json["vehicle_info"])
        meterInfo?.setBookingData(json: json["booking_info"])
    }
}

// MARK: - MeterInfo
class MeterInfo: Codable {
    var id, meterId, driverID, bookingFee, vehicleID, customerID: String
    var pickupLat, pickupLng, dropoffLat, dropoffLng: String
    var startedTime, endedTime, status, duration: String
    var fare, waitingTime, startWaitingTime: String
    var endWaitingTime, name, baseKM, perKMCharge, waitingTimePerMinCharge: String
    var distance: Double?
    
    init?(fromJson json: JSON){
        guard !json.isEmpty else {
            return nil
        }
        self.id = json["id"].stringValue
        self.meterId = json["meter_id"].stringValue
        bookingFee = json["booking_fee"].stringValue
        waitingTimePerMinCharge = json["free_cancallation_time"].stringValue
        self.driverID = json["driver_id"].stringValue
        self.vehicleID = json["vehicle_id"].stringValue
        self.customerID = json["customer_id"].stringValue
        self.pickupLat = json["pickup_lat"].stringValue
        self.pickupLng = json["pickup_lng"].stringValue
        self.dropoffLat = json["dropoff_lat"].stringValue
        self.dropoffLng = json["dropoff_lng"].stringValue
        self.startedTime = json["started_time"].stringValue
        self.endedTime = json["ended_time"].stringValue
        self.status = json["status"].stringValue
        self.duration = json["duration"].stringValue
        self.distance = json["distance"].double
        self.fare = json["fare"].stringValue
        self.waitingTime = json["waiting_time"].stringValue
        self.startWaitingTime = json["start_waiting_time"].stringValue
        self.endWaitingTime = json["end_waiting_time"].stringValue
        self.name = json["name"].stringValue
        self.baseKM = json["base_km"].stringValue
        self.perKMCharge = json["per_km_charge"].stringValue
    }
    
    func setBookingData(json: JSON) {
        guard json.isEmpty == false else {
            return
        }
        meterId = json["meter_booking_id"].stringValue
        vehicleID = json["vehicle_id"].stringValue
        pickupLat = json["pickup_lat"].stringValue
        pickupLng = json["pickup_lng"].stringValue
        driverID = json["driver_id"].stringValue
        startedTime = json["started_time"].stringValue
        customerID = json["customer_id"].stringValue
    }
}
