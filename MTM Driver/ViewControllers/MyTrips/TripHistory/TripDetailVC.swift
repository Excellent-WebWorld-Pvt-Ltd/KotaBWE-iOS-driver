//
//  TripDetailVC.swift
//  KotaBWE
//
//  Created by Harshit K on 11/01/23.
//  Copyright © 2023 Mayur iMac. All rights reserved.
//

import UIKit
import GoogleMaps
import Cosmos
import SwiftyJSON

class TripDetailVC: BaseViewController {
    
    
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var collectionImages: UICollectionView!
    @IBOutlet weak var viewPastInvoice: UIView!
    
    @IBOutlet weak var vwSlide: UIView!
    @IBOutlet weak var vwAcceptReject: UIView!
    @IBOutlet weak var vwHelp: UIView!
    @IBOutlet weak var vwPhoneMessage: UIView!
    
    @IBOutlet weak var vwSlider: MTSlideToOpenView!
    @IBOutlet weak var viewAccept: ThemeButton!
    @IBOutlet weak var btnCall: ThemeBorderedButton!
    @IBOutlet weak var btnMessage: ThemeBorderedButton!
    @IBOutlet weak var lblYouRated: ThemeLabel!
    @IBOutlet weak var driverRatingView: CosmosView!
    @IBOutlet weak var lblCustomerName: ThemeLabel!
    @IBOutlet weak var lblPickup: ThemeLabel!
    @IBOutlet weak var lblDropoff: ThemeLabel!
    @IBOutlet weak var lblTripId: ThemeLabel!
    @IBOutlet weak var lblTime: ThemeUnderlinedLabel!
    @IBOutlet weak var lblCargoWeight: ThemeLabel!
    @IBOutlet weak var lblItemQty: ThemeLabel!
    @IBOutlet weak var lblVehicleLoadType: ThemeLabel!
    @IBOutlet weak var lblVehicleName: ThemeLabel!
    @IBOutlet weak var lblPlateNumber: ThemeLabel!
    @IBOutlet weak var viewImages: UIView!
    @IBOutlet weak var lblTripTime: ThemeLabel!
    @IBOutlet weak var lblWaitingTime: ThemeLabel!
    @IBOutlet weak var lblTotalTime: ThemeLabel!
    @IBOutlet weak var lblDistance: ThemeLabel!
    @IBOutlet weak var lblTripPrice: ThemeLabel!
    @IBOutlet weak var lblEarnings: ThemeLabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var lblNotes: ThemeLabel!
    @IBOutlet weak var viewNotes: UIView!
    
