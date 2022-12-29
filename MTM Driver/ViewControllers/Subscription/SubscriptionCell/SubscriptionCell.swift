//
//  SubscriptionCell.swift
//  MTM Driver
//
//  Created by Gaurang on 27/09/22.
//  Copyright © 2022 baps. All rights reserved.
//

import UIKit

class SubscriptionCell: UITableViewCell {

    @IBOutlet weak var titleLabel: ThemeLabel!
    @IBOutlet weak var amountLabel: ThemeLabel!
    @IBOutlet weak var timePeriodLabel: ThemeLabel!
    @IBOutlet weak var descriptionLabel: ThemeLabel!
    
    private var subscriptionAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configCell(_ info: SubscriptionDetailsModel, subscriptionAction: @escaping (() -> Void)) {
        self.subscriptionAction = subscriptionAction
        titleLabel.text = info.name
        amountLabel.text = info.amount.toCurrencyString()
        timePeriodLabel.text = info.type.uppercased()
        descriptionLabel.text = info.desc?.trimmed
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func subscriptionTapped() {
        subscriptionAction?()
    }
    
}
