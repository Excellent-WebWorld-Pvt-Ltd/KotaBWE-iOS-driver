//
//  SettingTableViewCell.swift
//  DSP Driver
//
//  Created by Admin on 21/10/21.
//  Copyright © 2021 baps. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    //MARK:- ===== Outlets =====
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSetting: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // btnSetting.isEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        UIView.animate(withDuration: highlighted ? 0.1 : 0.2) {
            self.transform = highlighted ? .init(scaleX: 0.9, y: 0.9) : .identity
        }
    }
    
}
