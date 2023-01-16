//
//  DutyOnOffView.swift
//  DSP Driver
//
//  Created by Admin on 13/10/21.
//  Copyright © 2021 baps. All rights reserved.
//

import UIKit

class DutyOnOffView: UIView {

    //MARK:- ====== Outlets =======
    @IBOutlet weak var btnSeeMore: UIButton!
    @IBOutlet weak var switchBtn: UISwitch!
    @IBOutlet weak var lblEarning: ThemeLabel!
    @IBOutlet weak var lblTitle: ThemeLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupSeeMoreUI()
        updateUI()
        NotificationCenter.default.addObserver(self, selector: #selector(changeOnlineSwitch(notification: )), name: .updateOnlineSwitch, object: nil)
    }
    
    func setupSeeMoreUI() {
        let attr: [NSAttributedString.Key: Any] = [
            .font: UIFont.semiBold(ofSize: 12.0),
            .foregroundColor: UIColor.white.withAlphaComponent(0.6),
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributeString = NSMutableAttributedString(
            string: "See More",
            attributes: attr
        )
        btnSeeMore.setAttributedTitle(attributeString, for: .normal)
        switchBtn.layer.cornerRadius = switchBtn.frame.height / 2
    }
 
    @IBAction func btnActionSeeMore(_ sender: UIButton) {
        if let vc = self.parentViewController as? HomeViewController {
            vc.navigateToTotalEarning()
        }
    }
    
    
    @IBAction func btnActionDutyChange(_ sender: UISwitch) {
//        Singleton.shared.isDriverOnline.toggle()
//        if let vc = self.parentViewController as? HomeViewController{
//            vc.setRightSwitch()
//        }
//        updateUI()
    }
  
    @IBAction func btnActionOnOff(_ sender: CustomSwitch) {
        Singleton.shared.isDriverOnline = sender.isOn
        updateUI()
    }
    @IBAction func btnActionDutyOnOff(_ sender: UIButton) {
        if let vc: UIViewController = self.parentViewController {
    
            if let hVc = vc as? HomeViewController {
                hVc.GetBookingInfoData()
            }
        }
    }
    
    @objc func changeOnlineSwitch(notification: Notification) {
        updateUI()
    }
    
    func updateUI() {
//        self.switchBtn.setOn(Singleton.shared.isDriverOnline, animated: true)
        lblTitle.text = Singleton.shared.isDriverOnline ? "You're Online" : "You're Offline"
        lblEarning.text = "Ksh 0" //Singleton.shared.totalDriverEarning.toCurrencyString()
    }
}
