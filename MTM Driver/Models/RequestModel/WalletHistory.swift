//
//  WalletHistory.swift
//  Pappea Driver
//
//  Created by Mayur iMac on 09/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation


class WalletHistory : RequestModel {
    var driver_id: String = ""
    var page: String = ""
    var from_date: String = ""
    var to_date: String = ""
    var payment_type: String = ""
    var transaction_type: String = ""
}
