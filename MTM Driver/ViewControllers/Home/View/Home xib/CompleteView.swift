//
//  CompleteView.swift
//  Pappea Driver
//
//  Created by Apple on 12/08/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

class CompleteView: UIView {
    //MARK:- ===== Outlets =======
    @IBOutlet weak var submitButton: ThemeButton!
    @IBOutlet weak var lblGrandTotal: ThemeLabel!
    
    @IBOutlet weak var meesageLabel: ThemeLabel!
    @IBAction func btnOKAction(_ sender: UIButton) {
        if let vc: UIViewController = self.parentViewController {
            if let hVc = vc as? HomeViewController {
                hVc.CompleteTripToRatingReview(id: bookingId)
            }
        }
    }
    
    @IBAction func btnCancleClick(_ sender: Any) {
        if let vc: UIViewController = self.parentViewController {
            if let hVc = vc as? HomeViewController {
                hVc.getFirstView()
            }
        }
    }
    
    var bookingId = ""
    
    func setData(){
        guard let data = Singleton.shared.CompleteTrip else {
            return
        }
        meesageLabel.text = data.message
        let title = "Rate Now" //data.paymentType == "cash" ? "Payment Received" : "Rate Now"
        submitButton.setTitle(title, for: .normal)
        let totalAmmount = Double(data.grandTotal ?? "0")?.rounded(toPlaces: 2)
        let str = Currency + " " + "\(totalAmmount ?? 0.0)"
        self.lblGrandTotal.text = "Grand Total: " + str

    }

}
