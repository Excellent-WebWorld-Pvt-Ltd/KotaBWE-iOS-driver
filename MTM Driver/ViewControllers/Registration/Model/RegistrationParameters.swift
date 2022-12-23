//
//  RegistrationParameters.swift
//  Peppea-Driver
//
//  Created by EWW-iMac Old on 20/06/19.
//  Copyright © 2019 Excellent WebWorld. All rights reserved.
//

import Foundation
import UIKit
class RegistrationImageParameter{
    
    static var shared = RegistrationImageParameter()
    var profileImage: UIImage?  = nil
    
    static func clear() {
        shared = RegistrationImageParameter()
    }
}

enum PresentRegistrationIndex: Int {
    case none
    case registration
    case profile
    case bank
    case vehicleInfo
    case vehicleDoc
}

class RegistrationParameter: RequestModel, Codable {
    
    static var shared = RegistrationParameter()
    
    static func clear() {
        shared = RegistrationParameter()
    }
    
    private override init(){}
    
    var driver_id = ""
    
    //Email
    var mobile_no = ""
    var email = ""
    var password = ""
    var referral_code = ""
    

    //UserInfo
    var driver_role = "driver"
    var dob = ""
    var car_type = ""
    var owner_name = ""
    var owner_email = ""
    var owner_mobile_no = ""
    var first_name = ""
    var last_name = ""
    var gender = ""
    var address = ""
    var payment_method = ""
    var invite_code = ""
    
    //Account Info
    var account_holder_name = ""
    var bank_name = ""
    var bank_branch = ""
    var account_number = ""
    
    //Vehicle Info
    var plate_number = ""
    var vehicle_color = ""
    var year_of_manufacture = ""
    var vehicle_model = ""
    var vehicle_type = ""
    var no_of_passenger = ""
    var work_with_other_company = ""
    var other_company_name = ""
    var company_id = ""
    
    var vehicle_type_model_name = ""
    var vehicle_type_model_id = ""
    var vehicle_type_manufacturer_name = ""
    var vehicle_type_manufacturer_id = ""
    
//    ---------------------------------------------------------------
//    For car image
//    ---------------------------------------------------------------
    var car_left = ""
    var car_right = ""
    var car_front = ""
    var car_back = ""
    
//    -----------------------------------------------------
//    for documents and expiry
//    -----------------------------------------------------
    
    var national_id_image = ""
    var national_id_number = ""
    
    var driver_licence_image = ""
    var driver_licence_exp_date = ""
    
    var driver_psv_license = ""
    var driver_psv_license_exp_date = ""
    
    var police_clearance_certi = ""
    
    var vehicle_psv_license = ""
    var vehicle_psv_license_exp_date = ""
    
    var vehicle_log_book_image = ""
    
    var ntsa_inspection_image = ""
    var ntsa_exp_date = ""
    
    var psv_comprehensive_insurance = ""
    var psv_comprehensive_insurance_exp_date = ""
    
    
    //Extra
    
    var lat = ""
    var lng = ""
    var device_type = "ios"
    var device_token = ""
    
    // Storing Registration Current Page (Not a Parameter Key)
    private var presentIndex = 0
    var otp = ""
    var vehicleTypeString = ""
}

extension RegistrationParameter {
    
    func setNextRegistrationIndex(from page: PresentRegistrationIndex) {
        if let value = PresentRegistrationIndex(rawValue: page.rawValue + 1) {
            self.presentIndex = value.rawValue
        }
    }
    
    func shouldAutomaticallyMoveToPage(from page: PresentRegistrationIndex) -> Bool {
        return page.rawValue < self.presentIndex
    }
    
    func setDocURL(url: String, for type: VehicleDoc) {
        switch type {
        case .nationalId:
            national_id_image = url
        case .driverLicense:
            driver_licence_image = url
        case .drivrPsvLicense:
            driver_psv_license = url
        case .vehiclePsvLicense:
            vehicle_psv_license = url
        case .goodConductCerti:
            police_clearance_certi = url
        case .vehicleLogbook:
            vehicle_log_book_image = url
        case .ntsaInspectionCert:
            ntsa_inspection_image = url
        case .psvComprehensiveInsurance:
            psv_comprehensive_insurance = url
        }
    }
    
    func setExpiry(date: String, for type: VehicleDoc) {
        switch type {
        case .nationalId:
            break
        case .driverLicense:
            driver_licence_exp_date = date
        case .drivrPsvLicense:
            driver_psv_license_exp_date = date
        case .vehiclePsvLicense:
            vehicle_psv_license_exp_date = date
        case .goodConductCerti:
            break
        case .vehicleLogbook:
            break
        case .ntsaInspectionCert:
            ntsa_exp_date = date
        case .psvComprehensiveInsurance:
            psv_comprehensive_insurance_exp_date = date
        }
    }
    
    func getDocUrl(_ type: VehicleDoc) -> String {
        switch type {
        case .nationalId:
            return self.national_id_image
        case .driverLicense:
            return self.driver_licence_image
        case .drivrPsvLicense:
            return self.driver_psv_license
        case .vehiclePsvLicense:
            return self.vehicle_psv_license
        case .goodConductCerti:
            return self.police_clearance_certi
        case .vehicleLogbook:
            return self.vehicle_log_book_image
        case .ntsaInspectionCert:
            return self.ntsa_inspection_image
        case .psvComprehensiveInsurance:
            return self.psv_comprehensive_insurance
        }
    }
    
    func getDocExpiryDate(_ type: VehicleDoc) -> String {
        switch type {
        case .nationalId:
            return ""
        case .driverLicense:
            return self.driver_licence_exp_date
        case .drivrPsvLicense:
            return self.driver_psv_license_exp_date
        case .vehiclePsvLicense:
            return self.vehicle_psv_license_exp_date
        case .goodConductCerti:
            return ""
        case .vehicleLogbook:
            return ""
        case .ntsaInspectionCert:
            return self.ntsa_exp_date
        case .psvComprehensiveInsurance:
            return self.psv_comprehensive_insurance_exp_date
        }
    }
    
    func isValidDocuments() -> Bool {
        let validator = BunchEmptyValidator()

        validator.append(input: national_id_image, message: Messages.emptyNationalCard)
        validator.append(input: national_id_number, message: Messages.emptyNationalId)
        
        validator.append(input: driver_licence_image, message: Messages.emptyDriverLicense)
        validator.append(input: driver_licence_exp_date, message: Messages.emptyDriverLicenseExpire)
        
        validator.append(input: driver_psv_license, message: Messages.emptyDriverPSVLicense)
        validator.append(input: driver_psv_license_exp_date, message: Messages.emptyDriverPSVLicenseExpire)
        
        validator.append(input: police_clearance_certi, message: Messages.emptyGoodConductCertificate)
        
        validator.append(input: vehicle_psv_license, message: Messages.emptyVehiclePSVLicense)
        validator.append(input: vehicle_psv_license_exp_date, message: Messages.emptyVehiclePSVLicenseExpire)
        
        validator.append(input: ntsa_inspection_image, message: Messages.emptyNTSAInspectionCert)
        validator.append(input: ntsa_exp_date, message: Messages.emptyNTSAInspectionCertExpire)
        
        validator.append(input: psv_comprehensive_insurance, message: Messages.emptyPSVComprehensiveInsurance)
        validator.append(input: psv_comprehensive_insurance_exp_date, message: Messages.emptyPSVComprehensiveInsuranceExpire)
        
        let result = validator.validate()
        if result.isValid == false, let message = result.error {
            AlertMessage.showMessageForError(message)
        }
        return result.isValid
    }
}
