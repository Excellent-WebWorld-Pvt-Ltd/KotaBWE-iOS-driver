//
//  EarningResponceModel.swift
//  MTM Driver
//
//  Created by Dhananjay  on 24/02/23.
//  Copyright © 2023 baps. All rights reserved.
//
import SwiftyJSON
import Foundation

class EarningSettlementResponseModel : NSObject, NSCoding{

    var earnings : [EarningData]!
    var status : Bool!
    var totalPrice : String!
    var isRequested : String!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        earnings = [EarningData]()
        let earningsArray = json["earning_history"].arrayValue
        for earningsJson in earningsArray{
            let value = EarningData(fromJson: earningsJson)
            earnings.append(value)
        }
        status = json["status"].boolValue
        totalPrice = json["total_price"].stringValue
        isRequested = json["is_requested"].stringValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]{
        var dictionary = [String:Any]()
        if earnings != nil{
        var dictionaryElements = [[String:Any]]()
        for earningsElement in earnings {
            dictionaryElements.append(earningsElement.toDictionary())
        }
        dictionary["earnings"] = dictionaryElements
        }
       
        if status != nil{
            dictionary["status"] = status
        }
       
        if totalPrice != nil{
            dictionary["total_price"] = totalPrice
        }
        if isRequested != nil{
            dictionary["is_requested"] = totalPrice
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
        earnings = aDecoder.decodeObject(forKey: "earnings") as? [EarningData]
        status = aDecoder.decodeObject(forKey: "status") as? Bool
        totalPrice = aDecoder.decodeObject(forKey: "total_price") as? String
        isRequested = aDecoder.decodeObject(forKey: "is_requested") as? String
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
       
        if earnings != nil{
            aCoder.encode(earnings, forKey: "earnings")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        if totalPrice != nil{
            aCoder.encode(totalPrice, forKey: "total_price")
        }
        if isRequested != nil{
            aCoder.encode(totalPrice, forKey: "is_requested")
        }
    }

}

class EarningData : NSObject{

    var total : String!
    var lastName : String?
    var companyAmount : String?
    var driverAmount : String!
    var firstName : String!
    var fullName : String!
    var id : String!
    var createdAt : String!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        total = json["total"].stringValue
        lastName = json["last_name"].stringValue
        companyAmount = json["driver_amount"].stringValue
        driverAmount = json["driver_amount"].stringValue
        id = json["id"].stringValue
        firstName = json["first_name"].stringValue
        createdAt = json["created_at"].stringValue
        fullName = json["full_name"].stringValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]{
        var dictionary = [String:Any]()
        if total != nil{
            dictionary["total"] = total
        }
        if lastName != nil{
            dictionary["last_name"] = lastName
        }
        if driverAmount != nil{
            dictionary["driver_amount"] = driverAmount
        }
        if companyAmount != nil{
            dictionary["company_amount"] = companyAmount
        }
        if id != nil{
            dictionary["id"] = id
        }
        if firstName != nil{
            dictionary["first_name"] = firstName
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if fullName != nil{
            dictionary["full_name"] = fullName
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
        total = aDecoder.decodeObject(forKey: "total") as? String
        lastName = aDecoder.decodeObject(forKey: "last_name") as? String
        driverAmount = aDecoder.decodeObject(forKey: "driver_amount") as? String
        companyAmount = aDecoder.decodeObject(forKey: "company_amount") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        firstName = aDecoder.decodeObject(forKey: "first_name") as? String
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        fullName = aDecoder.decodeObject(forKey: "full_name") as? String
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if total != nil{
            aCoder.encode(total, forKey: "total")
        }
        if lastName != nil{
            aCoder.encode(lastName, forKey: "last_name")
        }
        if driverAmount != nil{
            aCoder.encode(driverAmount, forKey: "driver_amount")
        }
        if companyAmount != nil{
            aCoder.encode(companyAmount, forKey: "company_amount")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if firstName != nil{
            aCoder.encode(firstName, forKey: "first_name")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if fullName != nil{
            aCoder.encode(fullName, forKey: "full_name")
        }

    }

}
