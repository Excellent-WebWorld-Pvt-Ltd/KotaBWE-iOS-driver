//
//  PaymentWalletTypeListCell.swift
//  Peppea
//
//  Created by eww090 on 12/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class PaymentWalletTypeListCell: UITableViewCell {

    
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var iconWallet: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
