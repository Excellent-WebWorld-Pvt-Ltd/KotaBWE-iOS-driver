//
//  Parameters.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 15/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation


struct OTPEmail {
    static let kEmail = "Email"
}

struct OTPCodeStruct {
    static let kOTPCode = "OTPCode"
    static let kCompanyList = "company"
}


struct savedDataForRegistration {
    static let kKeyEmail                             = "Email"
    static let kKeyOTP                               = "OTP"
    static let kKeyAllUserDetails                    = "CompleteUserDetails"
    static let kModelDetails                         = "CompleteModelDetails"
    static let kPageNumber                           = "PageNumber"
}

struct profileKeys {
    static let kDriverId = "DriverId"
    static let kCarModel = "CarModel"
    static let kCarCompany = "CarCompany"
    static let kCompanyID = "CompanyId"
    
}

struct RegistrationProfileKeys {
    static let kKeyEmail = "email"
    static let kKeyFullName = "fullName"
    static let kKeyDOB = "DOB"
    static let kKeyMobileNumber = "mobileNumber"
    static let kKeyPassword = "password"
    static let kKeyAddress = "address"
    static let kKeyPostCode = "postCode"
    static let kKeyState = "state"
    static let kKeyCountry = "country"
    static let kKeyInviteCode = "inviteCode"
}

struct driverProfileKeys
{
    static let kKeyDriverProfile = "driverProfile"
    static let kKeyIsDriverLoggedIN = "isDriverLoggedIN"
    static let kKeyShowTickPayRegistrationScreen = "showTickPayRegistrationKey"
    
}
//struct driverTripToDestinationKeys
//{
//    static let kKeyFirstDestination = "FirstDestination"
//    static let kKeySecondDestination = "SecondDestination"
//    static let kKeyIsBothDestinationSelected = "isBothDestinationSelected"
//    static let kKeyIsFirstDestinationSelected = "isFirstDestinationSelected"
//    static let kKeyIsSecondDestinationSelected = "isSecondDestinationSelected"
//}

struct RegistrationFinalKeys {
    
    
    static let kEmail = "Email"
    
    static let kCompanyID = "CompanyId"
    static let kKeyDOB = "DOB"
    
    static let kMobileNo = "MobileNo"
    static let kFullname = "Fullname"
    static let kGender = "Gender"
    static let kPassword = "Password"
    static let kAddress = "Address"
    
    static let kSuburb = "Suburb"
    
    static let kBankBranch = "BankBranch"
    static let kCity = "City"
    static let kState = "State"
    static let kCountry = "Country"
    static let kZipcode = "Zipcode"
    static let kDriverImage = "DriverImage"
    static let kDriverLicence = "DriverLicence"
    static let kAccreditationCertificate = "AccreditationCertificate"
    static let kDriverLicenceExpiryDate = "DriverLicenseExpire"
    static let kAccreditationCertificateExpiryDate = "AccreditationCertificateExpire"
    static let kbankHolderName = "AccountHolderName"
    static let kBankName = "BankName"
    static let kBankAccountNo = "BankAcNo"
    static let kABN = "ABN"
    static let kBSB = "BSB"
    static let kServiceDescription = "Description"
    static let kVehicleColor = "VehicleColor"
    static let kCarRegistrationCertificate = "CarRegistrationCertificate"
    static let kVehicleInsuranceCertificate = "VehicleInsuranceCertificate"
    static let kCarRegistrationExpiryDate = "RegistrationCertificateExpire"
    static let kVehicleInsuranceCertificateExpiryDate = "VehicleInsuranceCertificateExpire"
    static let kReferralCode = "ReferralCode"
    static let kLat = "Lat"
    static let kLng = "Lng"
    static let kCarThreeTypeName = "CarTypeName"
    
    
    //         String DRIVER_REGISTER_PARAM_VEHICLE_IMAGE = "VehicleImage";
    //        String DRIVER_REGISTER_PARAM_VEHICLE_RIGISTRATION_NO = "VehicleRegistrationNo";
    //        String DRIVER_REGISTER_PARAM_VEHICLE_MODEL_NAME = "VehicleModelName";
    //        String DRIVER_REGISTER_PARAM_VEHICLE_MAKE = "CompanyModel";
    //        String DRIVER_REGISTER_PARAM_VEHICLE_TYPE = "VehicleClass";
    //        String DRIVER_REGISTER_PARAM_NO_OF_PASSENGER = "NoOfPassenger";
    
    
    static let kVehicleRegistrationNo = "VehicleRegistrationNo"
    static let kVehicleImage = "VehicleImage"
    static let kCompanyModel = "CompanyModel"
    static let kVehicleModelName = "VehicleModelName"
    static let kNumberOfPasssenger = "NoOfPassenger"
    static let kVehicleClass = "VehicleClass"
    
    
}

//Email,MobileNo,Fullname,Gender,Password,Address,ReferralCode,Lat,Lng,
//CarModel,
//DriverLicence,CarRegistration,AccreditationCertificate,VehicleInsuranceCertificate


struct nsNotificationKeys {
    
    static let kBookingTypeBookNow = "BookingTypeBookNow"
    static let kBookingTypeBookLater = "BookingTypeBookLater"
}

struct tripStatus {
    static let kisTripContinue = "isTripContinue"
    static let kisRequestAccepted = "isRequestAccepted"
}

struct holdTripStatus {
    static let kIsTripisHolding = "IsTripisHolding"
    
}

struct walletAddCards {
    // DriverId,CardNo,Cvv,Expiry,Alias (CarNo : 4444555511115555,Expiry:09/20)
    static let kCardNo = "CardNo"
    static let kCVV = "Cvv"
    static let kExpiry = "Expiry"
    static let kAlias = "Alias"
    
}

struct walletAddMoney {
    // DriverId,Amount,CardId
    static let kAmount = "Amount"
    static let kCardId = "CardId"
}

struct  walletSendMoney {
    // QRCode,SenderId,Amount
    
    static let kQRCode = "QRCode"
    static let kAmount = "Amount"
    static let kSenderId = "SenderId"
}

struct passengerData {
    static let kPassengerMobileNunber = "PassengerMobileNunber"
}

