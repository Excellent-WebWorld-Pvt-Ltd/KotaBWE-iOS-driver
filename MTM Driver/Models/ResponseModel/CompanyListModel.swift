//
//  CompanyListModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 6, 2019

import Foundation
import SwiftyJSON


class CompanyListModel : Codable{

    var data : [comapanyData]!
    var message : String!
    var status : Bool!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        data = [comapanyData]()
        let dataArray = json["data"].arrayValue
        for dataJson in dataArray{
            let value = comapanyData(fromJson: dataJson)
            data.append(value)
        }
        message = json["message"].stringValue
        status = json["status"].boolValue
	}

    init() {
        
    }
	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if data != nil{
        var dictionaryElements = [[String:Any]]()
        for dataElement in data {
        	dictionaryElements.append(dataElement.toDictionary())
        }
        dictionary["data"] = dictionaryElements
        }
        if message != nil{
        	dictionary["message"] = message
        }
        if status != nil{
        	dictionary["status"] = status
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		data = aDecoder.decodeObject(forKey: "data") as? [comapanyData]
		message = aDecoder.decodeObject(forKey: "message") as? String
		status = aDecoder.decodeObject(forKey: "status") as? Bool
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if data != nil{
			aCoder.encode(data, forKey: "data")
		}
		if message != nil{
			aCoder.encode(message, forKey: "message")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}

	}

}
class comapanyData : Codable
{
    
    var address : String!
    var companyName : String!
    var contactPersonMobileNo : String!
    var contactPersonName : String!
    var createdAt : String!
    var id : String!
    var lat : String!
    var lng : String!
    var status : String!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        address = json["address"].stringValue
        companyName = json["company_name"].stringValue
        contactPersonMobileNo = json["contact_person_mobile_no"].stringValue
        contactPersonName = json["contact_person_name"].stringValue
        createdAt = json["created_at"].stringValue
        id = json["id"].stringValue
        lat = json["lat"].stringValue
        lng = json["lng"].stringValue
        status = json["status"].stringValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if address != nil{
            dictionary["address"] = address
        }
        if companyName != nil{
            dictionary["company_name"] = companyName
        }
        if contactPersonMobileNo != nil{
            dictionary["contact_person_mobile_no"] = contactPersonMobileNo
        }
        if contactPersonName != nil{
            dictionary["contact_person_name"] = contactPersonName
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if id != nil{
            dictionary["id"] = id
        }
        if lat != nil{
            dictionary["lat"] = lat
        }
        if lng != nil{
            dictionary["lng"] = lng
        }
        if status != nil{
            dictionary["status"] = status
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        address = aDecoder.decodeObject(forKey: "address") as? String
        companyName = aDecoder.decodeObject(forKey: "company_name") as? String
        contactPersonMobileNo = aDecoder.decodeObject(forKey: "contact_person_mobile_no") as? String
        contactPersonName = aDecoder.decodeObject(forKey: "contact_person_name") as? String
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        lat = aDecoder.decodeObject(forKey: "lat") as? String
        lng = aDecoder.decodeObject(forKey: "lng") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if address != nil{
            aCoder.encode(address, forKey: "address")
        }
        if companyName != nil{
            aCoder.encode(companyName, forKey: "company_name")
        }
        if contactPersonMobileNo != nil{
            aCoder.encode(contactPersonMobileNo, forKey: "contact_person_mobile_no")
        }
        if contactPersonName != nil{
            aCoder.encode(contactPersonName, forKey: "contact_person_name")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if lat != nil{
            aCoder.encode(lat, forKey: "lat")
        }
        if lng != nil{
            aCoder.encode(lng, forKey: "lng")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        
    }
    
}
