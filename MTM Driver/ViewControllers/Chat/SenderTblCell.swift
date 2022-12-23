//
//  SenderTblCell.swift
//  DSP Driver
//
//  Created by Admin on 25/10/21.
//  Copyright © 2021 baps. All rights reserved.
//

import UIKit

class SenderTblCell: UITableViewCell {
    
    @IBOutlet weak var lblMessage: ThemeLabel!
    @IBOutlet weak var lblTime: ThemeLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
