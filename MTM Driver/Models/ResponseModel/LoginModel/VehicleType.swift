//
//  VehicleType.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on July 23, 2019

import Foundation
import SwiftyJSON


class VehicleType : Codable {

    var baseCharge : String!
    var baseKm : String!
    var bookingFee : String!
    var capacity : String!
    var commission : String!
    var createdAt : String!
    var customerCancellationFee : String!
    var descriptionField : String!
    var driverCancellationFee : String!
    var extraCharge : String!
    var id : String!
    var image : String!
    var name : String!
    var perKmCharge : String!
    var perMinuteCharge : String!
    var sort : String!
    var status : String!
    var trash : String!
    var unselectImage : String!
    var updatedAt : String!

    init() {
    }
    
	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        baseCharge = json["base_charge"].stringValue
        baseKm = json["base_km"].stringValue
        bookingFee = json["booking_fee"].stringValue
        capacity = json["capacity"].stringValue
        commission = json["commission"].stringValue
        createdAt = json["created_at"].stringValue
        customerCancellationFee = json["customer_cancellation_fee"].stringValue
        descriptionField = json["description"].stringValue
        driverCancellationFee = json["driver_cancellation_fee"].stringValue
        extraCharge = json["extra_charge"].stringValue
        id = json["id"].stringValue
        image = json["image"].stringValue
        name = json["name"].stringValue
        perKmCharge = json["per_km_charge"].stringValue
        perMinuteCharge = json["per_minute_charge"].stringValue
        sort = json["sort"].stringValue
        status = json["status"].stringValue
        trash = json["trash"].stringValue
        unselectImage = json["unselect_image"].stringValue
        updatedAt = json["updated_at"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if baseCharge != nil{
        	dictionary["base_charge"] = baseCharge
        }
        if baseKm != nil{
        	dictionary["base_km"] = baseKm
        }
        if bookingFee != nil{
        	dictionary["booking_fee"] = bookingFee
        }
        if capacity != nil{
        	dictionary["capacity"] = capacity
        }
        if commission != nil{
        	dictionary["commission"] = commission
        }
        if createdAt != nil{
        	dictionary["created_at"] = createdAt
        }
        if customerCancellationFee != nil{
        	dictionary["customer_cancellation_fee"] = customerCancellationFee
        }
        if descriptionField != nil{
        	dictionary["description"] = descriptionField
        }
        if driverCancellationFee != nil{
        	dictionary["driver_cancellation_fee"] = driverCancellationFee
        }
        if extraCharge != nil{
        	dictionary["extra_charge"] = extraCharge
        }
        if id != nil{
        	dictionary["id"] = id
        }
        if image != nil{
        	dictionary["image"] = image
        }
        if name != nil{
        	dictionary["name"] = name
        }
        if perKmCharge != nil{
        	dictionary["per_km_charge"] = perKmCharge
        }
        if perMinuteCharge != nil{
        	dictionary["per_minute_charge"] = perMinuteCharge
        }
        if sort != nil{
        	dictionary["sort"] = sort
        }
        if status != nil{
        	dictionary["status"] = status
        }
        if trash != nil{
        	dictionary["trash"] = trash
        }
        if unselectImage != nil{
        	dictionary["unselect_image"] = unselectImage
        }
        if updatedAt != nil{
        	dictionary["updated_at"] = updatedAt
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		baseCharge = aDecoder.decodeObject(forKey: "base_charge") as? String
		baseKm = aDecoder.decodeObject(forKey: "base_km") as? String
		bookingFee = aDecoder.decodeObject(forKey: "booking_fee") as? String
		capacity = aDecoder.decodeObject(forKey: "capacity") as? String
		commission = aDecoder.decodeObject(forKey: "commission") as? String
		createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
		customerCancellationFee = aDecoder.decodeObject(forKey: "customer_cancellation_fee") as? String
		descriptionField = aDecoder.decodeObject(forKey: "description") as? String
		driverCancellationFee = aDecoder.decodeObject(forKey: "driver_cancellation_fee") as? String
		extraCharge = aDecoder.decodeObject(forKey: "extra_charge") as? String
		id = aDecoder.decodeObject(forKey: "id") as? String
		image = aDecoder.decodeObject(forKey: "image") as? String
		name = aDecoder.decodeObject(forKey: "name") as? String
		perKmCharge = aDecoder.decodeObject(forKey: "per_km_charge") as? String
		perMinuteCharge = aDecoder.decodeObject(forKey: "per_minute_charge") as? String
		sort = aDecoder.decodeObject(forKey: "sort") as? String
		status = aDecoder.decodeObject(forKey: "status") as? String
		trash = aDecoder.decodeObject(forKey: "trash") as? String
		unselectImage = aDecoder.decodeObject(forKey: "unselect_image") as? String
		updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if baseCharge != nil{
			aCoder.encode(baseCharge, forKey: "base_charge")
		}
		if baseKm != nil{
			aCoder.encode(baseKm, forKey: "base_km")
		}
		if bookingFee != nil{
			aCoder.encode(bookingFee, forKey: "booking_fee")
		}
		if capacity != nil{
			aCoder.encode(capacity, forKey: "capacity")
		}
		if commission != nil{
			aCoder.encode(commission, forKey: "commission")
		}
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if customerCancellationFee != nil{
			aCoder.encode(customerCancellationFee, forKey: "customer_cancellation_fee")
		}
		if descriptionField != nil{
			aCoder.encode(descriptionField, forKey: "description")
		}
		if driverCancellationFee != nil{
			aCoder.encode(driverCancellationFee, forKey: "driver_cancellation_fee")
		}
		if extraCharge != nil{
			aCoder.encode(extraCharge, forKey: "extra_charge")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if image != nil{
			aCoder.encode(image, forKey: "image")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if perKmCharge != nil{
			aCoder.encode(perKmCharge, forKey: "per_km_charge")
		}
		if perMinuteCharge != nil{
			aCoder.encode(perMinuteCharge, forKey: "per_minute_charge")
		}
		if sort != nil{
			aCoder.encode(sort, forKey: "sort")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if trash != nil{
			aCoder.encode(trash, forKey: "trash")
		}
		if unselectImage != nil{
			aCoder.encode(unselectImage, forKey: "unselect_image")
		}
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: "updated_at")
		}

	}

}
