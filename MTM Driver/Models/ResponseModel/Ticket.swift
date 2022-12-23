//
//  Ticket.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on January 22, 2020

import Foundation
import SwiftyJSON


class Ticket : NSObject, NSCoding{

    var createdAt : String!
    var descriptionField : String!
    var id : String!
    var image : String!
    var status : String!
    var ticketId : String!
    var ticketTitle : String!
    var userId : String!
    var userType : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        createdAt = json["created_at"].stringValue
        descriptionField = json["description"].stringValue
        id = json["id"].stringValue
        image = json["image"].stringValue
        status = json["status"].stringValue
        ticketId = json["ticket_id"].stringValue
        ticketTitle = json["ticket_title"].stringValue
        userId = json["user_id"].stringValue
        userType = json["user_type"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if createdAt != nil{
        	dictionary["created_at"] = createdAt
        }
        if descriptionField != nil{
        	dictionary["description"] = descriptionField
        }
        if id != nil{
        	dictionary["id"] = id
        }
        if image != nil{
        	dictionary["image"] = image
        }
        if status != nil{
        	dictionary["status"] = status
        }
        if ticketId != nil{
        	dictionary["ticket_id"] = ticketId
        }
        if ticketTitle != nil{
        	dictionary["ticket_title"] = ticketTitle
        }
        if userId != nil{
        	dictionary["user_id"] = userId
        }
        if userType != nil{
        	dictionary["user_type"] = userType
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
		descriptionField = aDecoder.decodeObject(forKey: "description") as? String
		id = aDecoder.decodeObject(forKey: "id") as? String
		image = aDecoder.decodeObject(forKey: "image") as? String
		status = aDecoder.decodeObject(forKey: "status") as? String
		ticketId = aDecoder.decodeObject(forKey: "ticket_id") as? String
		ticketTitle = aDecoder.decodeObject(forKey: "ticket_title") as? String
		userId = aDecoder.decodeObject(forKey: "user_id") as? String
		userType = aDecoder.decodeObject(forKey: "user_type") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if descriptionField != nil{
			aCoder.encode(descriptionField, forKey: "description")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if image != nil{
			aCoder.encode(image, forKey: "image")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if ticketId != nil{
			aCoder.encode(ticketId, forKey: "ticket_id")
		}
		if ticketTitle != nil{
			aCoder.encode(ticketTitle, forKey: "ticket_title")
		}
		if userId != nil{
			aCoder.encode(userId, forKey: "user_id")
		}
		if userType != nil{
			aCoder.encode(userType, forKey: "user_type")
		}

	}

}
