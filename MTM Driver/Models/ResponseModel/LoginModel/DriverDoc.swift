//
//  DriverDoc.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on July 23, 2019

import Foundation
import SwiftyJSON

class DriverDoc: Codable {
    
    let id: String
    let driver_id: String
    
    let driver_licence_image_front : String
    let driver_licence_image_back : String
    let driver_licence_exp_date : String
    
    let criminal_record_image : String
    let residence_certificate : String
    let rental_license_image : String
    let rental_license_exp_date : String
    let booklet_image : String
    let civil_liability_insurance_image : String
    let civil_liability_insurance_exp_date : String
    let bi_image_front : String
    let bi_image_back : String
    let bi_exp_date : String

    init?(fromJson json: JSON){
        if json.isEmpty {
            return nil
        }
        id = json["id"].stringValue
        driver_id = json["driver_id"].stringValue
        driver_licence_image_front = json["driver_licence_image"].stringValue
        driver_licence_image_back = json["driver_licence_image_back"].stringValue
        driver_licence_exp_date = json["driver_licence_exp_date"].stringValue
        criminal_record_image = json["criminal_record_image"].stringValue
        residence_certificate = json["residence_certificate"].stringValue
        rental_license_image = json["rental_license_image"].stringValue
        rental_license_exp_date = json["rental_license_exp_date"].stringValue
        booklet_image = json["booklet_image"].stringValue
        civil_liability_insurance_image = json["civil_liability_insurance_image"].stringValue
        civil_liability_insurance_exp_date = json["civil_liability_insurance_exp_date"].stringValue
        bi_image_front = json["bi_image_front"].stringValue
        bi_image_back = json["bi_image_back"].stringValue
        bi_exp_date = json["bi_exp_date"].stringValue
    }


}
