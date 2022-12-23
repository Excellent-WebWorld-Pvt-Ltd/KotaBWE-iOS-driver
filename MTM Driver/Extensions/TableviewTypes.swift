//
//  TableViewCellType.swift
//  DPS
//
//  Created by Gaurang on 23/09/21.
//  Copyright © 2021 Mayur iMac. All rights reserved.
//

import UIKit

enum TableViewCellType: String {

    case trip           = "TripTableViewCell"
    case noData         = "NoDataFoundTblCell"
    case paymentMethod  = "PaymentMethodTableViewCell"
    case walletHistory  = "WalletHistoryTableViewCell"
    case crediCard      = "CreditCardTableViewCell"
    case promoCode      = "PromoCodeTableViewCell"
    case Setting        = "SettingTableViewCell"
    case ProfileInfo    = "ProfileInfoTableViewCell"
    case notification   = "NotificationCell"
    case subscription   = "SubscriptionCell"
    case vehicleDoc     = "VehicleDocTableViewCell"


    var cellId: String {
        switch self {
        case .trip:
            return "trip_cell"
        case .noData:
            return "no_data_cell"
        case .paymentMethod:
            return "payment_method_cell"
        case .walletHistory:
            return "wallet_history_cell"
        case .crediCard:
            return "card_cell"
        case .promoCode:
            return "promo_code_cell"
        case .ProfileInfo:
            return "ProfileInfoTableViewCell"
        case .Setting:
            return "SettingTableViewCell"
        case .notification:
            return "notification_cell"
        case .subscription:
            return "subscription_cell"
        case .vehicleDoc:
            return "vehicle_doc_cell"
        }
    }
}

extension UITableView {

    func registerNibCell(type: TableViewCellType) {
        self.register(UINib(nibName: type.rawValue, bundle: nil), forCellReuseIdentifier: type.cellId)
    }

    func setHorizontalContentPadding(_ padding: CGFloat) {
        self.contentInset.top = padding
        self.contentInset.bottom = padding
    }
    

    func dequeueReusableCell<T: UITableViewCell>(withType cellType: TableViewCellType, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: cellType.cellId, for: indexPath) as! T
    }

    func setVerticalContentPadding(_ padding: CGFloat) {
        self.contentInset.top = padding
        self.contentInset.bottom = padding
    }
    
}
