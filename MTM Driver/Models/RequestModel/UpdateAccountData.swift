//
//  UpdateAccountData.swift
//  Pappea Driver
//
//  Created by Apple on 11/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation

class UpdateAccountData : RequestModel {
    var driver_id: String = ""
    var account_holder_name: String = ""
    var bank_name: String = ""
    var bank_branch: String = ""
    var account_number: String = ""
}

class UpdateMailOrNumber: RequestModel {
    var driver_id = ""
    var update_type = ""
    var update_value = ""
}
