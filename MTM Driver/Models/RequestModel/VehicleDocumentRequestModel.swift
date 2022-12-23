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
    
    var national_id_image: String = ""
    var national_id_number: String = ""
    
    var driver_licence_image: String = ""
    var driver_licence_exp_date: String = ""
    
    var driver_psv_license: String = ""
    var driver_psv_license_exp_date: String = ""
    
    var police_clearance_certi: String = ""
    
    var vehicle_psv_license: String = ""
    var vehicle_psv_license_exp_date: String = ""
    
    var vehicle_log_book_image: String = ""
    
    var ntsa_inspection_image: String = ""
    var ntsa_exp_date: String = ""
    
    var psv_comprehensive_insurance: String = ""
    var psv_comprehensive_insurance_exp_date: String = ""
    
    func set(driverDoc info: DriverDoc) {
        id = info.id
        driver_id = info.driver_id
        national_id_image = info.national_id_image
        national_id_number = info.national_id_number
        driver_licence_image = info.driver_licence_image
        driver_licence_exp_date = info.driver_licence_exp_date
        driver_psv_license = info.driver_psv_license
        driver_psv_license_exp_date = info.driver_psv_license_exp_date
        police_clearance_certi = info.police_clearance_certi
        vehicle_psv_license = info.vehicle_psv_license
        vehicle_psv_license_exp_date = info.vehicle_psv_license_exp_date
        vehicle_log_book_image = info.vehicle_log_book_image
        ntsa_inspection_image = info.ntsa_inspection_image
        ntsa_exp_date = info.ntsa_exp_date
        psv_comprehensive_insurance = info.psv_comprehensive_insurance
        psv_comprehensive_insurance_exp_date = info.psv_comprehensive_insurance_exp_date
    }
    
}


extension VehicleDocRequestModel {
    
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
