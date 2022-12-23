//
//  PromoCodeTableViewCell.swift
//  DPS
//
//  Created by Gaurang on 20/10/21.
//  Copyright © 2021 Mayur iMac. All rights reserved.
//

import UIKit

class PromoCodeTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: ThemeLabel!
    @IBOutlet weak var dateLabel: ThemeLabel!
    @IBOutlet weak var useNowButton: ThemeButton!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func useNowTapped() {

    }
}
