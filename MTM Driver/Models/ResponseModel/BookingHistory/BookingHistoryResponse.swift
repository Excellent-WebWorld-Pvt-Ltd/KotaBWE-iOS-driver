//
//  Datum.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on November 19, 2021

import Foundation
import SwiftyJSON


class BookingHistoryResponse : NSObject{

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
    var customerFirstName : String!
    var customerId : String!
    var customerLastName : String!
    var discount : String!
    var distance : String!
    var distanceFare : String!
    var driverAmount : String!
    var driverId : String!
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
    var status : TripCompletedStatus!
    var subTotal : String!
    var tax : String!
    var tips : String!
    var tipsStatus : String!
    var tripDuration : String!
    var vehicleModel : String!
    var vehicleName : String!
    var vehiclePlateNumber : String!
    var vehicleTypeId : String!
    var vehicleTypeName : String!
    var waitingTime : String!
    var waitingTimeCharge : String!
    var customerImage : String!
    var customerMobileNumber : String!
    var cargoImage: [JSON]?
    var cargoWeightKg: String?
    var itemQuantity: String?
    var truckLoadType: String?
    var notes: String?

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
        customerFirstName = json["customer_first_name"].stringValue
        customerId = json["customer_id"].stringValue
        customerLastName = json["customer_last_name"].stringValue
        discount = json["discount"].stringValue
        distance = json["distance"].stringValue
        distanceFare = json["distance_fare"].stringValue
        driverAmount = json["driver_amount"].stringValue
        driverId = json["driver_id"].stringValue
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
        let statusString = json["status"].stringValue
        status = TripCompletedStatus(rawValue: statusString) ?? .cancelled
        subTotal = json["sub_total"].stringValue
        tax = json["tax"].stringValue
        tips = json["tips"].stringValue
        tipsStatus = json["tips_status"].stringValue
        tripDuration = json["trip_duration"].stringValue
        vehicleModel = json["vehicle_model"].stringValue
        vehicleName = json["vehicle_name"].stringValue
        vehiclePlateNumber = json["vehicle_plate_number"].stringValue
        vehicleTypeId = json["vehicle_type_id"].stringValue
        vehicleTypeName = json["vehicle_type_name"].stringValue
        waitingTime = json["waiting_time"].stringValue
        waitingTimeCharge = json["waiting_time_charge"].stringValue
        customerImage = json["customer_profile_image"].stringValue
        customerMobileNumber = json["customer_mobile_no"].stringValue
        cargoImage = json["cargo_image"].arrayValue
        cargoWeightKg = json["cargo_weight_kg"].stringValue
        itemQuantity = json["item_quantity"].stringValue
        truckLoadType = json["truck_load_type"].stringValue
        notes = json["notes"].stringValue
    }

    
}

enum TripCompletedStatus: String {
    case cancelled
    case accepted
    case pending
    case completed
    case traveling

    var color: UIColor {
        switch self {
        case .pending:
            return UIColor.hexStringToUIColor(hex: "#F0C44B")
        case .cancelled:
            return UIColor.hexStringToUIColor(hex: "#FF0000")
        case .accepted, .traveling:
            return UIColor.hexStringToUIColor(hex: "#006CB5")
        case .completed:
            return UIColor.hexStringToUIColor(hex: "#53CB3D")
        }
    }

    var title: String {
        if self == .pending {
            return  "Pending"
        }else if self == .cancelled {
            return "Cancelled"
        }else if self == .completed{
            return "Completed"
        } else {
            return rawValue.capitalized
        }
    }
}
