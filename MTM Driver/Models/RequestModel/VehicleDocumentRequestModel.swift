//
//  VehicleDocumentRequestModel.swift
//  DSP Driver
//
//  Created by Admin on 29/11/21.
//  Copyright © 2021 baps. All rights reserved.
//

import Foundation

class VehicleDocRequestModel: RequestModel {
    
    var id: String = ""
    var driver_id: String = ""
    
//    var driver_psv_license: String = ""
//    var driver_psv_license_exp_date: String = ""
//
//    var police_clearance_certi: String = ""
//
//    var vehicle_psv_license: String = ""
//    var vehicle_psv_license_exp_date: String = ""
//
//    var vehicle_log_book_image: String = ""
//
//    var ntsa_inspection_image: String = ""
//    var ntsa_exp_date: String = ""
//
//    var psv_comprehensive_insurance: String = ""
//    var psv_comprehensive_insurance_exp_date: String = ""
    
    
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
    
    
    
    func set(driverDoc info: DriverDoc) {
        id = info.id
        driver_id = info.driver_id
        driver_licence_image_front = info.driver_licence_image_front
        driver_licence_image_back = info.driver_licence_image_back
        driver_licence_exp_date = info.driver_licence_exp_date
        criminal_record_image = info.criminal_record_image
        residence_certificate = info.residence_certificate
        rental_license_image = info.rental_license_image
        rental_license_exp_date = info.rental_license_exp_date
        booklet_image = info.booklet_image
        civil_liability_insurance_image = info.civil_liability_insurance_image
        civil_liability_insurance_exp_date = info.civil_liability_insurance_exp_date
        bi_image_front = info.bi_image_front
        bi_image_back = info.bi_image_back
        bi_exp_date = info.bi_exp_date
    }
    
}


extension VehicleDocRequestModel {
    
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
