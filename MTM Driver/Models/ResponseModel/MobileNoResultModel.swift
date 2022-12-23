//
//  MobileNoResultModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on July 19, 2019

import Foundation
import SwiftyJSON


class MobileNoResultModel : Codable
{

//    var data : MobilenoData!
    var walletBalance : String!
    var message : String!
    
    
    var status : Bool!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
//        let dataJson = json["data"]
//        if !dataJson.isEmpty{
//            data = MobilenoData(fromJson: dataJson)
//        }
        status = json["status"].boolValue
        walletBalance = json["wallet_balance"].stringValue
        message = json["message"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
//        if data != nil{
//            dictionary["data"] = data.toDictionary()
//        }
        if status != nil{
        	dictionary["status"] = status
        }
        if walletBalance != nil{
            dictionary["wallet_balance"] = walletBalance
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
//        data = aDecoder.decodeObject(forKey: "data") as? MobilenoData
		status = aDecoder.decodeObject(forKey: "status") as? Bool
        walletBalance = aDecoder.decodeObject(forKey: "wallet_balance") as? String
        message = aDecoder.decodeObject(forKey: "message") as? String
        
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
//        if data != nil{
//            aCoder.encode(data, forKey: "data")
//        }
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
        if walletBalance != nil{
            aCoder.encode(status, forKey: "wallet_balance")
        }
        if message != nil{
            aCoder.encode(message, forKey: "message")
        }
	}

}
//class MobilenoData : Codable
//{
//    
//    var walletBalance : String!
//    var status : String!
//    var message : String!
//    
// 
//    /**
//     * Instantiate the instance using the passed json values to set the properties values
//     */
//    init(fromJson json: JSON!){
//        if json.isEmpty{
//            return
//        }
//        walletBalance = json["wallet_balance"].stringValue
//        status = json["status"].stringValue
//        message = json["message"].stringValue
//    }
//    
//    /**
//     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
//     */
//    func toDictionary() -> [String:Any]
//    {
//        var dictionary = [String:Any]()
//        if walletBalance != nil{
//            dictionary["wallet_balance"] = walletBalance
//        }
//        if status != nil{
//            dictionary["status"] = status
//        }
//        if message != nil{
//            dictionary["message"] = message
//        }
//      
//        return dictionary
//    }
//    
//    /**
//     * NSCoding required initializer.
//     * Fills the data from the passed decoder
//     */
//    @objc required init(coder aDecoder: NSCoder)
//    {
//        walletBalance = aDecoder.decodeObject(forKey: "wallet_balance") as? String
//        status = aDecoder.decodeObject(forKey: "status") as? String
//        message = aDecoder.decodeObject(forKey: "message") as? String
//        
//    }
//    
//    /**
//     * NSCoding required method.
//     * Encodes mode properties into the decoder
//     */
//    func encode(with aCoder: NSCoder)
//    {
//        if walletBalance != nil{
//            aCoder.encode(walletBalance, forKey: "wallet_balance")
//        }
//        if status != nil{
//            aCoder.encode(status, forKey: "status")
//        }
//        if message != nil{
//            aCoder.encode(message, forKey: "message")
//        }
//      
//        
//    }
//    
//}
