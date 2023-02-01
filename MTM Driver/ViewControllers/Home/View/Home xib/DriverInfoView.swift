//
//  DriverInfoView.swift
//  Pappea Driver
//
//  Created by EWW-iMac Old on 03/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import GooglePlaces

enum TripStatus {
    case request
    case startRide
    case accepted
    case arrived
    case complete
    
    func setTitle()->String{
        switch self {
        case .request:
           return "Slide To Accept"
        case .arrived :
           return "Arrived"
        case .startRide :
            return "Start Ride"
        case .complete :
            return "Complete"
        case .accepted :
            return "accepted"
        }
    }
}

class DriverInfoView: UIView
{
    // ----------------------------------------------------
    // MARK: - Outlets
    // ----------------------------------------------------
    @IBOutlet weak var viewPhonChat: UIView!
    @IBOutlet weak var ViewWithInMiles: UIView!
    @IBOutlet weak var viewRequestButton: MTSlideToOpenView!
    @IBOutlet weak var viewRequestTrip: UIView!
    @IBOutlet weak var viewBtnCompleteTrip: MTSlideToOpenView!
    @IBOutlet weak var viewBtnStartRide: MTSlideToOpenView!
    @IBOutlet weak var viewBtnArrivedTrip: MTSlideToOpenView!
    @IBOutlet weak var lblLocationTitle: ThemeLabel!
    @IBOutlet weak var ViewSOS: UIView!
//    @IBOutlet weak var txtPickup: SkyFloatingLabelTextField!
    @IBOutlet weak var iconDriverProfilePic: UIImageView!
    @IBOutlet weak var lblDriverName: UILabel!
//    @IBOutlet weak var lblkDriverRole: UILabel!
//    @IBOutlet weak var iconDriverVehicle: UIImageView!
//    @IBOutlet weak var lblTotalEarning: UILabel!
//    @IBOutlet weak var lblTotleJobs: UILabel!
    @IBOutlet weak var lblDriverRatings: UILabel!
//    @IBOutlet weak var lblVehicleNumber: UILabel!
//    @IBOutlet weak var lblVehicleName: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    //@IBOutlet weak var viewBtnCancel: UIView!
    @IBOutlet weak var lblMin: ThemeLabel!
    @IBOutlet weak var lblMiles: ThemeLabel!
    @IBOutlet weak var lblTime: ThemeLabel!
    @IBOutlet weak var lblDate: ThemeLabel!
    @IBOutlet weak var lblEarning: ThemeLabel!
    @IBOutlet weak var lblPickup: ThemeLabel!
    @IBOutlet weak var btnSos: UIButton!
    @IBOutlet weak var conWidthOfViewSoS: NSLayoutConstraint!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var lblCargoWeight: ThemeLabel!
    @IBOutlet weak var lblLoadType: ThemeLabel!
    @IBOutlet weak var stackVIewMiles: UIStackView!
    @IBOutlet weak var lblItemQuantity: ThemeLabel!
    @IBOutlet weak var bottomContraintView: NSLayoutConstraint!
    
    // ----------------------------------------------------
    // MARK: - Globle Declaration Methods
    // ----------------------------------------------------
    var placesClient = GMSPlacesClient()
    var complition:(()->())?
    var chatClicked : (()->())?
    var callClicked : (()->())?
    var sosBtnClicked : (()->())?
    var strTripStatusTitle = ""
    var isArrived = Bool()
    var isStartTrip = Bool()
    var isAccepted = Bool()
    
    var driverState : DriverState = .duty {
        didSet {
            strTripStatusTitle = driverState.setTitle()
            switch driverState {
            case .request:
               // ViewSOS.isHidden = true
               // btnSos.isHidden = true
             //   conWidthOfViewSoS.constant = 0
                setUpSwipeView(vwSwipe: viewRequestButton)
                lblLocationTitle.text = "Pickup"
                getRequest(isrequest:false)
                viewRequestTrip.isHidden = false
                viewBtnArrivedTrip.isHidden = true
                viewBtnStartRide.isHidden = true
                viewBtnCompleteTrip.isHidden = true
            case .arrived :
             //   conWidthOfViewSoS.constant = 0
              //  ViewSOS.isHidden = true
             //   btnSos.isHidden = true
                getRequest(isrequest:true)
                lblLocationTitle.text = "Pickup"
                setUpSwipeView(vwSwipe: viewBtnStartRide)
                viewRequestTrip.isHidden = true
                viewBtnArrivedTrip.isHidden = true
                viewBtnStartRide.isHidden = false
                viewBtnCompleteTrip.isHidden = true
            case .requestAccepted :
             //   conWidthOfViewSoS.constant = 0
                getRequest(isrequest:true)
              //  ViewSOS.isHidden = true
             //   btnSos.isHidden = true
                lblLocationTitle.text = "Pickup"
                setUpSwipeView(vwSwipe: viewBtnArrivedTrip)
                viewRequestTrip.isHidden = true
                viewBtnArrivedTrip.isHidden = false
                print("showing the view")
                viewBtnStartRide.isHidden = true
                viewBtnCompleteTrip.isHidden = true
            //case .tripComplete :
//                getRequest(isrequest:true)
//                setUpSwipeView(vwSwipe: viewBtnCompleteTrip)
//                viewRequestTrip.isHidden = true
//                viewBtnArrivedTrip.isHidden = true
//                viewBtnStartRide.isHidden = true
//                viewBtnCompleteTrip.isHidden = false
            case .inTrip :
//                conWidthOfViewSoS.constant = 60
              //  ViewSOS.isHidden = false
               // btnSos.isHidden = false
                //getRequest(isrequest:true)
                lblLocationTitle.text = "Drop-off"
                setUpSwipeView(vwSwipe: viewBtnCompleteTrip)
                viewRequestTrip.isHidden = true
                viewBtnArrivedTrip.isHidden = true
                viewBtnStartRide.isHidden = true
                viewBtnCompleteTrip.isHidden = false
                viewPhonChat.isHidden = true
            default:
                break
            }
        }
    }
    
    
    // ----------------------------------------------------
    // MARK: - Base Methods
    // ----------------------------------------------------
    override func draw(_ rect: CGRect) {
       // setPickupField()
//        self.iconDriverProfilePic.layer.cornerRadius = self.iconDriverProfilePic.frame.width / 2
//        self.iconDriverProfilePic.layer.masksToBounds = true
//        self.iconDriverVehicle.layer.cornerRadius = self.iconDriverVehicle.frame.width / 2
//        self.iconDriverVehicle.layer.masksToBounds = true
    }

