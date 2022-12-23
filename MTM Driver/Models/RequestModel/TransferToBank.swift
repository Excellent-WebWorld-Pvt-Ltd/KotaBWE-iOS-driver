//
//  TransferToBank.swift
//  Pappea Driver
//
//  Created by Apple on 22/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation

class TransferToBank : RequestModel {
    var driver_id: String = ""
    var amount: String = ""
    var account_holder_name: String = ""
    var bank_name: String = ""
    var bank_branch: String = ""
    var account_number: String = ""
}

