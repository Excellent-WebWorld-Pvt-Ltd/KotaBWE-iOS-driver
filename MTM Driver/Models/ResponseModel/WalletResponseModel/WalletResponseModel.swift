////
////  WalletResponseModel.swift
////  Model Generated using http://www.jsoncafe.com/ 
////  Created on July 22, 2019
//
//import Foundation
//import SwiftyJSON
//
//
//class WalletResponseModel : Codable {
//
//    var data : [WalletResponseDataModel]!
//    var status : Bool!
//    var walletBalance : String!
//
//    init() {
//    }
//    
//	/**
//	 * Instantiate the instance using the passed json values to set the properties values
//	 */
//	init(fromJson json: JSON!){
//		if json.isEmpty{
//			return
//		}
//        data = [WalletResponseDataModel]()
//        let dataArray = json["data"].arrayValue
//        for dataJson in dataArray{
//            let value = WalletResponseDataModel(fromJson: dataJson)
//            data.append(value)
//        }
//        status = json["status"].boolValue
//        walletBalance = json["wallet_balance"].stringValue
//	}
//
//	/**
//	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
//	 */
//	func toDictionary() -> [String:Any]
//	{
//		var dictionary = [String:Any]()
//        if data != nil{
//            var dictionaryElements = [[String:Any]]()
//            for dataElement in data {
//                dictionaryElements.append(dataElement.toDictionary())
//            }
//            dictionary["data"] = dictionaryElements
//        }
//        if status != nil{
//        	dictionary["status"] = status
//        }
//        if walletBalance != nil{
//        	dictionary["wallet_balance"] = walletBalance
//        }
//		return dictionary
//	}
//
//    /**
//    * NSCoding required initializer.
//    * Fills the data from the passed decoder
//    */
//    @objc required init(coder aDecoder: NSCoder)
//	{
//		data = aDecoder.decodeObject(forKey: "data") as? [WalletResponseDataModel]
//		status = aDecoder.decodeObject(forKey: "status") as? Bool
//		walletBalance = aDecoder.decodeObject(forKey: "wallet_balance") as? String
//	}
//
//    /**
//    * NSCoding required method.
//    * Encodes mode properties into the decoder
//    */
//    func encode(with aCoder: NSCoder)
//	{
//		if data != nil{
//			aCoder.encode(data, forKey: "data")
//		}
//		if status != nil{
//			aCoder.encode(status, forKey: "status")
//		}
//		if walletBalance != nil{
//			aCoder.encode(walletBalance, forKey: "wallet_balance")
//		}
//
//	}
//
//}