    var isFromPast: Bool = true
    var mapView: GMSMapView?
    var objDetail : BookingHistoryResponse?
    var arrMarker = [GMSMarker]()
    var arrTruckImages = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSwipeView(vwSwipe: vwSlider)
        self.setupNavigation(.normal(title: "Trip Detail", leftItem: .back, hasNotification: false))
        setupUI()
        WebServiceCallTripDetail()
        setdata()
        setupData()
    }
    
    private func setupUI() {
        mapView = GMSMapView()
        guard let mapView = self.mapView else {
            return
        }
        mapView.isUserInteractionEnabled = false
        mapContainerView.addSubview(mapView)
        mapView.setAllSideContraints(.zero)
        viewPastInvoice.isHidden = !isFromPast
        btnCall.isHidden = isFromPast
        viewAccept.isHidden = isFromPast
        vwAcceptReject.isHidden = isFromPast
    }

    //MARK :- Other Function
    func setdata(){
        lblYouRated.text = isFromPast ? "You Rated" : "Your Rider"
        viewNotes.isHidden = objDetail?.notes != "" ? false : true
        lblNotes.text = objDetail?.notes
        if isFromPast{
            vwSlide.isHidden = true
            vwAcceptReject.isHidden = true
            btnCall.isHidden = true
            btnMessage.isHidden = false
        }else{
            let status = objDetail?.status
            if status == .pending {
                vwSlide.isHidden = true
                vwAcceptReject.isHidden = false
                btnCall.isHidden = true
                btnMessage.isHidden = true
            } else if status == .accepted {
                vwSlide.isHidden = false
                vwAcceptReject.isHidden = true
                btnCall.isHidden = false
                btnMessage.isHidden = false
            }else if status == .traveling{
                vwSlide.isHidden = true
                vwAcceptReject.isHidden = true
                btnCall.isHidden = true
                btnMessage.isHidden = true
            }
            if objDetail?.onTheWay == "1" {
                vwSlide.isHidden = true
            }
            driverRatingView.isHidden = true
        }
    }
    
    func setupData(){
        driverRatingView.isUserInteractionEnabled = false
        setupMapView(objDetail)
        lblPickup.text = objDetail?.pickupLocation
        lblDropoff.text = objDetail?.dropoffLocation
        lblTripId.text = "ID: \(objDetail?.id ?? "")"
        
        if !isFromPast, let time = objDetail?.pickupDateTime?.timeStampToDate() {
            lblTime.text = time.getDayDifferentTextWithTime()
        } else if isFromPast, let bookingTime = objDetail?.bookingTime?.timeStampToDate() {
            lblTime.text = bookingTime.getDayDifferentTextWithTime()
        } else {
            lblTime.text = "--"
        }
        
        lblCargoWeight.text = "\(objDetail?.cargoWeightKg ?? "") Kg"
        lblItemQty.text = objDetail?.itemQuantity
        lblVehicleLoadType.text = objDetail?.truckLoadType
        lblVehicleName.text = objDetail?.vehicleTypeName
        let platnumber = isFromPast ? objDetail?.vehiclePlateNumber : SessionManager.shared.userProfile?.responseObject.vehicleInfo.first?.plateNumber
        lblPlateNumber.text = "(\(platnumber ?? ""))"
        self.arrTruckImages = objDetail?.cargoImage ?? []
        if arrTruckImages.count > 0 {
            self.viewImages.isHidden = false
            self.collectionImages.reloadData()
        }else{
            self.viewImages.isHidden = true
        }
       
        if isFromPast {
                
                if let tripTime = Int(objDetail?.tripDuration ?? "") {
                    lblTripTime.text = tripTime.secondsToTimeFormat()
                }else {
                    lblTripTime.text = "---"
                }
                
                if let waitingTime = Int(objDetail?.waitingTime ?? "") {
                    lblWaitingTime.text = waitingTime.secondsToTimeFormat()
                }else {
                    lblWaitingTime.text = "---"
                }
                
                if let waitingTime = Int(objDetail?.waitingTime ?? ""), let tripTime = Int(objDetail?.tripDuration ?? "") {
                    let formatedText = (waitingTime + tripTime).secondsToTimeFormat()
                    lblTotalTime.text = formatedText
                } else {
                    lblTotalTime.text = "---"
                }

                let distance = objDetail?.distance ?? ""
                if distance.isEmpty {
                    lblDistance.text = "---"
                } else {
                    lblDistance.text = distance.toDistanceString()
                }
                
                let baseFare = objDetail?.baseFare ?? ""
                if baseFare.isEmpty {
                    lblTripPrice.text = "---"
                } else {
                    lblTripPrice.text = baseFare.toCurrencyString()
                }

                let grandTotal = objDetail?.driverAmount ?? ""
                if grandTotal.isEmpty {
                    lblEarnings.text = "---"
                } else {
                    lblEarnings.text = grandTotal.toCurrencyString()
                }
            }
        if objDetail?.status == .cancelled{
            viewPastInvoice.isHidden = true
        }
        lblCustomerName.text = (objDetail?.customerFirstName ?? "") + " " + (objDetail?.customerLastName ?? "")
        
         let imgurl = objDetail?.customerImage
        profileImg.setImageWithBaseImageUrl(byAdding: imgurl ?? "", isProfileImage: true)
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
        ChatviewController.isComingFromPast = self.isFromPast
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
                AlertMessage.showMessageForSuccess(response["message"].stringValue)
                self.vwSlide.isHidden = false
                self.vwAcceptReject.isHidden = true
                self.btnCall.isHidden = false
                self.btnMessage.isHidden = false
                self.driverRatingView.isHidden = true
                self.lblYouRated.text = "Your Rider"
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
                    self.driverRatingView.rating = rating?.toDouble() ?? 0.0
                }
                else {
                    self.driverRatingView.rating = 0.0
                }
            }
            else {
                self.driverRatingView.rating = 0.0
                //AlertMessage.showMessageForError(response["message"].stringValue)
            }
        }
    }
}


extension TripDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTruckImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCell", for: indexPath) as! ImagesCell
        cell.imgCargoPhotos.setImageWithUrl(byAdding: arrTruckImages[indexPath.row].stringValue)
        cell.imgCargoPhotos.contentMode = .scaleAspectFill
        cell.btnRemoveImage.isHidden = true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Index:\(indexPath.row)")
        self.openWebURL( arrTruckImages[indexPath.row].stringValue)
    }
    
    @objc func removeImage(sender: UIButton) {
//        self.selectedIndex = nil
//        self.arrImages.remove(at: sender.tag)
//        self.setImageCollectionViews()
//        collectionViewImages.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
}

class ImagesCell: UICollectionViewCell {
    
    @IBOutlet weak var imgCargoPhotos: UIImageView!
    @IBOutlet weak var btnRemoveImage: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        //viewBg.backgroundColor = .themeLightGray
    }
    
    @IBAction func btnRemoveImage(_ sender: UIButton) {
    }
}
extension TripDetailVC: MTSlideToOpenDelegate {
    
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
            if SocketIOManager.shared.socket.status == .connected {
                emitSocket_OnTheWayBookingRequest(param: param)
                self.navigationController?.popToRootViewController(animated: true)
            }else{
                SocketIOManager.shared.establishConnection()
                AlertMessage.showMessageForError("Something went wrong!")
            }
        }
    }
    
    func emitSocket_OnTheWayBookingRequest(param: [String : Any]) {
        SocketIOManager.shared.socketEmit(for: socketApiKeys.onTheWayBookingRequest.rawValue, with: param)
    }
    
}
