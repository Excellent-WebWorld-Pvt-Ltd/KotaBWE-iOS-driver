//
//  ProfileInfoTableViewCell.swift
//  DSP Driver
//
//  Created by Admin on 21/10/21.
//  Copyright © 2021 baps. All rights reserved.
//

import UIKit

class ProfileInfoTableViewCell: UITableViewCell {

    
    //MARK:- ====== Variables ====
    var editClicked : (()->())?
    
    
    //MARK:- ===== Outlets =======
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: ThemeLabel!
    @IBOutlet weak var lblEmail: ThemeLabel!
    @IBOutlet weak var lblMobileNo: ThemeLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnActionEdit(_ sender: UIButton) {
        if let clicked = editClicked{
           clicked()
        }
        
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        UIView.animate(withDuration: highlighted ? 0.1 : 0.2) {
            self.transform = highlighted ? .init(scaleX: 0.9, y: 0.9) : .identity
        }
    }
    
    
}
