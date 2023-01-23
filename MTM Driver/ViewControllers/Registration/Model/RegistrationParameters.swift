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
    var postal_code = ""
    
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
    var vehicle_left = ""
    var vehicle_right = ""
    var vehicle_front = ""
    var vehicle_back = ""
    
//    -----------------------------------------------------
//    for documents and expiry
//    -----------------------------------------------------
    var national_id_number = ""
    var driver_licence_image_front = ""
    var driver_licence_image_back = ""
    var driver_licence_exp_date = ""
    
    var criminal_record_image = ""
    var residence_certificate = ""
    var rental_license_image = ""
    var rental_license_exp_date = ""
    var booklet_image = ""
    var civil_liability_insurance_image = ""
    var civil_liability_insurance_exp_date = ""
    var bi_image_front = ""
    var bi_image_back = ""
    var bi_exp_date = ""
    
    
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
    
    func setDocURL(url: String, for type: VehicleDoc,side:Bool) {
        switch type {
        case .driverLicense:
            if side{
                driver_licence_image_front = url
            }else{
                driver_licence_image_back = url
            }
        case .drivrCriminalRecord:
            criminal_record_image = url
        case .drivrResidenceCertificate:
            residence_certificate = url
        case .rentalLicense:
            rental_license_image = url
        case .booklet:
            booklet_image = url
        case .civilLiabilityInsurance:
            civil_liability_insurance_image = url
        case .biFrontAndBack:
            if side{
                bi_image_front = url
            }else{
                bi_image_back = url
            }
        default:
            break
        }
    }
    
    func setExpiry(date: String, for type: VehicleDoc) {
        switch type {
        case .driverLicense:
            driver_licence_exp_date = date
        case .rentalLicense:
            rental_license_exp_date = date
        case .civilLiabilityInsurance:
            civil_liability_insurance_exp_date = date
        case .biFrontAndBack:
            bi_exp_date = date
        default:
            break
        }
    }
    
    func getDocUrl(_ type: VehicleDoc,side:Bool) -> String {
        switch type {
        case .driverLicense:
            if side{
                return driver_licence_image_front
            }else{
                return driver_licence_image_back
            }
        case .drivrCriminalRecord:
            return criminal_record_image
        case .drivrResidenceCertificate:
            return residence_certificate
        case .rentalLicense:
            return rental_license_image
        case .booklet:
            return booklet_image
        case .civilLiabilityInsurance:
            return civil_liability_insurance_image
        case .biFrontAndBack:
            if side{
                return bi_image_front
            }else{
                return bi_image_back
            }
        default:
            return ""
        }
    }
    
    func getDocExpiryDate(_ type: VehicleDoc) -> String {
        switch type {
        case .driverLicense:
            return driver_licence_exp_date
        case .rentalLicense:
            return rental_license_exp_date
        case .civilLiabilityInsurance:
            return civil_liability_insurance_exp_date
        case .biFrontAndBack:
            return bi_exp_date
        default:
            return ""
        }
    }
    
    func isValidDocuments() -> Bool {
        let validator = BunchEmptyValidator()

        validator.append(input: driver_licence_image_front, message: Messages.emptyDriverLicenseFront)
        validator.append(input: driver_licence_image_back, message: Messages.emptyDriverLicenseBack)
        validator.append(input: driver_licence_exp_date, message: Messages.emptyDriverLicenseExpire)
        
        validator.append(input: criminal_record_image, message: Messages.emptyCriminalRecord)
        validator.append(input: residence_certificate, message: Messages.emptyResidenceCertificate)
        
        validator.append(input: rental_license_image, message: Messages.emptyRentalLicense)
        validator.append(input: rental_license_exp_date, message: Messages.emptyRentalLicenseExpire)
        
        validator.append(input: booklet_image, message: Messages.emptyBooklet)
        validator.append(input: civil_liability_insurance_image, message: Messages.emptyCivilLiabilityInsurance)
        
        validator.append(input: civil_liability_insurance_exp_date, message: Messages.emptyCivilLiabilityInsuranceExpire)
        
        validator.append(input: bi_image_front, message: Messages.emptyBIFront)
        validator.append(input: bi_image_back, message: Messages.emptyBIBack)
        validator.append(input: bi_exp_date, message: Messages.emptyBIExpire)
        
        let result = validator.validate()
        if result.isValid == false, let message = result.error {
            AlertMessage.showMessageForError(message)
        }
        return result.isValid
    }
}
