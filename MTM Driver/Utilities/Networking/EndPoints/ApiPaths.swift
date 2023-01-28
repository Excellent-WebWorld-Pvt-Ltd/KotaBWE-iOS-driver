//
//  ApiPaths.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 20/04/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation
import UIKit


typealias NetworkRouterCompletion = ((Data?,[String:Any]?, Bool) -> ())

enum NetworkEnvironment {
   
    static let serverURL = "http://52.66.86.25/"
//Socket: http://52.66.86.25:8080
//Admin
//http://52.66.86.25/administrator
//mailto:developer.eww@gmail.com
//12345678
    static let apiURL = "\(serverURL)api/driver_api/"
   
    static var baseImageURL = NetworkEnvironment.serverURL
    
    static let webPaymentSuccessUrl = "\(NetworkEnvironment.serverURL)payment/success"
    
    static let webPaymentFailureUrl = "\(NetworkEnvironment.serverURL)payment/fail"
    
    static var headers : [String:String] {
        if SessionManager.shared.isUserLoggedIn,
           let userPofile = SessionManager.shared.userProfile {
            return ["key":"DPS$951", "x-api-key": userPofile.responseObject.xApiKey]
        } else {
            return ["key":"DPS$951"]
        }
    }
   
    static var token: String{
        return "dhuafidsuifunabneufjubefg"
    }
}

enum ApiKey: String {
        
    case Init = "init"
    case login = "login"
    case otp = "register_otp"
    case resendOTP = "resend_otp"
    
    case docUpload = "upload_docs"
    case vehicleTypeList = "vehicle_type_list"
    case register = "register"
    case transferMoney = "transfer_money"
    case updateAccount = "update_bank_info"
    case updateNumberOrMail = "update_email_mobile"
    case updateBasicInfo = "update_basic_info"
    case update_docs = "update_docs"
    case updateVehicleInfo = "update_vehicle_info"
    case changeDuty = "change_duty"
    case logout = "logout"
    case changePassword = "change_password"
    case forgotPassword = "forgot_password"
    case AddCard = "add_card"
    case removeCard = "remove_card"
    case cardList = "card_list"
    case walletHistory = "wallet_history"
    case transferMoneyToBank = "transfer_money_to_bank"
    case addMoney = "add_money"
    case mobileNoDetail = "mobile_no_detail"
    case QRCodeDetail = "qr_code_detail"
    case MobileNoDetail = "transfer_money_with_mobile_no"
    
    case mobileCheckForTransferMoney = "transfer_money_with_mobile_no_check"
    case earningReport = "driver_earnings"
    
    // "mobile_no_detail"
    case completeTrip = "complete_trip"
    case cancelTrip = "cancel_trip"
    case reviewRating = "review_rating"
    
    case upcomingBookingHistory = "future_booking_history"
    case pastBookingHistory = "past_booking_history"
    
    case vehicleTypeModelList = "vehicle_type_manufacturer_list"
    case companyList = "company_list"
    
    case acceptBookLater = "accept_book_later_request"
    case notificationList = "notification_list/"
    
    case chat = "chat"
    case chatHistory = "chat_history/"
    case startMeterBooking = "start_meter_booking"
    case endMeterBooking = "end_meter_booking"
    case TripDetail = "review_list/"
    
    case generateTicket = "generate_ticket"
    case ticketList = "ticket_list/"
    case helpFaq = "helps_faq"
    
    case subscriptionList = "subscription_list"
    case subscriptionPurchase = "subscription_purchase"
    case deleteAccount = "delete_account"
    case clearNotification = "notification_clear"
    case withdrawals
}

enum ParameterKey{
    static let latitude = "Latitude"
    static let longitude = "Longitude"
    static let categoryId = "CategoryId"
    static let page = "Page"
    static let sortBy = "Sortby"
    static let filter = "Filter"
  
}

enum socketApiKeys: String, CaseIterable {
    
    case kSocketBaseURL = "http://52.66.86.25:8080/"
    
    case CancelBeforeAccept = "cancel_booking_before_accept"
    case updateDriverLocation = "update_driver_location"
    case WhenRequestArrived = "forward_booking_request"
    case RejectRequest = "forward_booking_request_to_another_driver"
    case AcceptRequest = "accept_booking_request"
    case StartTrip = "start_trip"
    case liveTraking = "live_tracking"//"driver_current_location"
    case CompleteTrip = "complete_trip"
    case driverarrived = "driver_arrived"
    case driverarivedPickupLocation  = "arrived_at_pickup_location"
    case trackTrip = "track_trip"
    
    case onTheWayBookingRequest = "on_the_way_booking_request" // driver_id,booking_id
    case askForTips = "ask_for_tips"
    case receiveTips = "receive_tips"
    case cancelTrip = "cancel_trip"
    case updateMeterBooking = "update_meter_booking_status"
    case startWaitingTimeForMeter = "start_waiting_time_for_meter"
    case endWaitingTimeForMeter = "end_waiting_time_for_meter"
    case error
    case pickupTimeError = "pickup_time_error"
    
}

enum socketParam: String {
    
    case driverId = "driver_id"
    case lat = "lat"
    case lng = "lng"
    case bookingId = "booking_id"
    
}





