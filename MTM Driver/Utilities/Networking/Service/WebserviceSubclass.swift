//
//  WebServiceCalls.swift
//  Pappea Driver
//
//  Created by Mayur iMac on 08/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation
import UIKit

class WebServiceCalls
{
//    class func initApi( strURL : String  ,completion: @escaping CompletionResponse ) {
//           WebService.shared.getMethod(url: URL.init(string: strURL)!, httpMethod: .get, completion: completion)
//    }
    
    class func registerOTP( otpModel : OTPModel , complition : @escaping CompletionResponse) {
        let params :  [String:String] = otpModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .otp, httpMethod: .post, parameters: params, completion: complition)
    }
    
    class func register( registerModel : RegistrationParameter  ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = registerModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .register, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func resendOTP( OtpModel : ResendOTPModel  ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = OtpModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .resendOTP, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func login( loginModel : loginModel  ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = loginModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .login, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func transferMoney(transferMoneyModel : TransferMoneyModel, completion: @escaping CompletionResponse) {
        let params : [String:String] = transferMoneyModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .transferMoney, httpMethod: .post, parameters: params, completion: completion)
    }
    class func addCardInList(addCardModel : AddCardRequestModel, completion: @escaping CompletionResponse) {
        let params : [String:String] = addCardModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .AddCard, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func CardInList(cardListModel : CardList, completion: @escaping CompletionResponse) {
        let params : [String:String] = cardListModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .cardList, httpMethod: .post, parameters: params, completion: completion)
    }
   
    class func updateAccount(transferMoneyModel : UpdateAccountData, completion: @escaping CompletionResponse) {
        let params : [String:String] = transferMoneyModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .updateAccount, httpMethod: .post, parameters: params, completion: completion)
    }
    class func updateEmailOrMobile(emailNumberModel : UpdateMailOrNumber, completion: @escaping CompletionResponse) {
        let params : [String:String] = emailNumberModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .updateNumberOrMail, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func updatePersonal(requestModel : UpdatePersonalInfo, image: UIImage?, imageParamName: String, completion: @escaping CompletionResponse) {
        let params = requestModel.generatPostParams()
        WebService.shared.postDataWithImage(api: .updateBasicInfo, parameter: params, image: image, imageParamName: imageParamName, completion: completion)
    }
    
    
    class func RemoveCardFromList(removeCardModel : RemoveCard, completion: @escaping CompletionResponse) {
        let params : [String:String] = removeCardModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .removeCard, httpMethod: .post, parameters: params, completion: completion)
    }
    class func updateDocuments(requestModel : VehicleDocRequestModel , completion: @escaping CompletionResponse) {
        
        let params = requestModel.generatPostParams()
        WebService.shared.requestMethod(api: .update_docs, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func updateVehicleInfo(transferMoneyModel : UpdateVehicleInfo, imageParamName: [String], completion: @escaping CompletionResponse) {
        
        let params : [String: String] = transferMoneyModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .updateVehicleInfo, httpMethod: .post, parameters: params, completion: completion)

//        WebService.shared.postDataWithArrayImages(api: .updateVehicleInfo, parameter: params, image: image, imageParamName: imageParamName, completion: completion)
        // postDataWithImage(api: .update_docs, parameter: params, image: image, imageParamName: imageParamName, completion: completion)
    }
    
    class func changeDuty(transferMoneyModel : ChangeDutyStatus, completion: @escaping CompletionResponse)
    {
        let params : [String:String] = transferMoneyModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .changeDuty, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func pastBookingHistory(strType : String, completion: @escaping CompletionResponse )
    {
        let strURLFinal = NetworkEnvironment.apiURL + ApiKey.pastBookingHistory.rawValue + strType
        WebService.shared.getMethod(url: URL.init(string: strURLFinal)!, httpMethod: .get, completion: completion)
    }
    
    class func UpcomingBookingHistory(strType : String, completion: @escaping CompletionResponse )
    {
        let strURLFinal = NetworkEnvironment.apiURL + ApiKey.upcomingBookingHistory.rawValue + strType
        WebService.shared.getMethod(url: URL.init(string: strURLFinal)!, httpMethod: .get, completion: completion)
    }
    
    class func LogoutApi(strType : [String: Any]  ,completion: @escaping CompletionResponse ) {
        WebService.shared.requestMethod(api: .logout, httpMethod: .get, parameters: strType, completion: completion)
    }
    class func VehicleTypeListApi(strType : [String: Any]  ,completion: @escaping CompletionResponse ) {
        WebService.shared.requestMethod(api: .vehicleTypeList, httpMethod: .get, parameters: strType, completion: completion)
    }
    class func changePassword(transferMoneyModel: [String: Any], completion: @escaping CompletionResponse) {
        let params : [String:String] = transferMoneyModel as! [String:String]
        WebService.shared.requestMethod(api: .changePassword, httpMethod: .post, parameters: params, completion: completion)
    }
    class func forgotPassword(strType : [String: Any]  ,completion: @escaping CompletionResponse ) {
        WebService.shared.requestMethod(api: .forgotPassword, httpMethod: .post, parameters: strType, completion: completion)
    }
    
    class func vehicleTypeModelList(strType : [String: Any]  ,completion: @escaping CompletionResponse ) {
        WebService.shared.requestMethod(api: .vehicleTypeModelList, httpMethod: .get, parameters: strType, completion: completion)
    }
    
    class func companyList(strType : [String: Any]  ,completion: @escaping CompletionResponse ) {
        WebService.shared.requestMethod(api: .companyList, httpMethod: .get, parameters: strType, completion: completion)
    }
    
//    class func addCard(transferMoneyModel: AddCard, completion: @escaping CompletionResponse) {
//        let params : [String:String] = transferMoneyModel.generatPostParams() as! [String:String]
//        WebService.shared.requestMethod(api: .addCard, httpMethod: .post, parameters: params, completion: completion)
//    }
    
    class func removeCard(transferMoneyModel: RemoveCard, completion: @escaping CompletionResponse) {
        let params : [String:String] = transferMoneyModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .removeCard, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func cardList(transferMoneyModel: CardList, completion: @escaping CompletionResponse) {
        let params : [String:String] = transferMoneyModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .cardList, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func walletHistory(transferMoneyModel: WalletHistory, completion: @escaping CompletionResponse) {
        let params : [String:String] = transferMoneyModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .walletHistory, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func transferMoneyMobileVerify(requestModel: MobileVerifRequestModel, completion: @escaping CompletionResponse) {
        let params: [String:String] = requestModel.generatPostParams() as! [String: String]
        WebService.shared.requestMethod(api: .mobileCheckForTransferMoney,
                                        httpMethod: .post,
                                        parameters: params,
                                        completion: completion)
    }

    class func transferMoney(transferMoneyModel : TransferMoneyRequestModel, completion: @escaping CompletionResponse) {
        let params : [String:String] = transferMoneyModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .MobileNoDetail, httpMethod: .post, parameters: params, completion: completion)
    }

    class func transferToBankService(transferMoneyModel: TransferToBank, completion: @escaping CompletionResponse) {
        let params : [String:String] = transferMoneyModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .transferMoneyToBank, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func AddMoneytoWallet(addMoneyModel : AddMoneyRequestModel, completion: @escaping CompletionResponse) {
        let params : [String:String] = addMoneyModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .addMoney, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func scanCodeDetail(QRCodeDetailsModel : QRCodeDetails, completion: @escaping CompletionResponse) {
        let params : [String:String] = QRCodeDetailsModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .QRCodeDetail, httpMethod: .post, parameters: params, completion: completion)
    }
    class func MobileNoDetailDetail(MobileNoDetailModel : MobileNoDetail, completion: @escaping CompletionResponse) {
        let params : [String:String] = MobileNoDetailModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .MobileNoDetail, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func CompleteTripService(MobileNoDetailModel : CompleteModel, completion: @escaping CompletionResponse) {
        let params : [String:String] = MobileNoDetailModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .completeTrip, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func CancelTripService(cancelTripDetailModel : CompleteModel, completion: @escaping CompletionResponse) {
        let params : [String:String] = cancelTripDetailModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .cancelTrip, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func addReviewRating(ReviewRatingModel : ReviewRatingReqModel , complition : @escaping CompletionResponse) {
        let param : [String:String] =  ReviewRatingModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .reviewRating, httpMethod: .post, parameters: param, completion: complition)
    }
    
    class func acceptBookLater(bookLaterReqModel : acceptBookLaterRequestModel , Complition : @escaping CompletionResponse) {
        let param : [String:String] = bookLaterReqModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .acceptBookLater, httpMethod: .post, parameters: param, completion: Complition)
    }
    
    class func chatHistoryWithDriver(strURL : String  ,completion: @escaping CompletionResponse ) {
        let strURLFinal = NetworkEnvironment.apiURL + ApiKey.chatHistory.rawValue + strURL
        WebService.shared.getMethod(url: URL.init(string: strURLFinal)!, httpMethod: .get,  completion: completion)
    }
    
    class func chatWithDriver(SendChat: ChatMessageRequestModel , completion: @escaping CompletionResponse) {
        let  params : [String:String] = SendChat.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .chat, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func totalEarningReport(reqmodel : EarningRequestModel , Complition:@escaping CompletionResponse){
        let param : [String:String] = reqmodel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .earningReport, httpMethod: .post, parameters: param, completion: Complition)
    }
    
    class func StartMeterBooking(reqmodel : MeterRequestModel , Complition : @escaping CompletionResponse) {
        let param : [String:String] = reqmodel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .startMeterBooking, httpMethod: .post, parameters: param, completion: Complition)
    }
    
    class func EndMeterBooking(reqModel : EndMeterRequestModel , Complition:@escaping CompletionResponse){
        let param : [String:String] = reqModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .endMeterBooking, httpMethod: .post, parameters: param, completion: Complition)
    }
    
    class func TripDetail(strURL : String  ,completion: @escaping CompletionResponse ) {
        let strURLFinal = NetworkEnvironment.apiURL + ApiKey.TripDetail.rawValue + strURL
        WebService.shared.getMethod(url: URL.init(string: strURLFinal)!, httpMethod: .get,  completion: completion)
    }
    
    
    
//    class func AddMoneytoWallet(addMoneyModel : AddMoneyRequestModel, completion: @escaping CompletionResponse) {
//        let params : [String:String] = addMoneyModel.generatPostParams() as! [String:String]
//        WebService.shared.requestMethod(api: .AddMoney, httpMethod: .post, parameters: params, completion: completion)
//    }
//
    static func fetchHelpFaq(completion: @escaping CompletionResponse) {
        let strURLFinal = NetworkEnvironment.apiURL + ApiKey.helpFaq.rawValue
        WebService.shared.getMethod(url: URL.init(string: strURLFinal)!, httpMethod: .get, completion: completion)
    }
    
    class func GenerateTicketService(param:GenerateTicketModel , completion: @escaping CompletionResponse) {
        let  params : [String:String] = param.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .generateTicket, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func TicketListService(strURL : String  ,completion: @escaping CompletionResponse ) {
        let strURLFinal = NetworkEnvironment.apiURL + ApiKey.ticketList.rawValue + strURL
        WebService.shared.getMethod(url: URL.init(string: strURLFinal)!, httpMethod: .get,  completion: completion)
    }
    
    class func subscriptionList(completion: @escaping CompletionResponse ) {
        let strURLFinal = NetworkEnvironment.apiURL + ApiKey.subscriptionList.rawValue
        WebService.shared.getMethod(url: URL.init(string: strURLFinal)!, httpMethod: .get,  completion: completion)
    }
    
    class func subscriptionPurchase(model: SubscriptionPurchaseRequest, completion: @escaping CompletionResponse ) {
        let param = model.generatPostParams()
        WebService.shared.requestMethod(api: .subscriptionPurchase, httpMethod: .post, parameters: param, completion: completion)
    }
    
    static func deleteAccountAPi(params:  [String: String], completion: @escaping CompletionResponse) {
        WebService.shared.requestMethod(api: .deleteAccount, httpMethod: .post, parameters: params, completion: completion)
    }
    
    static func clearNotification(completion: @escaping CompletionResponse) {
        let urlStrb = "\(NetworkEnvironment.apiURL)\(ApiKey.clearNotification.rawValue)/\(Singleton.shared.driverId)"
        let url = URL(string: urlStrb)!
        WebService.shared.getMethod(url: url, httpMethod: .get, completion: completion)
    }
    
    static func uploadImage(_ image: UIImage,
                            completion: @escaping (_ url: String) -> Void) {
        WebService.shared.postDataWithImage(api: .docUpload, parameter: [:],  image: image, imageParamName: "image"){ json,status in
            completion(json["url"].stringValue)
        }
    }

    static func withdrawMoney(amount: String, completion: @escaping CompletionResponse) {
        let params: [String: String] = [
            "driver_id": Singleton.shared.driverId,
            "amount": amount
        ]
        WebService.shared.requestMethod(api: .withdrawals, httpMethod: .post, parameters: params, completion: completion)
    }
    
}
