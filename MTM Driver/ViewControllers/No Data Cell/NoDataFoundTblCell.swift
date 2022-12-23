//
//  NoDataFoundTblCell.swift
//  Peppea
//
//  Created by EWW082 on 03/10/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit

class NoDataFoundTblCell: UITableViewCell {

    @IBOutlet var lblNoDataFound: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.isUserInteractionEnabled = false
        self.setLocalization()
    }

    func setMessage(_ text: String)  {
        self.lblNoDataFound.text = text
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setLocalization() {
        self.lblNoDataFound.text = "No Data Found"
    }
}
