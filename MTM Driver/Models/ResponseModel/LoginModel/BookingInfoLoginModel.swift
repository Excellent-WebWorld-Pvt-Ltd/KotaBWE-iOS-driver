//
//  BookingInfo.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 8, 2019

import Foundation
import SwiftyJSON


class BookingInfoLoginModel : Codable {

    var driverDuty : String!
    var totalDriverEarning : String!
    var totalTrips : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
    init() {
    }
    
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        driverDuty = json["driver_duty"].stringValue
        totalDriverEarning = json["total_driver_earning"].stringValue
        totalTrips = json["total_trips"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if driverDuty != nil{
        	dictionary["driver_duty"] = driverDuty
        }
        if totalDriverEarning != nil{
        	dictionary["total_driver_earning"] = totalDriverEarning
        }
        if totalTrips != nil{
        	dictionary["total_trips"] = totalTrips
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		driverDuty = aDecoder.decodeObject(forKey: "driver_duty") as? String
		totalDriverEarning = aDecoder.decodeObject(forKey: "total_driver_earning") as? String
		totalTrips = aDecoder.decodeObject(forKey: "total_trips") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if driverDuty != nil{
			aCoder.encode(driverDuty, forKey: "driver_duty")
		}
		if totalDriverEarning != nil{
			aCoder.encode(totalDriverEarning, forKey: "total_driver_earning")
		}
		if totalTrips != nil{
			aCoder.encode(totalTrips, forKey: "total_trips")
		}

	}

}