    func getRequest(isrequest:Bool){
         ViewWithInMiles.isHidden = false
        stackVIewMiles.isHidden = isrequest
         viewPhonChat.isHidden = !isrequest
    }
    
    
    func setUpSwipeView(vwSwipe : MTSlideToOpenView) {
        self.bringSubviewToFront(vwSwipe)
        vwSwipe.textLabel.text = strTripStatusTitle
        vwSwipe.delegate = self
        vwSwipe.applyThemeStyle()
        //playAnimation()
    }
    
    //MARK:- === Btn Action Call ======
    @IBAction func btnActionCall(_ sender: UIButton) {
        if let vc: UIViewController = self.parentViewController {
            if let hVc = vc as? HomeViewController {
                hVc.callAction()
            }
        }
    }
    
    
    //MARK:- ===== Btn Action SOS =====
    @IBAction func btnActionSOS(_ sender: UIButton) {
        UtilityClass.dialNumber(number: Singleton.shared.sosNumber)
    }
    
    
    //btn Action Cancel
    @IBAction func btnCancelAction(_ sender: UIButton) {
        print(#function)
       // setConstraintOfHomeVc()
        //setDeiverInfoView()
        RingManager.shared.stopSound()
        if let vc = self.parentViewController as? HomeViewController{
            vc.cancelTripAfterAccept()
        } else {
            Singleton.shared.bookingInfo = nil
        }
    }
    
    // Reject Btn Action
    @IBAction func btnRejectAction(_ sender: UIButton) {
        print(#function)
        //setConstraintOfHomeVc()
       // setRequestRejectedView()
        
        guard let bookingId = Singleton.shared.bookingInfo?.id else { return }
        Singleton.shared.bookingInfo = nil
        RingManager.shared.stopSound()
        if let vc = self.parentViewController as? HomeViewController {
            vc.timerProgressRequest?.invalidate()
            vc.count = 0
            vc.progressRequest.progress = 0.0
            vc.progressRequest.isHidden = true
            vc.emitSocket_RejectRequest(bookingId: bookingId)
        }
    }
    
    @IBAction func btnActionChat(_ sender: UIButton) {
        
        if let vc: UIViewController = self.parentViewController {
            if let hVc = vc as? HomeViewController {
                hVc.ChatScreen()
            }
        }
//        if let clicked = chatClicked {
//            clicked()
//        }
    }
    // ----------------------------------------------------
    // MARK: - Custom Methods
    // ----------------------------------------------------
//    private func setPickupField()
//    {
//        let height = 16
//        let padding = 6
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: height + padding, height: height))
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: height, height: height))
//        view.addSubview(imageView)
//        imageView.image = UIImage(named: "calendar")
//        txtPickup.leftView = view
//        txtPickup.leftViewMode = .always
//    }
//
    
    //MARK:- ==== Set Data Of Driver =====
    func setDriverData(status:DriverState){
        let loginData = SessionManager.shared.userProfile
        let parameter = loginData?.responseObject

        secondView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        secondView.layer.cornerRadius = 30
        driverState = status
        self.lblDriverName.text = Singleton.shared.bookingInfo?.name
        let totalEarning = Double(Singleton.shared.bookingInfo?.estimatedFare ?? "0")?.rounded(toPlaces: 2)
        self.lblCargoWeight.text = "Cargo weight: \(Singleton.shared.bookingInfo?.cargoWeightKg ?? "")"
        self.lblItemQuantity.text = "Item quantity: \(Singleton.shared.bookingInfo?.itemQuantity ?? "")"
        self.lblLoadType.text = "Truck load type: \(Singleton.shared.bookingInfo?.truckLoadType ?? "")"
        lblMiles.text = Singleton.shared.bookingInfo?.distance
        lblMin.text = "\(Singleton.shared.bookingInfo?.estimatedTime ?? "") Mins"
         //Double(loginData?.bookingInfo?.totalDriverEarning ?? "0")?.rounded(toPlaces: 2)
        let str =   "\(Singleton.shared.bookingInfo?.bookingTime.timeStampToDate() ?? Date())"
        let arrState = str.components(separatedBy: " ")
        if let date = DateFormatHelper.standard.getDate(from:"\(arrState[0]) \(arrState[1])") {
            let strFormatter = DateFormatHelper.fullDateTime.getDateString(from: date)
            print(strFormatter)
            let arrDateTime = strFormatter.components(separatedBy: ", ")
            lblDate.text = arrDateTime[0]
            lblTime.text = arrDateTime[1]
        } else {
            
        }
        self.lblEarning.text = Currency + " " + "\(totalEarning ?? 0.0)"
        self.lblDriverRatings.text = parameter?.rating

        self.iconDriverProfilePic.sd_setImage(with: URL(string: NetworkEnvironment.baseImageURL + (Singleton.shared.bookingInfo?.customerInfo.profileImage ?? "")), completed: nil)

        lblPickup.text = status == .inTrip ? Singleton.shared.bookingInfo?.dropoffLocation :  Singleton.shared.bookingInfo?.pickupLocation
        if let homeVC = self.parentViewController as? HomeViewController {
            homeVC.driverData.driverState = status
            Singleton.shared.bookingInfo?.statusEnum
            homeVC.resetMap()
        }
    }
    
  
    //MARK:- ===== Get Current Place =====
    func getCurrentPlace(){
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if error != nil {
                print ("Pick Place error: \(error?.localizedDescription ?? "Error")")
                return
            }

            //self.nameLabel = "No current place"
             self.lblPickup.text = ""

            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if place != nil {
                    // self.nameLabel = place.name
                    // self.addressLabel = (place.formattedAddress?.components(separatedBy: ", ").joined(separator: "\n"))!
                }
            }

            if let placeLikelihoodList = placeLikelihoodList
            {
                for likelihood in placeLikelihoodList.likelihoods
                {
                    let place = likelihood.place
                    print(place.formattedAddress ?? "")
                    self.lblPickup.text = place.formattedAddress

                }
            }

        })
    }
}

