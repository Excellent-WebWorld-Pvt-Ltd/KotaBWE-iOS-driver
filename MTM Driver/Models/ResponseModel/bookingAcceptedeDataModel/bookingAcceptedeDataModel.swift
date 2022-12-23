//
//  bookingAcceptedeDataModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 2, 2019

import Foundation
import SwiftyJSON


class bookingAcceptedeDataModel : NSObject, NSCoding{

    var bookingInfo : BookingInfo!
    var message : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        let bookingInfoJson = json["booking_info"]
        if !bookingInfoJson.isEmpty{
            bookingInfo = BookingInfo(fromJson: bookingInfoJson)
        }
        message = json["message"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if bookingInfo != nil{
        	dictionary["bookingInfo"] = bookingInfo.toDictionary()
        }
        if message != nil{
        	dictionary["message"] = message
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		bookingInfo = aDecoder.decodeObject(forKey: "booking_info") as? BookingInfo
		message = aDecoder.decodeObject(forKey: "message") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if bookingInfo != nil{
			aCoder.encode(bookingInfo, forKey: "booking_info")
		}
		if message != nil{
			aCoder.encode(message, forKey: "message")
		}

	}

}
