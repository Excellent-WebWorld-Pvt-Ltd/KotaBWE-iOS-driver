//
//  BookingInfo.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 2, 2019

import Foundation
import SwiftyJSON


class BookingInfo : NSObject, NSCoding{
    var _id : String!
    var acceptTime : String!
    var arrivedTime : String!
    var baseFare : String!
    var bookingFee : String!
    var bookingTime : String!
    var bookingType : String!
    var cancelBy : String!
    var cancellationCharge : String!
    var cardId : String!
    var companyAmount : String!
    var customerId : String!
    var customerInfo : CustomerInfo?
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
    var estimatedTime : String!
    var extraCharge : String!
    var grandTotal : String!
    var id : String!
    var noOfPassenger : String!
    var onTheWay : String!
    var paymentStatus : String!
    var paymentType : String!
    var pickupDateTime : String!
    var pickupLat : String!
    var pickupLng : String!
    var pickupLocation : String!
    var pickupTime : String!
    var promocode : String!
    var referenceId : String!
    var status : String!
    var subTotal : String!
    var tax : String!
    var tips : String!
    var tipsStatus : String!
    var tripDuration : String!
    var vehicleType : VehicleTypeBookingAcceptedeData!
    var vehicleTypeId : String!
    var cargoWeightKg : String!
    var truckLoadType : String!
    var itemQuantity : String!
    var name: String!
    var waitingTime :String!
    var cargoImage: [JSON]?
    var notes: String?

    var statusEnum: TripStatusEnum? {
        TripStatusEnum(rawValue: status)
    }
    
    override init() {
    }
    
