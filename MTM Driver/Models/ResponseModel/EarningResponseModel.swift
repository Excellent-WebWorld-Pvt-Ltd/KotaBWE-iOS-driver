//
//  EarningResponseModel.swift
//  DSP Driver
//
//  Created by Admin on 29/11/21.
//  Copyright © 2021 baps. All rights reserved.
//

import Foundation
import SwiftyJSON


class RootEarning : NSObject, NSCoding{

    var currentDate : String!
    var earnings : [Earning]!
    var graph : Graph!
    var status : Bool!
    var totalBooking : Int!
    var totalPrice : String!
    var totalTime : Int!
    var totalTips : String!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        currentDate = json["current_date"].stringValue
        earnings = [Earning]()
        let earningsArray = json["earnings"].arrayValue
        for earningsJson in earningsArray{
            let value = Earning(fromJson: earningsJson)
            earnings.append(value)
        }
        let graphJson = json["graph"]
        if !graphJson.isEmpty{
            graph = Graph(fromJson: graphJson)
        }
        status = json["status"].boolValue
        totalBooking = json["total_booking"].intValue
        totalPrice = json["total_price"].stringValue
        totalTime = json["total_time"].intValue
        totalTips = json["total_tips"].stringValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if currentDate != nil{
            dictionary["current_date"] = currentDate
        }
        if earnings != nil{
        var dictionaryElements = [[String:Any]]()
        for earningsElement in earnings {
            dictionaryElements.append(earningsElement.toDictionary())
        }
        dictionary["earnings"] = dictionaryElements
        }
        if graph != nil{
            dictionary["graph"] = graph.toDictionary()
        }
        if status != nil{
            dictionary["status"] = status
        }
        if totalBooking != nil{
            dictionary["total_booking"] = totalBooking
        }
        if totalPrice != nil{
            dictionary["total_price"] = totalPrice
        }
        if totalTime != nil{
            dictionary["total_time"] = totalTime
        }
        if totalTips != nil{
            dictionary["total_tips"] = totalTips
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
        currentDate = aDecoder.decodeObject(forKey: "current_date") as? String
        earnings = aDecoder.decodeObject(forKey: "earnings") as? [Earning]
        graph = aDecoder.decodeObject(forKey: "graph") as? Graph
        status = aDecoder.decodeObject(forKey: "status") as? Bool
        totalBooking = aDecoder.decodeObject(forKey: "total_booking") as? Int
        totalPrice = aDecoder.decodeObject(forKey: "total_price") as? String
        totalTime = aDecoder.decodeObject(forKey: "total_time") as? Int
        totalTips = aDecoder.decodeObject(forKey: "total_tips") as? String
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if currentDate != nil{
            aCoder.encode(currentDate, forKey: "current_date")
        }
        if earnings != nil{
            aCoder.encode(earnings, forKey: "earnings")
        }
        if graph != nil{
            aCoder.encode(graph, forKey: "graph")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        if totalBooking != nil{
            aCoder.encode(totalBooking, forKey: "total_booking")
        }
        if totalPrice != nil{
            aCoder.encode(totalPrice, forKey: "total_price")
        }
        if totalTime != nil{
            aCoder.encode(totalTime, forKey: "total_time")
        }
        if totalTips != nil{
            aCoder.encode(totalTips, forKey: "total_tips")
        }

    }

}
//
//  Graph.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on November 29, 2021

import Foundation
import SwiftyJSON


class Graph : NSObject, NSCoding{

    var sun : Int!
    var tue : Int!
    var mon : Int!
    var wed : Int!
    var thu : Int!
    var fri : Int!
    var sat : Int!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        thu = json["Thu"].intValue
        
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if thu != nil{
            dictionary["Thu"] = thu
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
        thu = aDecoder.decodeObject(forKey: "Thu") as? Int
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if thu != nil{
            aCoder.encode(thu, forKey: "Thu")
        }

    }

}



class Earning : NSObject, NSCoding{

    var bookingType : String!
    var day : String!
    var driverAmount : String!
    var dropoffTime : String!
    var id : String!
    var paymentType : String!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        bookingType = json["booking_type"].stringValue
        day = json["day"].stringValue
        driverAmount = json["driver_amount"].stringValue
        dropoffTime = json["dropoff_time"].stringValue
        id = json["id"].stringValue
        paymentType = json["payment_type"].stringValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if bookingType != nil{
            dictionary["booking_type"] = bookingType
        }
        if day != nil{
            dictionary["day"] = day
        }
        if driverAmount != nil{
            dictionary["driver_amount"] = driverAmount
        }
        if dropoffTime != nil{
            dictionary["dropoff_time"] = dropoffTime
        }
        if id != nil{
            dictionary["id"] = id
        }
        if paymentType != nil{
            dictionary["payment_type"] = paymentType
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
        bookingType = aDecoder.decodeObject(forKey: "booking_type") as? String
        day = aDecoder.decodeObject(forKey: "day") as? String
        driverAmount = aDecoder.decodeObject(forKey: "driver_amount") as? String
        dropoffTime = aDecoder.decodeObject(forKey: "dropoff_time") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        paymentType = aDecoder.decodeObject(forKey: "payment_type") as? String
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if bookingType != nil{
            aCoder.encode(bookingType, forKey: "booking_type")
        }
        if day != nil{
            aCoder.encode(day, forKey: "day")
        }
        if driverAmount != nil{
            aCoder.encode(driverAmount, forKey: "driver_amount")
        }
        if dropoffTime != nil{
            aCoder.encode(dropoffTime, forKey: "dropoff_time")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if paymentType != nil{
            aCoder.encode(paymentType, forKey: "payment_type")
        }

    }

}
