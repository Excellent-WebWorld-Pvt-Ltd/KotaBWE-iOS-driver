//
//  WalletHistoryTableViewCell.swift
//  DPS
//
//  Created by Gaurang on 28/09/21.
//  Copyright © 2021 Mayur iMac. All rights reserved.
//

import UIKit

class WalletHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: ThemeLabel!
    @IBOutlet weak var timeLabel: ThemeLabel!
    @IBOutlet weak var amountLable: ThemeLabel!
    @IBOutlet weak var transactionFailedLabel: ThemeLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(_ info: walletHistoryListData) {
        if let date = DateFormatHelper.standard.getDate(from: info.createdAt) {
            timeLabel.text = DateFormatHelper.fullDateTime.getDateString(from: date)
        } else {
            timeLabel.text = info.createdAt
        }
        if let fullString = info.descriptionField, let underLineString = info.referenceId {
            let fullRange = fullString.nsRange
            let underLineStringRange = fullString.nsRange(of: underLineString)
            let mutableAttrStr = NSMutableAttributedString(string: fullString)
            mutableAttrStr.addAttributes([.font: FontBook.semibold.font(ofSize: 14),
                                          .foregroundColor: UIColor.themeBlack], range: fullRange)
            mutableAttrStr.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: underLineStringRange)
            titleLabel.attributedText = mutableAttrStr
        } else {
            titleLabel.text = info.descriptionField
        }
        transactionFailedLabel.isHidden = true//info.status == "success"
        amountLable.textColor = info.type == "+" ? .themeSuccess : .themeFailed
        amountLable.text = "\(info.type ?? "")" + (info.amount.toCurrencyString())

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
