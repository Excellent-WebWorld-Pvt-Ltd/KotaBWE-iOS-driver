//
//  TripDetailsVC.swift
//  DSP Driver
//
//  Created by Harsh Dave on 25/10/21.
//  Copyright © 2021 baps. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import Cosmos


class TripDetailsVC: BaseViewController {

   //MARK:- ===== Outlets =======
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var vwSlider: MTSlideToOpenView!
    @IBOutlet weak var vwInvoice: UIView!
    @IBOutlet weak var vwSlide: UIView!
    @IBOutlet weak var vwAcceptReject: UIView!
    @IBOutlet weak var vwHelp: UIView!
    @IBOutlet weak var vwPhoneMessage: UIView!
    @IBOutlet weak var lblRated: ThemeLabel!
    @IBOutlet weak var vwCosmos: CosmosView!
    @IBOutlet weak var lblDropOfLocation: ThemeLabel!
    @IBOutlet weak var lblPickUpLocation: ThemeLabel!
    @IBOutlet weak var lblDateTime: ThemeUnderlinedLabel!
    @IBOutlet weak var lblID: ThemeLabel!
    @IBOutlet weak var lblTotalPrice: ThemeLabel!
    @IBOutlet weak var lblDistance: ThemeLabel!
    @IBOutlet weak var lblTotalTime: ThemeLabel!
    @IBOutlet weak var lblCustomerName: ThemeLabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
    
