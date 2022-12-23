//
//  CompleteTripData.swift
//  DSP Driver
//
//  Created by Admin on 19/11/21.
//  Copyright © 2021 baps. All rights reserved.
//

import Foundation
import SwiftyJSON


class CompeteTripData {

    var acceptTime : String!
    var arrivedTime : String!
    var baseFare : String!
    var bookingFee : String!
    var bookingTime : String!
    var bookingType : String!
    var cancelBy : String!
    var canceleReason : String!
    var cancellationCharge : String!
    var cardId : String!
    var companyAmount : String!
    var customerId : String!
    var customerInfo : CustomerInfo!
    var discount : String!
    var distance : String!
    var distanceFare : String!
    var driverAmount : String!
    var driverId : String!
    var driverInfo : DriverInfo!
    var driverVehicleInfo : VehicleInfo!
    var dropoffLat : String!
    var dropoffLng : String!
    var dropoffLocation : String!
    var dropoffTime : String!
    var durationFare : String!
    var estimatedFare : String!
    var extraCharge : String!
    var fareIncrease : String!
    var fareIncreaseId : String!
    var fixRateId : String!
    var grandTotal : String!
    var id : String!
    var isChangedPaymentType : String!
    var noOfPassenger : String!
    var onTheWay : String!
    var paymentResponse : String!
    var paymentStatus : String!
    var paymentType : String!
    var pickupDateTime : String!
    var pickupLat : String!
    var pickupLng : String!
    var pickupLocation : String!
    var pickupTime : String!
    var pin : String!
    var promocode : String!
    var referenceId : String!
    var rentType : String!
    var requestCode : String!
    var requestId : String!
    var status : String!
    var subTotal : String!
    var tax : String!
    var tips : String!
    var tipsStatus : String!
    var tripDuration : String!
    var vehicleType : VehicleType!
    var vehicleTypeId : String!
    var waitingTime : String!
    var waitingTimeCharge : String!
    var message : String!
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        acceptTime = json["accept_time"].stringValue
        arrivedTime = json["arrived_time"].stringValue
        baseFare = json["base_fare"].stringValue
        bookingFee = json["booking_fee"].stringValue
        bookingTime = json["booking_time"].stringValue
        bookingType = json["booking_type"].stringValue
        cancelBy = json["cancel_by"].stringValue
        canceleReason = json["cancele_reason"].stringValue
        cancellationCharge = json["cancellation_charge"].stringValue
        cardId = json["card_id"].stringValue
        companyAmount = json["company_amount"].stringValue
        customerId = json["customer_id"].stringValue
        let customerInfoJson = json["customer_info"]
        if !customerInfoJson.isEmpty{
            customerInfo = CustomerInfo(fromJson: customerInfoJson)
        }
        discount = json["discount"].stringValue
        distance = json["distance"].stringValue
        distanceFare = json["distance_fare"].stringValue
        driverAmount = json["driver_amount"].stringValue
        driverId = json["driver_id"].stringValue
        let driverInfoJson = json["driver_info"]
        if !driverInfoJson.isEmpty{
            driverInfo = DriverInfo(fromJson: driverInfoJson)
        }
        let driverVehicleInfoJson = json["driver_vehicle_info"]
        if !driverVehicleInfoJson.isEmpty{
            driverVehicleInfo = VehicleInfo(fromJson: driverVehicleInfoJson)
        }
        dropoffLat = json["dropoff_lat"].stringValue
        dropoffLng = json["dropoff_lng"].stringValue
        dropoffLocation = json["dropoff_location"].stringValue
        dropoffTime = json["dropoff_time"].stringValue
        durationFare = json["duration_fare"].stringValue
        estimatedFare = json["estimated_fare"].stringValue
        extraCharge = json["extra_charge"].stringValue
        fareIncrease = json["fare_increase"].stringValue
        fareIncreaseId = json["fare_increase_id"].stringValue
        fixRateId = json["fix_rate_id"].stringValue
        grandTotal = json["grand_total"].stringValue
        id = json["id"].stringValue
        isChangedPaymentType = json["is_changed_payment_type"].stringValue
        noOfPassenger = json["no_of_passenger"].stringValue
        onTheWay = json["on_the_way"].stringValue
        paymentResponse = json["payment_response"].stringValue
        paymentStatus = json["payment_status"].stringValue
        paymentType = json["payment_type"].stringValue
        pickupDateTime = json["pickup_date_time"].stringValue
        pickupLat = json["pickup_lat"].stringValue
        pickupLng = json["pickup_lng"].stringValue
        pickupLocation = json["pickup_location"].stringValue
        pickupTime = json["pickup_time"].stringValue
        pin = json["pin"].stringValue
        promocode = json["promocode"].stringValue
        referenceId = json["reference_id"].stringValue
        rentType = json["rent_type"].stringValue
        requestCode = json["request_code"].stringValue
        requestId = json["request_id"].stringValue
        status = json["status"].stringValue
        subTotal = json["sub_total"].stringValue
        tax = json["tax"].stringValue
        tips = json["tips"].stringValue
        tipsStatus = json["tips_status"].stringValue
        tripDuration = json["trip_duration"].stringValue
        let vehicleTypeJson = json["vehicle_type"]
        if !vehicleTypeJson.isEmpty{
            vehicleType = VehicleType(fromJson: vehicleTypeJson)
        }
        vehicleTypeId = json["vehicle_type_id"].stringValue
        waitingTime = json["waiting_time"].stringValue
        waitingTimeCharge = json["waiting_time_charge"].stringValue
    }

}
