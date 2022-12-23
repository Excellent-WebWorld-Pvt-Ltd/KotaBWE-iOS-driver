//
//  transferMoneyToBank.swift
//  Peppea
//
//  Created by eww090 on 19/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import Foundation

/*
 "customer_id:1
 amount:10
 account_holder_name:mayur
 bank_name:patel
 bank_branch:SBI
 account_number:986532124578"
 */
class transferMoneyToBank : RequestModel
{
    var driver_id : String = ""
    var amount : String = ""
    var account_holder_name : String = ""
    var bank_name : String = ""
    var bank_branch : String = ""
    var account_number : String = ""
}