	init?(fromJson json: JSON){
        guard let bookingId = json["id"].string else {
            return nil
        }
        self.id = bookingId
        
        _id = json["_id"].stringValue
        acceptTime = json["accept_time"].stringValue
        arrivedTime = json["arrived_time"].stringValue
        baseFare = json["base_fare"].stringValue
        bookingFee = json["booking_fee"].stringValue
        bookingTime = json["booking_time"].stringValue
        bookingType = json["booking_type"].stringValue
        cancelBy = json["cancel_by"].stringValue
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
        dropoffLat = json["dropoff_lat"].stringValue
        dropoffLng = json["dropoff_lng"].stringValue
        dropoffLocation = json["dropoff_location"].stringValue
        dropoffTime = json["dropoff_time"].stringValue
        durationFare = json["duration_fare"].stringValue
        estimatedFare = json["estimated_fare"].stringValue
        extraCharge = json["extra_charge"].stringValue
        grandTotal = json["grand_total"].stringValue
        noOfPassenger = json["no_of_passenger"].stringValue
        onTheWay = json["on_the_way"].stringValue
        paymentStatus = json["payment_status"].stringValue
        paymentType = json["payment_type"].stringValue
        pickupDateTime = json["pickup_date_time"].stringValue
        pickupLat = json["pickup_lat"].stringValue
        pickupLng = json["pickup_lng"].stringValue
        pickupLocation = json["pickup_location"].stringValue
        pickupTime = json["pickup_time"].stringValue
        promocode = json["promocode"].stringValue
        referenceId = json["reference_id"].stringValue
        status = json["status"].stringValue
        subTotal = json["sub_total"].stringValue
        tax = json["tax"].stringValue
        tips = json["tips"].stringValue
        tipsStatus = json["tips_status"].stringValue
        tripDuration = json["trip_duration"].stringValue
        cargoWeightKg = json["cargo_weight_kg"].stringValue
        truckLoadType = json["truck_load_type"].stringValue
        estimatedTime = json["estimated_time"].stringValue
        let vehicleTypeJson = json["vehicle_type"]
        if !vehicleTypeJson.isEmpty{
            vehicleType = VehicleTypeBookingAcceptedeData(fromJson: vehicleTypeJson)
        }
        vehicleTypeId = json["vehicle_type_id"].stringValue
        itemQuantity = json["item_quantity"].stringValue
        name = json["name"].stringValue
        waitingTime = json["waiting_time"].stringValue
        cargoImage = json["cargo_image"].arrayValue
        notes = json["notes"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if _id != nil{
        	dictionary["_id"] = id
        }
        if acceptTime != nil{
        	dictionary["accept_time"] = acceptTime
        }
        if arrivedTime != nil{
        	dictionary["arrived_time"] = arrivedTime
        }
        if baseFare != nil{
        	dictionary["base_fare"] = baseFare
        }
        if bookingFee != nil{
        	dictionary["booking_fee"] = bookingFee
        }
        if bookingTime != nil{
        	dictionary["booking_time"] = bookingTime
        }
        if bookingType != nil{
        	dictionary["booking_type"] = bookingType
        }
        if cancelBy != nil{
        	dictionary["cancel_by"] = cancelBy
        }
        if cancellationCharge != nil{
        	dictionary["cancellation_charge"] = cancellationCharge
        }
        if cardId != nil{
        	dictionary["card_id"] = cardId
        }
        if companyAmount != nil{
        	dictionary["company_amount"] = companyAmount
        }
        if customerId != nil{
        	dictionary["customer_id"] = customerId
        }
        if customerInfo != nil{
            dictionary["customerInfo"] = customerInfo?.toDictionary()
        }
        if discount != nil{
        	dictionary["discount"] = discount
        }
        if distance != nil{
        	dictionary["distance"] = distance
        }
        if distanceFare != nil{
        	dictionary["distance_fare"] = distanceFare
        }
        if driverAmount != nil{
        	dictionary["driver_amount"] = driverAmount
        }
        if driverId != nil{
        	dictionary["driver_id"] = driverId
        }
        if dropoffLat != nil{
        	dictionary["dropoff_lat"] = dropoffLat
        }
        if dropoffLng != nil{
        	dictionary["dropoff_lng"] = dropoffLng
        }
        if dropoffLocation != nil{
        	dictionary["dropoff_location"] = dropoffLocation
        }
        if dropoffTime != nil{
        	dictionary["dropoff_time"] = dropoffTime
        }
        if durationFare != nil{
        	dictionary["duration_fare"] = durationFare
        }
        if estimatedFare != nil{
        	dictionary["estimated_fare"] = estimatedFare
        }
        if extraCharge != nil{
        	dictionary["extra_charge"] = extraCharge
        }
        if grandTotal != nil{
        	dictionary["grand_total"] = grandTotal
        }
        if id != nil{
        	dictionary["id"] = id
        }
        if noOfPassenger != nil{
        	dictionary["no_of_passenger"] = noOfPassenger
        }
        if onTheWay != nil{
        	dictionary["on_the_way"] = onTheWay
        }
        if paymentStatus != nil{
        	dictionary["payment_status"] = paymentStatus
        }
        if paymentType != nil{
        	dictionary["payment_type"] = paymentType
        }
        if pickupDateTime != nil{
        	dictionary["pickup_date_time"] = pickupDateTime
        }
        if pickupLat != nil{
        	dictionary["pickup_lat"] = pickupLat
        }
        if pickupLng != nil{
        	dictionary["pickup_lng"] = pickupLng
        }
        if pickupLocation != nil{
        	dictionary["pickup_location"] = pickupLocation
        }
        if pickupTime != nil{
        	dictionary["pickup_time"] = pickupTime
        }
        if promocode != nil{
        	dictionary["promocode"] = promocode
        }
        if referenceId != nil{
        	dictionary["reference_id"] = referenceId
        }
        if status != nil{
        	dictionary["status"] = status
        }
        if subTotal != nil{
        	dictionary["sub_total"] = subTotal
        }
        if tax != nil{
        	dictionary["tax"] = tax
        }
        if tips != nil{
        	dictionary["tips"] = tips
        }
        if tipsStatus != nil{
        	dictionary["tips_status"] = tipsStatus
        }
        if tripDuration != nil{
        	dictionary["trip_duration"] = tripDuration
        }
        if vehicleType != nil{
        	dictionary["vehicleType"] = vehicleType.toDictionary()
        }
        if vehicleTypeId != nil{
        	dictionary["vehicle_type_id"] = vehicleTypeId
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
    
		_id = aDecoder.decodeObject(forKey: "_id") as? String
		acceptTime = aDecoder.decodeObject(forKey: "accept_time") as? String
		arrivedTime = aDecoder.decodeObject(forKey: "arrived_time") as? String
		baseFare = aDecoder.decodeObject(forKey: "base_fare") as? String
		bookingFee = aDecoder.decodeObject(forKey: "booking_fee") as? String
		bookingTime = aDecoder.decodeObject(forKey: "booking_time") as? String
		bookingType = aDecoder.decodeObject(forKey: "booking_type") as? String
		cancelBy = aDecoder.decodeObject(forKey: "cancel_by") as? String
		cancellationCharge = aDecoder.decodeObject(forKey: "cancellation_charge") as? String
		cardId = aDecoder.decodeObject(forKey: "card_id") as? String
		companyAmount = aDecoder.decodeObject(forKey: "company_amount") as? String
		customerId = aDecoder.decodeObject(forKey: "customer_id") as? String
		customerInfo = aDecoder.decodeObject(forKey: "customer_info") as? CustomerInfo
		discount = aDecoder.decodeObject(forKey: "discount") as? String
		distance = aDecoder.decodeObject(forKey: "distance") as? String
		distanceFare = aDecoder.decodeObject(forKey: "distance_fare") as? String
		driverAmount = aDecoder.decodeObject(forKey: "driver_amount") as? String
		driverId = aDecoder.decodeObject(forKey: "driver_id") as? String
		dropoffLat = aDecoder.decodeObject(forKey: "dropoff_lat") as? String
		dropoffLng = aDecoder.decodeObject(forKey: "dropoff_lng") as? String
		dropoffLocation = aDecoder.decodeObject(forKey: "dropoff_location") as? String
		dropoffTime = aDecoder.decodeObject(forKey: "dropoff_time") as? String
		durationFare = aDecoder.decodeObject(forKey: "duration_fare") as? String
		estimatedFare = aDecoder.decodeObject(forKey: "estimated_fare") as? String
		extraCharge = aDecoder.decodeObject(forKey: "extra_charge") as? String
		grandTotal = aDecoder.decodeObject(forKey: "grand_total") as? String
		id = aDecoder.decodeObject(forKey: "id") as? String
		noOfPassenger = aDecoder.decodeObject(forKey: "no_of_passenger") as? String
		onTheWay = aDecoder.decodeObject(forKey: "on_the_way") as? String
		paymentStatus = aDecoder.decodeObject(forKey: "payment_status") as? String
		paymentType = aDecoder.decodeObject(forKey: "payment_type") as? String
		pickupDateTime = aDecoder.decodeObject(forKey: "pickup_date_time") as? String
		pickupLat = aDecoder.decodeObject(forKey: "pickup_lat") as? String
		pickupLng = aDecoder.decodeObject(forKey: "pickup_lng") as? String
		pickupLocation = aDecoder.decodeObject(forKey: "pickup_location") as? String
		pickupTime = aDecoder.decodeObject(forKey: "pickup_time") as? String
		promocode = aDecoder.decodeObject(forKey: "promocode") as? String
		referenceId = aDecoder.decodeObject(forKey: "reference_id") as? String
		status = aDecoder.decodeObject(forKey: "status") as? String
		subTotal = aDecoder.decodeObject(forKey: "sub_total") as? String
		tax = aDecoder.decodeObject(forKey: "tax") as? String
		tips = aDecoder.decodeObject(forKey: "tips") as? String
		tipsStatus = aDecoder.decodeObject(forKey: "tips_status") as? String
		tripDuration = aDecoder.decodeObject(forKey: "trip_duration") as? String
		vehicleType = aDecoder.decodeObject(forKey: "vehicle_type") as? VehicleTypeBookingAcceptedeData
		vehicleTypeId = aDecoder.decodeObject(forKey: "vehicle_type_id") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder) {
		if _id != nil{
			aCoder.encode(id, forKey: "_id")
		}
		if acceptTime != nil{
			aCoder.encode(acceptTime, forKey: "accept_time")
		}
		if arrivedTime != nil{
			aCoder.encode(arrivedTime, forKey: "arrived_time")
		}
		if baseFare != nil{
			aCoder.encode(baseFare, forKey: "base_fare")
		}
		if bookingFee != nil{
			aCoder.encode(bookingFee, forKey: "booking_fee")
		}
		if bookingTime != nil{
			aCoder.encode(bookingTime, forKey: "booking_time")
		}
		if bookingType != nil{
			aCoder.encode(bookingType, forKey: "booking_type")
		}
		if cancelBy != nil{
			aCoder.encode(cancelBy, forKey: "cancel_by")
		}
		if cancellationCharge != nil{
			aCoder.encode(cancellationCharge, forKey: "cancellation_charge")
		}
		if cardId != nil{
			aCoder.encode(cardId, forKey: "card_id")
		}
		if companyAmount != nil{
			aCoder.encode(companyAmount, forKey: "company_amount")
		}
		if customerId != nil{
			aCoder.encode(customerId, forKey: "customer_id")
		}
		if customerInfo != nil{
			aCoder.encode(customerInfo, forKey: "customer_info")
		}
		if discount != nil{
			aCoder.encode(discount, forKey: "discount")
		}
		if distance != nil{
			aCoder.encode(distance, forKey: "distance")
		}
		if distanceFare != nil{
			aCoder.encode(distanceFare, forKey: "distance_fare")
		}
		if driverAmount != nil{
			aCoder.encode(driverAmount, forKey: "driver_amount")
		}
		if driverId != nil{
			aCoder.encode(driverId, forKey: "driver_id")
		}
		if dropoffLat != nil{
			aCoder.encode(dropoffLat, forKey: "dropoff_lat")
		}
		if dropoffLng != nil{
			aCoder.encode(dropoffLng, forKey: "dropoff_lng")
		}
		if dropoffLocation != nil{
			aCoder.encode(dropoffLocation, forKey: "dropoff_location")
		}
		if dropoffTime != nil{
			aCoder.encode(dropoffTime, forKey: "dropoff_time")
		}
		if durationFare != nil{
			aCoder.encode(durationFare, forKey: "duration_fare")
		}
		if estimatedFare != nil{
			aCoder.encode(estimatedFare, forKey: "estimated_fare")
		}
		if extraCharge != nil{
			aCoder.encode(extraCharge, forKey: "extra_charge")
		}
		if grandTotal != nil{
			aCoder.encode(grandTotal, forKey: "grand_total")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if noOfPassenger != nil{
			aCoder.encode(noOfPassenger, forKey: "no_of_passenger")
		}
		if onTheWay != nil{
			aCoder.encode(onTheWay, forKey: "on_the_way")
		}
		if paymentStatus != nil{
			aCoder.encode(paymentStatus, forKey: "payment_status")
		}
		if paymentType != nil{
			aCoder.encode(paymentType, forKey: "payment_type")
		}
		if pickupDateTime != nil{
			aCoder.encode(pickupDateTime, forKey: "pickup_date_time")
		}
		if pickupLat != nil{
			aCoder.encode(pickupLat, forKey: "pickup_lat")
		}
		if pickupLng != nil{
			aCoder.encode(pickupLng, forKey: "pickup_lng")
		}
		if pickupLocation != nil{
			aCoder.encode(pickupLocation, forKey: "pickup_location")
		}
		if pickupTime != nil{
			aCoder.encode(pickupTime, forKey: "pickup_time")
		}
		if promocode != nil{
			aCoder.encode(promocode, forKey: "promocode")
		}
		if referenceId != nil{
			aCoder.encode(referenceId, forKey: "reference_id")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if subTotal != nil{
			aCoder.encode(subTotal, forKey: "sub_total")
		}
		if tax != nil{
			aCoder.encode(tax, forKey: "tax")
		}
		if tips != nil{
			aCoder.encode(tips, forKey: "tips")
		}
		if tipsStatus != nil{
			aCoder.encode(tipsStatus, forKey: "tips_status")
		}
		if tripDuration != nil{
			aCoder.encode(tripDuration, forKey: "trip_duration")
		}
		if vehicleType != nil{
			aCoder.encode(vehicleType, forKey: "vehicle_type")
		}
		if vehicleTypeId != nil{
			aCoder.encode(vehicleTypeId, forKey: "vehicle_type_id")
		}

	}

}

enum TripStatusEnum: String {
    case pending
    case accepted
    case traveling
    case completed
}
