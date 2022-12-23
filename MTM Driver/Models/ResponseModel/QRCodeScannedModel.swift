//
//  QRCodeScannedModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on July 19, 2019

import Foundation
import SwiftyJSON


class QRCodeScannedModel : Codable
{

    var data : QRData!
    var status : Bool!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        let dataJson = json["data"]
        if !dataJson.isEmpty{
            data = QRData(fromJson: dataJson)
        }
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
        	dictionary["data"] = data.toDictionary()
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
		data = aDecoder.decodeObject(forKey: "data") as? QRData
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
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}

	}

}
class QRData : Codable
{
    
    var firstName : String!
    var id : String!
    var lastName : String!
    var mobileNo : String!
    var qrcode : String!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        firstName = json["first_name"].stringValue
        id = json["id"].stringValue
        lastName = json["last_name"].stringValue
        mobileNo = json["mobile_no"].stringValue
        qrcode = json["qrcode"].stringValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if firstName != nil{
            dictionary["first_name"] = firstName
        }
        if id != nil{
            dictionary["id"] = id
        }
        if lastName != nil{
            dictionary["last_name"] = lastName
        }
        if mobileNo != nil{
            dictionary["mobile_no"] = mobileNo
        }
        if qrcode != nil{
            dictionary["qrcode"] = qrcode
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        firstName = aDecoder.decodeObject(forKey: "first_name") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        lastName = aDecoder.decodeObject(forKey: "last_name") as? String
        mobileNo = aDecoder.decodeObject(forKey: "mobile_no") as? String
        qrcode = aDecoder.decodeObject(forKey: "qrcode") as? String
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if firstName != nil{
            aCoder.encode(firstName, forKey: "first_name")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if lastName != nil{
            aCoder.encode(lastName, forKey: "last_name")
        }
        if mobileNo != nil{
            aCoder.encode(mobileNo, forKey: "mobile_no")
        }
        if qrcode != nil{
            aCoder.encode(qrcode, forKey: "qrcode")
        }
        
    }
    
}
