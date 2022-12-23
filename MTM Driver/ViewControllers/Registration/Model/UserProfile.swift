//
//  UserProfile.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 25/04/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import SwiftyJSON

struct User: Codable{
    
    var status : Bool!
    var profile : Profile!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let profileJson = json["driver"]["profile"]
        if !profileJson.isEmpty{
            profile = Profile(fromJson: profileJson)
            
        }
        status = json["status"].boolValue
    }
    
}

//struct Driver:Codable{
//
//    var profile : Profile!
//
//    init(fromJson json: JSON!){
//        if json.isEmpty{
//            return
//        }
//        let profileJson = json["profile"]
//        if !profileJson.isEmpty{
//            profile = Profile(fromJson: profileJson)
//        }
//    }
//}

struct Profile : Codable{
    
    var aBN : String!
    var accreditationCertificate : String!
    var accreditationCertificateExpire : String!
    var address : String!
    var availability : String!
    var balance : String!
    var bankAcNo : String!
    var bankHolderName : String!
    var bankName : String!
    var bSB : String!
    var categoryId : String!
    var city : String!
    var companyId : String!
    var country : String!
    var createdDate : String!
    var dCNumber : String!
    var descriptionField : String!
    var deviceType : String!
    var dispatcherId : String!
    var dOB : String!
    var driverDuty : String!
    var driverLicense : String!
    var driverLicenseExpire : String!
    var email : String!
    var fullname : String!
    var gender : String!
    var id : String!
    var image : String!
    var lat : String!
    var lng : String!
    var mobileNo : String!
    var password : String!
    var pendingBooking : String!
    var profileComplete : String!
    var pwd : String!
    var qRCode : String!
    var rating : Rating!
    var referralAmount : Int!
    var referralCode : String!
    var shareRiding : String!
    var smartPhone : String!
    var state : String!
    var status : String!
    var subUrb : String!
    var token : String!
    var trash : String!
    var vehicle : Vehicle!
    var zipCode : String!
    
   
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        aBN = json["ABN"].stringValue
        accreditationCertificate = json["AccreditationCertificate"].stringValue
        accreditationCertificateExpire = json["AccreditationCertificateExpire"].stringValue
        address = json["Address"].stringValue
        availability = json["Availability"].stringValue
        balance = json["Balance"].stringValue
        bankAcNo = json["BankAcNo"].stringValue
        bankHolderName = json["BankHolderName"].stringValue
        bankName = json["BankName"].stringValue
        bSB = json["BSB"].stringValue
        categoryId = json["CategoryId"].stringValue
        city = json["City"].stringValue
        companyId = json["CompanyId"].stringValue
        country = json["Country"].stringValue
        createdDate = json["CreatedDate"].stringValue
        dCNumber = json["DCNumber"].stringValue
        descriptionField = json["Description"].stringValue
        deviceType = json["DeviceType"].stringValue
        dispatcherId = json["DispatcherId"].stringValue
        dOB = json["DOB"].stringValue
        driverDuty = json["DriverDuty"].stringValue
        driverLicense = json["DriverLicense"].stringValue
        driverLicenseExpire = json["DriverLicenseExpire"].stringValue
        email = json["Email"].stringValue
        fullname = json["Fullname"].stringValue
        gender = json["Gender"].stringValue
        id = json["Id"].stringValue
        image = json["Image"].stringValue
        lat = json["Lat"].stringValue
        lng = json["Lng"].stringValue
        mobileNo = json["MobileNo"].stringValue
        password = json["Password"].stringValue
        pendingBooking = json["PendingBooking"].stringValue
        profileComplete = json["ProfileComplete"].stringValue
        pwd = json["Pwd"].stringValue
        qRCode = json["QRCode"].stringValue
        let ratingJson = json["rating"]
        if !ratingJson.isEmpty{
            rating = Rating(fromJson: ratingJson)
        }
        referralAmount = json["ReferralAmount"].intValue
        referralCode = json["ReferralCode"].stringValue
        shareRiding = json["ShareRiding"].stringValue
        smartPhone = json["SmartPhone"].stringValue
        state = json["State"].stringValue
        status = json["Status"].stringValue
        subUrb = json["SubUrb"].stringValue
        token = json["Token"].stringValue
        trash = json["Trash"].stringValue
        let vehicleJson = json["Vehicle"]
        if !vehicleJson.isEmpty{
            vehicle = Vehicle(fromJson: vehicleJson)
        }
        zipCode = json["ZipCode"].stringValue
    }
    
}

struct Vehicle : Codable{
    
    var categoryId : String!
    var color : String!
    var company : String!
    var companyId : String!
    var descriptionField : String!
    var driverId : String!
    var id : String!
    var registrationCertificate : String!
    var registrationCertificateExpire : String!
    var vehicleClass : String!
    var vehicleImage : String!
    var vehicleInsuranceCertificate : String!
    var vehicleInsuranceCertificateExpire : String!
    var vehicleModel : String!
    var vehicleRegistrationNo : String!
    
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        categoryId = json["CategoryId"].stringValue
        color = json["Color"].stringValue
        company = json["Company"].stringValue
        companyId = json["CompanyId"].stringValue
        descriptionField = json["Description"].stringValue
        driverId = json["DriverId"].stringValue
        id = json["Id"].stringValue
        registrationCertificate = json["RegistrationCertificate"].stringValue
        registrationCertificateExpire = json["RegistrationCertificateExpire"].stringValue
        vehicleClass = json["VehicleClass"].stringValue
        vehicleImage = json["VehicleImage"].stringValue
        vehicleInsuranceCertificate = json["VehicleInsuranceCertificate"].stringValue
        vehicleInsuranceCertificateExpire = json["VehicleInsuranceCertificateExpire"].stringValue
        vehicleModel = json["VehicleModel"].stringValue
        vehicleRegistrationNo = json["VehicleRegistrationNo"].stringValue
    }
}

struct Rating : Codable{
    
    var rate : String!
  
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        rate = json["Rate"].stringValue
    }
}