extension DriverInfoView: MTSlideToOpenDelegate {
    
    func mtSlideToOpenDelegateDidFinish(_ sender: MTSlideToOpenView) {
        RingManager.shared.stopSound()
        switch driverState {
        
        case .request :
            driverState = .arrived
            guard let bookingData = Singleton.shared.bookingInfo else { return }
            var param = [String: Any]()
            param["driver_id"] = Singleton.shared.driverId
            param["booking_id"] = bookingData.id
            param["booking_type"] = bookingData.bookingType
            
            if let vc: UIViewController = self.parentViewController {
                if let hVc = vc as? HomeViewController {
                    hVc.emitSocket_AcceptRequest(param: param)
                    hVc.trackTrip()
                }
            }
            
        case .requestAccepted:
            driverState = .arrived
            guard let bookingData = Singleton.shared.bookingInfo else { return }
            var param = [String: Any]()
           
            param["booking_id"] = bookingData.id
            
            if let vc: UIViewController = self.parentViewController {
                if let hVc = vc as? HomeViewController {
                    hVc.emitSocket_DriverArrivedAtPickupLocation(param: param)
                    hVc.trackTrip()
                }
            }
            
        case .arrived :
            driverState = .inTrip
            isAccepted = false
            isArrived = false
            isStartTrip = true
    //        setArrivedView()
    //        setCompleteTripView()
            
            guard let bookingData = Singleton.shared.bookingInfo else { return }
            var param = [String: Any]()
            param["booking_id"] = bookingData.id
            
            if let vc: UIViewController = self.parentViewController {
                if let hVc = vc as? HomeViewController {
                    hVc.emitSocket_StartTrip(param: param)
                    hVc.trackTrip()
                }
            }
        case .inTrip :
            driverState = .tripComplete
            if let vc = ((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.children)?.first?.children.first as? HomeViewController {
                guard let location = Singleton.shared.driverLocation else {
                    LocationManager.shared.openSettingsDialog()
                    return
                }
                var param = [String: Any]()
                param["booking_id"] = Singleton.shared.bookingInfo?.id
                param["dropoff_lat"] = "\(location.latitude)"
                param["dropoff_lng"] = "\(location.longitude)"
                vc.webserviceCallForCompleteTrip(dictOFParam: param as AnyObject)
             }
            
//            guard let bookingData = Singleton.shared.bookingInfo else { return }
//            var param = [String: Any]()
//            param["booking_id"] = bookingData.id
//
//            if let vc = ((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.children)?.first?.children.first as? HomeViewController {
//                vc.emitSocket_AskForTips(param: param)
//            }

        case .tripComplete :
            print(#function)
            
           // setConstraintOfHomeVc()
           // setDeiverInfoView()
        default:
            break
        }
    }
}
