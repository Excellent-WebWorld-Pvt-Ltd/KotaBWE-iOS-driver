//
//  PaymentMethodTableViewCell.swift
//  DPS
//
//  Created by Gaurang on 28/09/21.
//  Copyright © 2021 Mayur iMac. All rights reserved.
//

import UIKit

class PaymentMethodTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: ThemeContainerView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.borderColor = .themeBlack
    }

    func configureCell(_ method: PaymentMethod) {
        iconImageView.image = method.icon
        titleLabel.text = method.title
        titleLabel.textColor = method == .card ? .lightGray : .black
        self.isUserInteractionEnabled = method != .card
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        containerView.layer.borderWidth = selected ? 1 : 0
    }
    
}
