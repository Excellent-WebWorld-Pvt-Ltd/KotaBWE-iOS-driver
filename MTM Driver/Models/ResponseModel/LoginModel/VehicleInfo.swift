//
//  VehicleInfo.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on July 23, 2019

import Foundation
import SwiftyJSON


class VehicleInfo: Codable {
    var carBack : String!
    var carFront : String!
    var carLeft : String!
    var carRight : String!
    var companyId : String!
    var driverId : String!
    var id : String!
    var noOfPassenger : String!
    var plateNumber : String!
    var vehicleColor: String?
//    var vehicleModel : String!
    var vehicleType : String!
    var vehicleTypeName : String!
    var yearOfManufacture : String!
    var vehicleTypeManufacturerName : String!
    var vehicleTypeManufacturerId : String!
    var vehicleTypeModelId : String!
    var vehicleTypeModelName : String!
    
    
    init() {
    }
    
	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        carBack = json["car_back"].stringValue
        carFront = json["car_front"].stringValue
        carLeft = json["car_left"].stringValue
        carRight = json["car_right"].stringValue
        companyId = json["company_id"].stringValue
        driverId = json["driver_id"].stringValue
        vehicleColor = json["vehicle_color"].stringValue
        id = json["id"].stringValue
        noOfPassenger = json["no_of_passenger"].stringValue
        plateNumber = json["plate_number"].stringValue
        vehicleColor = json["vehicle_color"].stringValue
//        vehicleModel = json["vehicle_model"].stringValue
        vehicleType = json["vehicle_type"].stringValue
        vehicleTypeName = json["vehicle_type_name"].stringValue
        yearOfManufacture = json["year_of_manufacture"].stringValue
        
        vehicleTypeManufacturerName = json["vehicle_type_manufacturer_name"].stringValue
        vehicleTypeManufacturerId = json["vehicle_type_model_id"].stringValue
        vehicleTypeModelId = json["vehicle_type_manufacturer_id"].stringValue
        vehicleTypeModelName = json["vehicle_type_model_name"].stringValue
	}

}
