//
//  CreditCardTableViewCell.swift
//  DPS
//
//  Created by Gaurang on 01/10/21.
//  Copyright © 2021 Mayur iMac. All rights reserved.
//

import UIKit

class CreditCardTableViewCell: UITableViewCell {

    @IBOutlet weak var holderLabel: ThemeLabel!
    @IBOutlet weak var cardTypeImageView: UIImageView!
    @IBOutlet weak var cardNumberLabel: ThemeLabel!
    @IBOutlet weak var expDateLabel: ThemeLabel!
    @IBOutlet weak var cvcLabel: ThemeLabel!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func configureCell(_ info: CardsList) {
       // holderLabel.text = info.cardHolderName
        //cardNumberLabel.text = info.formatedCardNo
        //expDateLabel.text = info.expMonthYear
        cvcLabel.text = "***"
        //cardTypeImageView.image = UIImage(named: info.creditCardType.cardImageString)
    }
}
