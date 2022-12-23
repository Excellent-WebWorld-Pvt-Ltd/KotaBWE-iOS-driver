//
//  VehicleListModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on August 6, 2019

import Foundation
import SwiftyJSON


class VehicleListModel : Codable{
    
    var data : [VehicleData]!
    var message : String!
    var status : Bool!
    var yearList : [String]!
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        data = [VehicleData]()
        let dataArray = json["data"].arrayValue
        for dataJson in dataArray{
            let value = VehicleData(fromJson: dataJson)
            data.append(value)
        }
        message = json["message"].stringValue
        status = json["status"].boolValue
        yearList = [String]()
        let yearListArray = json["year_list"].arrayValue
        for yearListJson in yearListArray{
            yearList.append(yearListJson.stringValue)
        }
    }
    
    init()
    {
        
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
        if yearList != nil{
            dictionary["year_list"] = yearList
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        data = aDecoder.decodeObject(forKey: "data") as? [VehicleData]
        message = aDecoder.decodeObject(forKey: "message") as? String
        status = aDecoder.decodeObject(forKey: "status") as? Bool
        yearList = aDecoder.decodeObject(forKey: "year_list") as? [String]
        
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
        if yearList != nil{
            aCoder.encode(yearList, forKey: "year_list")
        }
    }
    
}
class VehicleData : Codable{
    
    var id : String!
    var manufacturerName : String!
    var status : String!
    var vehicleModel : [SubVehicleModel] = []
    
    init() {
    }
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json["id"].stringValue
        manufacturerName = json["manufacturer_name"].stringValue
        status = json["status"].stringValue
        let vehicleModelArray = json["vehicle_model"].arrayValue
        for vehicleModelJson in vehicleModelArray{
            let value = SubVehicleModel(fromJson: vehicleModelJson)
            vehicleModel.append(value)
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if id != nil{
            dictionary["id"] = id
        }
        if manufacturerName != nil{
            dictionary["manufacturer_name"] = manufacturerName
        }
        if status != nil{
            dictionary["status"] = status
        }
        var dictionaryElements = [[String:Any]]()
        for vehicleModelElement in vehicleModel {
            dictionaryElements.append(vehicleModelElement.toDictionary())
        }
        dictionary["vehicleModel"] = dictionaryElements
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        id = aDecoder.decodeObject(forKey: "id") as? String
        manufacturerName = aDecoder.decodeObject(forKey: "manufacturer_name") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
        vehicleModel = aDecoder.decodeObject(forKey: "vehicle_model") as? [SubVehicleModel] ?? []
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if manufacturerName != nil{
            aCoder.encode(manufacturerName, forKey: "manufacturer_name")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        aCoder.encode(vehicleModel, forKey: "vehicle_model")
        
    }
    
}
class SubVehicleModel : Codable
{
    
    var id : String!
    var status : String!
    var vehicleTypeId : String!
    var vehicleTypeManufacturerId : String!
    var vehicleTypeName : String!
    var vehicleTypeModelName : String!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    
    init() {
    }
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json["id"].stringValue
        status = json["status"].stringValue
        vehicleTypeId = json["vehicle_type_id"].stringValue
        vehicleTypeManufacturerId = json["vehicle_type_manufacturer_id"].stringValue
        vehicleTypeName = json["vehicle_type_name"].stringValue
        vehicleTypeModelName = json["vehicle_type_model_name"].stringValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if id != nil{
            dictionary["id"] = id
        }
        if status != nil{
            dictionary["status"] = status
        }
        if vehicleTypeId != nil{
            dictionary["vehicle_type_id"] = vehicleTypeId
        }
        if vehicleTypeManufacturerId != nil{
            dictionary["vehicle_type_manufacturer_id"] = vehicleTypeManufacturerId
        }
        if vehicleTypeName != nil{
            dictionary["vehicle_type_name"] = vehicleTypeName
        }
        if vehicleTypeModelName != nil{
            dictionary["vehicle_type_model_name"] = vehicleTypeId
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        id = aDecoder.decodeObject(forKey: "id") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
        vehicleTypeId = aDecoder.decodeObject(forKey: "vehicle_type_id") as? String
        vehicleTypeManufacturerId = aDecoder.decodeObject(forKey: "vehicle_type_manufacturer_id") as? String
        vehicleTypeName = aDecoder.decodeObject(forKey: "vehicle_type_name") as? String
        vehicleTypeModelName = aDecoder.decodeObject(forKey: "vehicle_type_model_name") as? String
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        if vehicleTypeId != nil{
            aCoder.encode(vehicleTypeId, forKey: "vehicle_type_id")
        }
        if vehicleTypeManufacturerId != nil{
            aCoder.encode(vehicleTypeManufacturerId, forKey: "vehicle_type_manufacturer_id")
        }
        if vehicleTypeName != nil{
            aCoder.encode(vehicleTypeName, forKey: "vehicle_type_name")
        }
        if vehicleTypeModelName != nil{
            aCoder.encode(vehicleTypeModelName, forKey: "vehicle_type_model_name")
        }
        
    }
    
}
