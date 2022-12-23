//
//  AddCard.swift
//  Pappea Driver
//
//  Created by Mayur iMac on 09/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation

class AddCardRequestModel : RequestModel {
    var driver_id: String = ""
    var card_no: String = ""
    var card_holder_name: String = ""
    var exp_date_month: String = ""
    var exp_date_year: String = ""
    var cvv: String = ""
}

class AddCard : RequestModel {
    var driver_id: String = ""
    var card_no: String = ""
    var card_holder_name: String = ""
    var exp_date_month: String = ""
    var exp_date_year: String = ""
    var cvv: String = ""
}


class AddMoneyRequestModel : RequestModel {
    var driver_id: String = ""
    var card_id: String = ""
    var amount: String = ""
    var pin: String = ""
    var payment_type:String = ""
    
}

//mobile_no:1234567891
//user_type:driver
//amount:10
//sender_id:10

class TransferMoneyRequestModel: RequestModel {
    let mobile_no: String
    var user_type = "driver"
    var sender_id: String = "\(Singleton.shared.driverId)"
    let amount: String

    init(mobileNo: String, amount: String) {
        mobile_no = mobileNo
        self.amount = amount
    }

}

class MobileVerifRequestModel: RequestModel {
    let mobile_no: String
    var user_type = "driver"
    var sender_id: String = "\(Singleton.shared.driverId)"

    init(mobileNo: String) {
        mobile_no = mobileNo
    }

}
