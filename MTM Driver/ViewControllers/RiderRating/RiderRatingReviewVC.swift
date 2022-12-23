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
    @IBOutlet weak var txtReview: UITextView!
    
    private var completeTrip: CompeteTripData?
    private var bookingInfo: BookingInfo?
    //MARK:- ===== Vaariables ====
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewRating.rating = 0.0
        txtReview.font = FontBook.regular.font(ofSize: 15)
        self.completeTrip = Singleton.shared.CompleteTrip
        self.bookingInfo = Singleton.shared.bookingInfo
        Singleton.shared.CompleteTrip = nil
        Singleton.shared.bookingInfo = nil
        setNavbar()
        dataSetup()
      }
    
    //MARK:- ==== Set navigationBar ======
    func setNavbar(){
        setupNavigation(.normal(title: "You Have Reached", leftItem: .back, hasNotification: false))
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
        lblTripTime.text = info.tripDuration.secondsToTimeFormate()
        lblRiderName.text = info.customerInfo.firstName + " " + info.customerInfo.lastName
        self.imgRider.sd_setImage(with: URL(string: NetworkEnvironment.baseImageURL + info.customerInfo.profileImage), completed: nil)
        lblTotalPrice.text = info.driverAmount.toCurrencyString()
        lblWaitingTime.text = info.waitingTime.secondsToTimeFormate()
        lblWaitingFees.text = info.waitingTimeCharge.toCurrencyString()
        if let waitingTime = Int(info.waitingTime), let tripTime = Int(info.tripDuration) {
            let totalTimeString = String(waitingTime + tripTime)
            let formatedText = totalTimeString.secondsToTimeFormate()
            lblTotalTime.text = formatedText
        } else {
            lblTotalTime.text = "--"
        }
    }
    
    //MARK:- ===== Webservice Call Review / Rating ======
    func WebserviceCallReviewRating(){
        Loader.showHUD(with: self.view)
        let reviewRatingRedModel = ReviewRatingReqModel()
        reviewRatingRedModel.booking_id = bookingInfo?.id ?? ""
        reviewRatingRedModel.rating = "\(viewRating.rating)"
        reviewRatingRedModel.comment = txtReview.text ?? ""
        WebServiceCalls.addReviewRating(ReviewRatingModel:reviewRatingRedModel) {response, status in
            Loader.hideHUD()
            print(response)
            self.navigationController?.popViewController(animated: true)
        }
    }
}
