//
//  PaymentMethod.swift
//  MTM Driver
//
//  Created by Admin on 07/01/22.
//  Copyright © 2022 baps. All rights reserved.
//

import Foundation
import UIKit

enum PaymentMethod: String {
    case wallet
    case card
    case mPesa = "mpesa"
    case cash
    case jambopay

    var title: String {
        switch self {
        case .wallet:   return "Wallet"
        case .card:     return "Cards"
        case .mPesa:    return "M-Pesa"
        case .cash:     return "Cash"
        case .jambopay: return "Jambopay"
        }
    }

    var icon: UIImage {
        let appImage: AppImages = {
            switch self {
            case .wallet:   return .wallet
            case .card:     return .creditCard
            case .mPesa:    return .mPesa
            case .cash:     return .cash
            case .jambopay: return .jambopay
            }
        }()
        return appImage.image
    }

    static var all: [PaymentMethod] {
        [.wallet, .jambopay, .cash]
    }

    static var typesForAddMoney: [PaymentMethod] {
        [.jambopay]
    }
    
    static var modeSelection: [PaymentMethod] {
        [.wallet, .jambopay]
    }
}
