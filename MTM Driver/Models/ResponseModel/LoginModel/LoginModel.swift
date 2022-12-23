//
//  LoginModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on July 23, 2019

import Foundation
import SwiftyJSON


class LoginModel : Codable {

    var bookingInfo : BookingInfoLoginModel!
    var currentBooking : CurrentBooking!
    var responseObject : ResponseObject!
    var message : String!
    var status : Bool!
    var otp : String!
    var subscription: SubscriptionDetailsModel?

    init() {
    }
    
	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        let currentBookingJson = json["current_booking"]
        if !currentBookingJson.isEmpty{
            currentBooking = CurrentBooking(fromJson: currentBookingJson)
        }
        let dataJson = json["data"]
        if !dataJson.isEmpty{
            responseObject = ResponseObject(fromJson: dataJson)
        }
        let bookingInfoJson = json["booking_info"]
        if !bookingInfoJson.isEmpty{
            bookingInfo = BookingInfoLoginModel(fromJson: bookingInfoJson)
        }
        message = json["message"].stringValue
        status = json["status"].boolValue
        otp = json["otp"].stringValue
        let subscriptionJson = json["driver_subscription"]
        if !subscriptionJson.isEmpty {
            subscription = SubscriptionDetailsModel(json: subscriptionJson)
        }
	}

}
