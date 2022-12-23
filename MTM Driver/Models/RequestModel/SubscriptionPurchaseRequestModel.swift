//
//  SubscriptionPurchaseRequestModel.swift
//  MTM Driver
//
//  Created by Gaurang on 28/09/22.
//  Copyright © 2022 baps. All rights reserved.
//

import Foundation

class SubscriptionPurchaseRequest: RequestModel {
    
    let driver_id: String
    let subscription_id: String
    let payment_type: String
    let card_id: String
    
    init(subscription_id: String, payment_type: String, cardId: String = "") {
        self.driver_id = Singleton.shared.driverId
        self.subscription_id = subscription_id
        self.payment_type = payment_type
        self.card_id = cardId
    }
}
