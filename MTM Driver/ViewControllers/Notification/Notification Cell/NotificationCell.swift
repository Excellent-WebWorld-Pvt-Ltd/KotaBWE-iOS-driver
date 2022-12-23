//
//  NotificationCell.swift
//  DPS
//
//  Created by Gaurang on 12/11/21.
//  Copyright © 2021 Mayur iMac. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var titleLabel: ThemeLabel!
    @IBOutlet weak var timeLabel: ThemeLabel!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func configuration(_ info: NotificationInfo)  {
        titleLabel.text = info.title
        if let dateStr = info.createdDate {
            timeLabel.text = DateFormatHelper.standard.getDate(from: dateStr)?.getDayDifferentTextWithTime()
            timeLabel.isHidden = false
        } else {
            timeLabel.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
