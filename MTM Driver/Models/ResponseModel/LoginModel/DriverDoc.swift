//
//  DriverDoc.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on July 23, 2019

import Foundation
import SwiftyJSON

class DriverDoc: Codable {
    
    let id: String
    let driver_id: String
    
    let national_id_image: String
    let national_id_number: String
    
    let driver_licence_image: String
    let driver_licence_exp_date: String
    
    let driver_psv_license: String
    let driver_psv_license_exp_date: String
    
    let police_clearance_certi: String
    
    let vehicle_psv_license: String
    let vehicle_psv_license_exp_date: String
    
    let vehicle_log_book_image: String
    
    let ntsa_inspection_image: String
    let ntsa_exp_date: String
    
    let psv_comprehensive_insurance: String
    let psv_comprehensive_insurance_exp_date: String

    init?(fromJson json: JSON){
        if json.isEmpty {
            return nil
        }
        id = json["id"].stringValue
        driver_id = json["driver_id"].stringValue
        national_id_image = json["national_id_image"].stringValue
        national_id_number = json["national_id_number"].stringValue
        driver_licence_image = json["driver_licence_image"].stringValue
        driver_licence_exp_date = json["driver_licence_exp_date"].stringValue
        driver_psv_license = json["driver_psv_license"].stringValue
        driver_psv_license_exp_date = json["driver_psv_license_exp_date"].stringValue
        police_clearance_certi = json["police_clearance_certi"].stringValue
        vehicle_psv_license = json["vehicle_psv_license"].stringValue
        vehicle_psv_license_exp_date = json["vehicle_psv_license_exp_date"].stringValue
        vehicle_log_book_image = json["vehicle_log_book_image"].stringValue
        ntsa_inspection_image = json["ntsa_inspection_image"].stringValue
        ntsa_exp_date = json["ntsa_exp_date"].stringValue
        psv_comprehensive_insurance = json["psv_comprehensive_insurance"].stringValue
        psv_comprehensive_insurance_exp_date = json["psv_comprehensive_insurance_exp_date"].stringValue
    }


}
