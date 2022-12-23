//
//  PaymentCardTypeListCell.swift
//  Peppea
//
//  Created by eww090 on 12/07/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit
//import SwipeCellKit

class PaymentCardTypeListCell: SwipeTableViewCell {

    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var iconCard: UIImageView!
    @IBOutlet weak var lblCardNumber: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
