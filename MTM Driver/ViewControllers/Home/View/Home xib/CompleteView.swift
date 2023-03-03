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
    @IBOutlet weak var lblTitle: ThemeLabel!
    
    @IBOutlet weak var meesageLabel: ThemeLabel!
    @IBAction func btnOKAction(_ sender: UIButton) {
        if let vc: UIViewController = self.parentViewController {
            if let hVc = vc as? HomeViewController {
                hVc.CompleteTripToRatingReview(bookingDetail: bookingDetail)
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
    
    var bookingDetail : CompeteTripData?
    
    func setData(){
        guard let data = Singleton.shared.CompleteTrip else {
            return
        }
        self.lblTitle.text = "Trip Completed!".localized
        meesageLabel.text = data.message
        let title = "Rate Now".localized //data.paymentType == "cash" ? "Payment Received" : "Rate Now"
        submitButton.setTitle(title, for: .normal)
        let str = "\(Currency) \(data.grandTotal ?? "0.00")"
        self.lblGrandTotal.text = "\("Grand Total".localized): \(str)"

    }

}
