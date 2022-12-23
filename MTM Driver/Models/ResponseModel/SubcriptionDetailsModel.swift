//
//  SubcriptionDetailsModel.swift
//  MTM Driver
//
//  Created by Gaurang on 28/09/22.
//  Copyright © 2022 baps. All rights reserved.
//

import Foundation
import SwiftyJSON

struct SubscriptionDetailsBase: JSonParsable {
    let status: Bool
    let message: String?
    let data: [SubscriptionDetailsModel]
    let driverSubscription: SubscriptionDetailsModel?
    
    init(json: JSON) {
        status = json["status"].boolValue
        message = json.getApiMessage()
        data = json["subscription"].arrayValue.compactMap({SubscriptionDetailsModel(json: $0)})
        driverSubscription = SubscriptionDetailsModel(json: json["driver_subscription"])
    }
}

struct SubscriptionDetailsModel: Codable {
    let id, name, type, amount: String
    let desc: String?
    let startDate, endDate: String?
    
    init?(json: JSON) {
        guard json.isEmpty == false,
        let id = json["id"].string else {
            return nil
        }
        self.id = id
        name = json["name"].stringValue
        type = json["type"].stringValue
        amount = json["amount"].stringValue
        desc = json["description"].stringValue
        startDate = json["start_date"].stringValue
        endDate = json["end_date"].stringValue
    }
}

class SubscriptionPurchaseBase: CommonApiResponse {
    let paymentUrl: String?
    let data: SubscriptionDetailsModel?
    required init(json: JSON) {
        paymentUrl = json["payment_url"].string
        data = SubscriptionDetailsModel(json: json["subscription"])
        super.init(json: json)
    }
}