    //MARK:- ===== Variables =====
    var objDetail : BookingHistoryResponse?
    var mapView : GMSMapView!
    var isFromPast : Bool = false
    var isFromUpcoming : Bool = false
    var arrMarker = [GMSMarker]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        DataSetup()
//        WebServiceCallTripDetail()
        setdata()
        setUpSwipeView(vwSwipe: vwSlider)
        self.setupNavigation(.normal(title: "Trip Detail", leftItem: .back))
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = CGRect(x: 0, y: 0, width: self.mapContainerView.frame.width, height: self.mapContainerView.frame.height)
    }
    
  
    //MARK :- Other Function
    func setdata(){
        lblRated.text = isFromPast ? "You Rated" : "Your Rider"
        if isFromPast{
            vwInvoice.isHidden = false
            vwSlide.isHidden = true
            vwAcceptReject.isHidden = true
            vwPhoneMessage.isHidden = true
            
        }else if isFromUpcoming{
            
               let status = objDetail?.status
              if status == .pending {
                    vwSlide.isHidden = true
                    vwAcceptReject.isHidden = false
                    vwPhoneMessage.isHidden = true

            } else if status == .accepted {
                    vwSlide.isHidden = false
                    vwAcceptReject.isHidden = true
                    vwPhoneMessage.isHidden = false
                    
            } else if status == .traveling {
                    
            } else if status == .completed {

            }
            
            vwInvoice.isHidden = true
            vwCosmos.isHidden = true
            
        }
    }
    func setUpSwipeView(vwSwipe : MTSlideToOpenView) {
        vwSwipe.applyThemeStyle()
        vwSwipe.textLabel.text = "Slide To Go"
        vwSwipe.delegate = self
        
    }

    private func setupMapView(_ info: BookingHistoryResponse?) {
        mapView = GMSMapView()
        guard let mapView = self.mapView else {
            return
        }
        mapView.isUserInteractionEnabled = false
        mapContainerView.addSubview(mapView)
        mapView.setAllSideContraints(.zero)
        guard let pickUpLocation = CLLocationCoordinate2D(latString: info?.pickupLat, lngString: info?.pickupLng),
              let dropOffLocation = CLLocationCoordinate2D(latString: info?.dropoffLat, lngString: info?.dropoffLng) else {
            return
        }

        let pickupMarker = GMSMarker(position: pickUpLocation)
        pickupMarker.icon = AppImages.locationPulseSmall.image
        pickupMarker.map = mapView
        // NOTE: - To make marker center to point, default it would be bottom to the point
        pickupMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)

        let dropMarker = GMSMarker(position: dropOffLocation)
        dropMarker.icon = AppImages.locationDropPulse.image
        dropMarker.map = mapView
        dropMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        drawRoutePolyline(origin: pickUpLocation, destination: dropOffLocation)
    }

    func drawRoutePolyline(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        WebService.getGoogleMapDirections(origin: origin.stringValue,
                                          destination: destination.stringValue) { response, status in
            guard status == true else {
                print("error while drawing route")
                return
            }

            guard let dictionary = response.dictionaryObject else {
                return
            }
            self.drawRoute(routeDict: dictionary)
        }
    }

    func drawRoute(routeDict: Dictionary<String, Any>) {

        let routesArray = routeDict ["routes"] as! NSArray

        if (routesArray.count > 0) {
            let routeDict = routesArray[0] as! Dictionary<String, Any>
            let routeOverviewPolyline = routeDict["overview_polyline"] as! Dictionary<String, Any>
            let points = routeOverviewPolyline["points"]
            let path = GMSPath.init(fromEncodedPath: points as! String)!
            let polyline = GMSPolyline(path: path)
            polyline.strokeColor = .themeColor
            polyline.strokeWidth = 4.0
            polyline.map = self.mapView
            let bounds = GMSCoordinateBounds(path: path)
            let camera = mapView!.camera(for: bounds, insets: .init(top: 40, left: 40, bottom: 40, right: 40))!
            mapView?.camera = camera
        }
    }

   
    func DataSetup(){
        vwCosmos.isUserInteractionEnabled = false
        setupMapView(objDetail)
        lblPickUpLocation.text = objDetail?.pickupLocation
        lblDropOfLocation.text = objDetail?.dropoffLocation
        lblID.text = "ID: \(objDetail?.id ?? "")"
        lblTotalTime.text = objDetail?.tripDuration.secondsToTimeFormate()
        
        lblDistance.text = objDetail?.distance.toDistanceString() ?? "-"
        lblTotalPrice.text = objDetail?.driverAmount.toCurrencyString() ?? "-"
        lblCustomerName.text = (objDetail?.customerFirstName ?? "") + " " + (objDetail?.customerLastName ?? "")
        
         let imgurl = objDetail?.customerImage
        imgProfile.setImageWithBaseImageUrl(byAdding: imgurl ?? "", isProfileImage: true)
        
        let str =   "\(objDetail?.acceptTime.timeStampToDate() ?? Date())"
        let arrState = str.components(separatedBy: " ")
       // vwCosmos.rating = objDetail
        
        if isFromUpcoming == true {
            if let dateStr = objDetail?.pickupDateTime {
                print(dateStr.timeStampToDate()?.getDayDifferentTextWithTime() ?? "")
                lblDateTime.text = dateStr.timeStampToDate()?.getDayDifferentTextWithTime()
                lblDateTime.isHidden = false
            } else {
                lblDateTime.isHidden = true
            }
        }
        else {
            
            if let date = DateFormatHelper.standard.getDate(from:"\(arrState[0]) \(arrState[1])") {
                lblDateTime.text = date.getDayDifferentTextWithTime()
            } else {
                lblDateTime.text =  ""
            }
        }

        
        //        lblDateTime.isHidden = (objDetail?.acceptTime ?? "").isEmpty
//        lblDistance.isHidden = (objDetail?.distance ?? "").isEmpty
//        lblTotalPrice.isHidden = (objDetail?.grandTotal ?? "").isEmpty
    }
    
    @IBAction func btnActionCall(_ sender: Any) {
        let contactNumber = objDetail?.customerMobileNumber
        if contactNumber == "" {
            UtilityClass.showAlert(message: "Contact number is not available")

        } else {
            UtilityClass.callNumber(phoneNumber: contactNumber ?? "")
        }
    }
    
    
    @IBAction func btnActionMessage(_ sender: UIButton) {
        
        let ChatviewController: ChatVC = UIViewController.viewControllerInstance(storyBoard: .myTrips)
        ChatviewController.strBookingId = objDetail?.id ?? ""
        ChatviewController.receiverId =  objDetail?.customerId ?? ""
        ChatviewController.receiverName = "\(objDetail?.customerFirstName ?? "") \(objDetail?.customerLastName ?? "")"
        guard let url = objDetail?.customerImage else { return }
        ChatviewController.receiverImage = "\(NetworkEnvironment.baseImageURL + url)"
        
        self.navigationController?.pushViewController(ChatviewController, animated: true)
        
    }
    
    
    @IBAction func btnActionHelp(_ sender: UIButton) {
        let viewCtr = AppViewControllers.shared.help
        self.push(viewCtr)
    }
    
    //MARK :- Action
    @IBAction func btnAccept(_ sender: Any) {
        webserviceCallAceptBookLater()
    }
    @IBAction func btnInvoiceClick(_ sender: Any) {
        let TripInvoiceVC : TripInvoiceVC = UIViewController.viewControllerInstance(storyBoard: .tripDetails)
        TripInvoiceVC.objBooking = objDetail
        self.navigationController?.pushViewController(TripInvoiceVC, animated: true)
    }

    
    //MARK:- ===== Webservice Call Accept Book Later =======
    func webserviceCallAceptBookLater(){
        Loader.showHUD(with: self.view)
        let reqModel = acceptBookLaterRequestModel()
        reqModel.booking_id = objDetail?.id ?? ""
        reqModel.driver_id = Singleton.shared.userProfile?.responseObject.id ?? ""
        WebServiceCalls.acceptBookLater(bookLaterReqModel: reqModel) { response, status in
            Loader.hideHUD()
            if status {
                print(response)
                self.vwInvoice.isHidden = true
                self.vwSlide.isHidden = false
                self.vwAcceptReject.isHidden = true
                self.vwPhoneMessage.isHidden = false
                self.vwCosmos.isHidden = true
                self.lblRated.text = "Your Rider"
            }
            else {
                AlertMessage.showMessageForError(response["message"].stringValue)
            }
        }
    }
    
    //MARK:- ====== Trip Detail Api implementation ======
    func WebServiceCallTripDetail(){
        Loader.showHUD(with: self.view)
        WebServiceCalls.TripDetail(strURL: objDetail?.id ?? "") { response, status  in
            Loader.hideHUD()
            if status {
                print(response)
                let data = response["data"].dictionary
                if !(data?["rating"]?.stringValue.isEmpty ?? false){
                    let rating = data?["rating"]?.stringValue
                    self.vwCosmos.rating = rating?.toDouble() ?? 0.0
                }
                else {
                    self.vwCosmos.rating = 0.0
                }
            }
            else {
                self.vwCosmos.rating = 0.0
                //AlertMessage.showMessageForError(response["message"].stringValue)
            }
        }
    }
}
extension TripDetailsVC: MTSlideToOpenDelegate {
    
    func mtSlideToOpenDelegateDidFinish(_ sender: MTSlideToOpenView) {
        guard let bookingData = objDetail else { return }
        if Singleton.shared.isDriverOnline == false {
            let message = "You're currenty offline, please get online before go for the ride."
            ThemeAlertVC.present(from: self, ofType: .simple(message: message))
            sender.resetStateWithAnimation(true)
        } else if let bookingId = Singleton.shared.bookingInfo?.id,
                  bookingId.isEmpty == false,
                  bookingData.id != bookingId {
            let message = "You're already on your trip, first finish your trip."
            ThemeAlertVC.present(from: self, ofType: .simple(message: message))
            sender.resetStateWithAnimation(true)
        } else {
            var param = [String: Any]()
            param["driver_id"] = Singleton.shared.driverId
            param["booking_id"] = bookingData.id
            emitSocket_OnTheWayBookingRequest(param: param)
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func emitSocket_OnTheWayBookingRequest(param: [String : Any]) {
        SocketIOManager.shared.socketEmit(for: socketApiKeys.onTheWayBookingRequest.rawValue, with: param)
    }
    
}
