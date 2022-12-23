//
//  TicketListingModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on January 22, 2020

import Foundation
import SwiftyJSON


class TicketListingModel : NSObject, NSCoding{

    var message : String!
    var status : Bool!
    var tickets : [Ticket]!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        message = json["message"].stringValue
        status = json["status"].boolValue
        tickets = [Ticket]()
        let ticketsArray = json["tickets"].arrayValue
        for ticketsJson in ticketsArray{
            let value = Ticket(fromJson: ticketsJson)
            tickets.append(value)
        }
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if message != nil{
        	dictionary["message"] = message
        }
        if status != nil{
        	dictionary["status"] = status
        }
        if tickets != nil{
        var dictionaryElements = [[String:Any]]()
        for ticketsElement in tickets {
        	dictionaryElements.append(ticketsElement.toDictionary())
        }
        dictionary["tickets"] = dictionaryElements
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		message = aDecoder.decodeObject(forKey: "message") as? String
		status = aDecoder.decodeObject(forKey: "status") as? Bool
		tickets = aDecoder.decodeObject(forKey: "tickets") as? [Ticket]
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if message != nil{
			aCoder.encode(message, forKey: "message")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if tickets != nil{
			aCoder.encode(tickets, forKey: "tickets")
		}

	}

}
