//
//  RiderRatingReviewVC.swift
//  DSP Driver
//
//  Created by Admin on 19/10/21.
//  Copyright © 2021 baps. All rights reserved.
//

import UIKit
import Cosmos

class RiderRatingReviewVC: BaseViewController {

    //MARK:- ===== Outlets =====
    @IBOutlet weak var viewRating: CosmosView!
    @IBOutlet weak var imgRider: UIImageView!
    @IBOutlet weak var lblTotalPrice: ThemeLabel!
    @IBOutlet weak var lblWaitingFees: ThemeLabel!
    @IBOutlet weak var lblDistance: ThemeLabel!
    @IBOutlet weak var lblTotalTime: ThemeLabel!
    @IBOutlet weak var lblWaitingTime: ThemeLabel!
    @IBOutlet weak var lblTripTime: ThemeLabel!
    @IBOutlet weak var lblRiderName: ThemeLabel!
    @IBOutlet weak var lblCustomerReting: ThemeLabel!
    @IBOutlet weak var lblShipperTitle: ThemeLabel!
    @IBOutlet weak var lvlTripTimeTitle: ThemeLabel!
    @IBOutlet weak var txtvReview: CustomViewOutlinedTxtView!
    @IBOutlet weak var lblWaitingTimeTitle: ThemeLabel!
    @IBOutlet weak var lblWaitingFeesTitle: ThemeLabel!
    @IBOutlet weak var lblDistanceTitle: ThemeLabel!
    @IBOutlet weak var lblEarningTitle: ThemeLabel!
    @IBOutlet weak var lblRateTitle: ThemeLabel!
    @IBOutlet weak var btnSubmit: ThemePrimaryButton!
    
    var completeTrip: CompeteTripData?
    private var bookingInfo: BookingInfo?
//    var id = ""
    var customerRating = ""
    //MARK:- ===== Vaariables ====
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewRating.rating = 0.0
//        self.completeTrip = Singleton.shared.CompleteTrip
        self.bookingInfo = Singleton.shared.bookingInfo
        Singleton.shared.CompleteTrip = nil
        setNavbar()
        dataSetup()
        self.localization()
      }
    
    //MARK:- ==== Set navigationBar ======
    func setNavbar(){
        setupNavigation(.normal(title: "Trip Completed".localized, leftItem: .back, hasNotification: false))
    }
    
    func localization(){
        self.lblShipperTitle.text = "\("Your Shipper".localized):"
        self.lvlTripTimeTitle.text = "\("Trip Time".localized):"
        self.lblWaitingTimeTitle.text = "\("Waiting Time".localized):"
        self.lblDistanceTitle.text = "\("Distance".localized):"
        self.lblWaitingFeesTitle.text = "\("Waiting Fees".localized):"
        self.lblEarningTitle.text = "\("Earning".localized):"
        self.lblRateTitle.text = "Rate your Shipper".localized
        self.btnSubmit.setTitle("Submit".localized, for: .normal)
        self.txtvReview.textArea.placeholder = "Additional Note".localized
        self.txtvReview.textArea.label.text = "Additional Note".localized
    }
    
    //MARK:- ====== btn Action Submit ======
    @IBAction func btnActionsubmit(_ sender: UIButton) {
        WebserviceCallReviewRating()
    }
    
    //MARK:- ==== data Setup ======
    func dataSetup(){
        guard let info = self.completeTrip else {
            return
        }
        lblDistance.text = info.distance.toDistanceString()
        if let tripTime = Int(info.tripDuration ?? "") {
            lblTripTime.text = tripTime.secondsToTimeFormat()
        }else {
            lblTripTime.text = "---"
        }
        lblRiderName.text = info.customerInfo.firstName + " " + info.customerInfo.lastName
        self.imgRider.sd_setImage(with: URL(string: NetworkEnvironment.baseImageURL + info.customerInfo.profileImage), completed: nil)
        if let tripTime = Int(info.waitingTime ?? "") {
            lblWaitingTime.text = tripTime.secondsToTimeFormat()
        }else {
            lblWaitingTime.text = "---"
        }
        lblTotalPrice.text = info.driverAmount.toCurrencyString()
        lblWaitingFees.text = info.waitingTimeCharge.toCurrencyString()
        if let waitingTime = Int(info.waitingTime), let tripTime = Int(info.tripDuration) {
            let totalTimeString = String(waitingTime + tripTime)
            let formatedText = totalTimeString.secondsToTimeFormate()
            lblTotalTime.text = formatedText
        } else {
            lblTotalTime.text = "--"
        }
        self.lblCustomerReting.text = info.customerInfo?.rating
    }
    
    //MARK:- ===== Webservice Call Review / Rating ======
    func WebserviceCallReviewRating(){
        Loader.showHUD(with: self.view)
        let reviewRatingRedModel = ReviewRatingReqModel()
        reviewRatingRedModel.booking_id = completeTrip?.id ?? ""
        reviewRatingRedModel.rating = "\(viewRating.rating)"
        reviewRatingRedModel.comment = txtvReview.textArea.textView.text ?? ""
        WebServiceCalls.addReviewRating(ReviewRatingModel:reviewRatingRedModel) {response, status in
            Loader.hideHUD()
            print(response)
            self.navigationController?.popViewController(animated: true)
        }
    }
}
