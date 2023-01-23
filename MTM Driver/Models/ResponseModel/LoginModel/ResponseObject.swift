//
//  Data.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on July 23, 2019

import Foundation
import SwiftyJSON


class ResponseObject : Codable {

    var accountHolderName : String!
    var accountNumber : String!
    var address : String!
    var bankBranch : String!
    var bankName : String!
    var busy : String!
    var carType : String!
    var city : String!
    var companyId : String!
    var country : String!
    var createdAt : String!
    var deviceToken : String!
    var deviceType : String!
    var dob : String!
    var driverDocs : DriverDoc?
    var driverRole : String!
    var duty : String!
    var email : String!
    var firstName : String!
    var gender : String!
    var id : String!
    var inviteCode : String!
    var lastName : String!
    var lat : String!
    var lng : String!
    var mobileNo : String!
    var otherCompanyName : String!
    var ownerEmail : String!
    var ownerMobileNo : String!
    var ownerName : String!
    var paymentMethod : String!
    var profileImage : String!
    var qrCode : String!
    var rating : String!
    var referralCode : String!
    var rememberToken : String!
    var state : String!
    var status : String!
    var trash : String!
    var vehicleInfo : [VehicleInfo]!
    var vehicleType : String!
    var verify : String!
    var walletBalance : String!
    var workWithOtherCompany : String!
    var xApiKey : String!
    var postalCode : String!

    var fullName: String {
        [firstName, lastName].compactMap { $0 }.joined(separator: " ")
    }
    
    init() {
    }
	
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        accountHolderName = json["account_holder_name"].stringValue
        accountNumber = json["account_number"].stringValue
        address = json["address"].stringValue
        bankBranch = json["bank_branch"].stringValue
        bankName = json["bank_name"].stringValue
        busy = json["busy"].stringValue
        carType = json["car_type"].stringValue
        city = json["city"].stringValue
        companyId = json["company_id"].stringValue
        country = json["country"].stringValue
        createdAt = json["created_at"].stringValue
        deviceToken = json["device_token"].stringValue
        deviceType = json["device_type"].stringValue
        dob = json["dob"].stringValue
        let driverDocsJson = json["driver_docs"]
        driverDocs = DriverDoc(fromJson: driverDocsJson)
        driverRole = json["driver_role"].stringValue
        duty = json["duty"].stringValue
        email = json["email"].stringValue
        firstName = json["first_name"].stringValue
        gender = json["gender"].stringValue
        id = json["id"].stringValue
        inviteCode = json["invite_code"].stringValue
        lastName = json["last_name"].stringValue
        lat = json["lat"].stringValue
        lng = json["lng"].stringValue
        mobileNo = json["mobile_no"].stringValue
        otherCompanyName = json["other_company_name"].stringValue
        ownerEmail = json["owner_email"].stringValue
        ownerMobileNo = json["owner_mobile_no"].stringValue
        ownerName = json["owner_name"].stringValue
        paymentMethod = json["payment_method"].stringValue
        profileImage = json["profile_image"].stringValue
        qrCode = json["qr_code"].stringValue
        rating = json["rating"].stringValue
        referralCode = json["referral_code"].stringValue
        rememberToken = json["remember_token"].stringValue
        state = json["state"].stringValue
        status = json["status"].stringValue
        trash = json["trash"].stringValue
        vehicleInfo = [VehicleInfo]()
        let vehicleInfoArray = json["vehicle_info"].arrayValue
        for vehicleInfoJson in vehicleInfoArray{
            let value = VehicleInfo(fromJson: vehicleInfoJson)
            vehicleInfo.append(value)
        }
        vehicleType = json["vehicle_type"].stringValue
        verify = json["verify"].stringValue
        walletBalance = json["wallet_balance"].stringValue
        workWithOtherCompany = json["work_with_other_company"].stringValue
        xApiKey = json["x-api-key"].stringValue
        postalCode = json["postal_code"].stringValue
	}
}
