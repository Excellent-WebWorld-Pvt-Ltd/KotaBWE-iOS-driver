//
//  HomeViewController.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 29/04/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import SideMenuSwift
import CoreLocation
import GoogleMaps


enum setupGMSMarker {
    case from
    case to
}

class HomeViewController: BaseViewController {

    // ----------------------------------------------------
    // MARK: - Outlets
    // ----------------------------------------------------
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnTopHeader: UIButton!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var offlineView: UIView!
    @IBOutlet weak var constantHeightOfOfflineView: NSLayoutConstraint! // 60
    @IBOutlet weak var progressRequest: UIProgressView!
    @IBOutlet weak var viewWaitingTime: UIView!
    @IBOutlet weak var lblwaiting: ThemeLabel!
    @IBOutlet weak var lblTitleWaiting: ThemeLabel!
    
    
//    @IBOutlet weak var viewProgress: UIView!
    @IBOutlet weak var mapContainerView : UIView!
    @IBOutlet var bottomContentView: UIView!
    let progress = Progress(totalUnitCount: 10)
    var mapView : GMSMapView!
    var LoginDetail : LoginModel = LoginModel()
    var addCardReqModel : AddCardRequestModel = AddCardRequestModel()
    var CardListReqModel : CardList = CardList()
    var driverData = DriverData.shared
    var bookingData = BookingInfo()
    let carMovement = ARCarMovement()
    var driverMarker : GMSMarker?
    var destinationMarker : GMSMarker?
    var completeTripData : BookingInfo?
    var lastLocation: CLLocation?
    var arrMarkers = [GMSMarker]()
    var polyline: GMSPolyline?
    var oldCoordinate: CLLocationCoordinate2D!
    var originalRouteCoordinates : [CLLocationCoordinate2D] = []
    var routeCoordinates : [CLLocationCoordinate2D] = []
    // ----------------------------------------------------
    // MARK: - Globle Declaration Methods
    // ----------------------------------------------------
    var count: Double = 0
    var timerProgressRequest: Timer?
    var presentType = DriverState.available
    var presentView: UIView?
    var index = Int()
    var tempView = UIView()
    var locationUpdateTimer : Timer?
    var isFirstTimeLaunch = true
    var waitingTime = Double()
    var baseFare = Double()
    var minKM = Double()
    var perKMCharge = Double()
    var waitingChargePerMinute = Double()
    var bookingFee = Double()
    var strVehicleName = String()
    var strWaitingTime = String()
    var isCameraAnimation = false
    // var counter = 0.0

   
    // ----------------------------------------------------
    // MARK: - Base Methods
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeNotification()
//        if Singleton.shared.isDriverOnline {
            SocketIOManager.shared.establishConnection()
//        }
        getFirstView()
        LocationManager.shared.delegate = self
        if Singleton.shared.bookingInfo != nil {
            self.bookingData = Singleton.shared.bookingInfo ?? BookingInfo()
        }
        viewWaitingTime.isHidden = true
        viewWaitingTime.layer.cornerRadius = viewWaitingTime.frame.height / 2
        viewWaitingTime.clipsToBounds = true
        setupGoogleMaps()
        progressRequest.isHidden = true
        btnTopHeader.addTarget(self, action: #selector(hideBottomView(_:)), for: .touchUpInside)
        
        self.mapView.settings.consumesGesturesInView = false
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panHandler(_:)))
        self.mapView.addGestureRecognizer(panGesture)
        setNavbar()
        self.checkMeterStatus()
        self.setupCurrentLocation()
        updateLocation()
        Loader.showHUD()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            Loader.hideHUD()
            self.checkLicenseExpiry()
        }
//        self.allSocketOnMethods()
    }
    
    @objc private func panHandler(_ pan : UIPanGestureRecognizer){
            if pan.state == .ended && isCameraAnimation == true{
                isCameraAnimation = false
            }
    }
    
    //MARK: ===== start timer for update location =======
    @objc func startTimer() {
        locationUpdateTimer?.invalidate()
        locationUpdateTimer = nil
        locationUpdateTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(updateDriverLocationAtRegularInterval), userInfo: nil, repeats: true)
    }
    
    @objc func endTimer(){
        locationUpdateTimer?.invalidate()
        locationUpdateTimer = nil
     }
    
    @objc private func updateDriverLocationAtRegularInterval() {
        if  SocketIOManager.shared.isConnected {
            if let bookingInfo = Singleton.shared.bookingInfo,
               (bookingInfo.status == "accepted" || bookingInfo.status == "traveling") {
                self.trackTrip()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerTopView.roundCorners([.topLeft, .topRight], radius: 12)
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.masksToBounds = false
        mapView.frame = CGRect(x: 0, y: 0, width: self.mapContainerView.frame.width, height: self.mapContainerView.frame.height)
    }
    
    func checkLicenseExpiry(){
        if Singleton.shared.documentExpiry != ""{
            ThemeAlertVC.present(from: self, ofType: .simple(message: Singleton.shared.documentExpiry))
        }
    }
    
    func HideShowWaiting(isStartWaiting:Bool,Hidden:Bool) {
        if isStartWaiting {
            viewWaitingTime.isHidden = false
            lblTitleWaiting.text = "Start Waiting"
            lblwaiting.isHidden = false
        }
        else if isStartWaiting == false && Hidden == true {
            viewWaitingTime.isHidden = true
        }
        else {
            viewWaitingTime.isHidden = false
            lblwaiting.isHidden = true
            lblTitleWaiting.text = "Stop Waiting"
        }
    }
    
     func callAction() {
         let contactNumber = bookingData.customerInfo?.mobileNo
        if contactNumber == "" {
            UtilityClass.showAlert(message: "Contact number is not available".localized)
        } else {
            UtilityClass.callNumber(phoneNumber: contactNumber ?? "")
        }
    }

    func GetBookingInfoData(){
        self.presentView(forState: .available)
    }
    
    
    //MARK:- ==== Navigate to Total Earning =====
    func navigateToTotalEarning(){
        let vc: EarningVC = UIViewController.viewControllerInstance(storyBoard: .payment)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- ===== Navigate to Total Rating/Review ======
    func CompleteTripToRatingReview(bookingDetail : CompeteTripData?){
        self.getFirstView()
        let vc: RiderRatingReviewVC = UIViewController.viewControllerInstance(storyBoard: .completedTrip)
        vc.completeTrip = bookingDetail
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- ==== chat sCreen navigation =====
    func ChatScreen(){
        let ChatviewController: ChatVC = UIViewController.viewControllerInstance(storyBoard: .myTrips)
        ChatviewController.strBookingId = bookingData.id
        ChatviewController.receiverId =  bookingData.customerId ?? ""
        ChatviewController.receiverName = "\(bookingData.customerInfo?.firstName ?? "") \(bookingData.customerInfo?.lastName ?? "")"
        ChatviewController.receiverImage = "\(NetworkEnvironment.baseImageURL + (bookingData.customerInfo?.profileImage ?? ""))"
        
        self.navigationController?.pushViewController(ChatviewController, animated: true)
    }
    
    func setupGoogleMaps() {
        mapView = GMSMapView(frame: mapContainerView.bounds)
        mapView.settings.rotateGestures = false
        mapView.settings.tiltGestures = false
        mapView.isMyLocationEnabled = false
        mapView.settings.myLocationButton = false
        
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "styleMap", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }

        mapContainerView.addSubview(mapView)
    }
    
    func getDateDifference(){
        let str =   "\(Singleton.shared.meterInfo?.startedTime.timeStampToDate() ?? Date())"
        let arrState = str.components(separatedBy: " ")
        if let date = DateFormatHelper.standard.getDate(from:"\(arrState[0]) \(arrState[1])") {
           let strFormatter = DateFormatHelper.standard.getDateString(from: date)
           print(strFormatter)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formatedStartDate = dateFormatter.date(from: strFormatter)
        let currentDate = Date()
        let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .month, .year])
        let differenceOfDate = Calendar.current.dateComponents(components, from: formatedStartDate!, to: currentDate)
            print (differenceOfDate)
        }
            
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Singleton.shared.isDriverOnline != false {
            //startTimer()
        }
        SideMenuController.preferences.basic.enablePanGesture = true
        setNavbar()
    }

    // ----------------------------------------------------
    // MARK: - Actions
    // ----------------------------------------------------
    
    @IBOutlet weak var viewLine: UIView!{
        didSet{
            viewLine.layer.cornerRadius = 2
            viewLine.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var containerTopView: UIView!{
        didSet {
            let directions: [UISwipeGestureRecognizer.Direction] = [.up, .down]
            for direction in directions {
                let gesture = UISwipeGestureRecognizer(target: self, action: #selector(panAction(_:)))
                gesture.direction = direction
                containerTopView.addGestureRecognizer(gesture)
            }
            containerTopView.isUserInteractionEnabled = true
            containerTopView.layoutIfNeeded()
        }
    }
    
    @IBAction func btnCurrentLocation(_ sender: UIButton){
        if LocationManager.shared.isAlwaysPermissionGranted(){
            isCameraAnimation = true
            setupCurrentLocation()
        }
    }
    
    //MARK:- === Call To Customer =====
    func CallBtnAction(){
        UtilityClass.callNumber(phoneNumber:bookingData.customerInfo?.mobileNo ?? "")
    }
    
    
    func setupCurrentLocation(){
        guard let driverLocation = Singleton.shared.driverLocation else {
            LocationManager.shared.openSettingsDialog()
            return
        }
        let camera = GMSCameraPosition.camera(withLatitude: driverLocation.latitude,
                                                  longitude: driverLocation.longitude,
                                                  zoom: zoomLevel)

            mapView.camera = camera
    }
    
    
    // ----------------------------------------------------
    // MARK: - Custom Methods
    // ----------------------------------------------------
   
    @objc func panAction(_ sender: UISwipeGestureRecognizer){
        switch sender.direction {
        case .down:
            hideBottomView(true)
        case .up:
            hideBottomView(false)
        default:
            break
        }
    }
    
    @objc func hideBottomView(_ hide: Bool){
        containerBottomConstraint.constant = hide ? -bottomContentView.bounds.height + 80 : 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [.curveEaseInOut, .allowUserInteraction, .beginFromCurrentState], animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func setNavbar(){
       // setupNavigation(.normal(title: "Home", leftItem: .menu, hasNotification: true))
        let userName = "\(Singleton.shared.userProfile?.responseObject.firstName ?? "")" +  " " + "\(Singleton.shared.userProfile?.responseObject.lastName  ?? "")"
        setupNavigation(.normal(title: "\("Hi".localized), \(userName)", leftItem: .menu, hasNotification: true))
        
    }

    // ----------------------------------------------------
    // MARK:- ARCarMovement Delegate
    // ----------------------------------------------------
    // ----------------------------------------------------------
    /// Switch Setup
    // ----------------------------------------------------------
    func setRightSwitch() {
        setupOnlineOfflineView()
        webserviceForChangeDuty()
    }
    
    func setupOnlineOfflineView() {
        if Singleton.shared.isDriverOnline {
            print("socket connect start : -",Date())
//            SocketIOManager.shared.establishConnection()
            //startTimer()
            self.offlineView.isHidden = true
            if self.constantHeightOfOfflineView != nil {
                self.constantHeightOfOfflineView.constant = 0
            }
        } else {
//            SocketIOManager.shared.closeConnection()
            //self.endTimer()
            if self.constantHeightOfOfflineView != nil {
                self.constantHeightOfOfflineView.constant = 60
            }
            self.offlineView.isHidden = false
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    public func getFirstView() {
        self.presentView(forState: .duty)
    }
    
    public func getLastView(bookingDetail: CompeteTripData?) {
        self.presentView(forState: .lastCompleteView,bookingDetail: bookingDetail)
    }
    
    func setProgress() {
        //1
        progressRequest.isHidden = false
        progressRequest.progress = 0.0
        self.count = 0
        timerProgressRequest?.invalidate()
        timerProgressRequest = nil
        // 2
        timerProgressRequest = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            // 3
            if self.count >= 1 {
                self.timerProgressRequest?.invalidate()
                self.count = 0
                self.progressRequest.progress = 0.0
                self.progressRequest.isHidden = true
//                self.setConstraintOfHomeVc()
//                self.setRequestRejectedView()
                if let id = Singleton.shared.bookingInfo?.id {
                    self.emitSocket_RejectRequest(bookingId: id)
                }
                return
            }
            // 4
            UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
                self.count += 0.033
                self.progressRequest.setProgress(Float(self.count), animated: true)
            }, completion: { (state) in
            })
        }
    }
    
    func stopProgress() {
        self.timerProgressRequest?.invalidate()
        self.count = 0
        self.progressRequest.progress = 0.0
        self.progressRequest.isHidden = true
    }

    func presentView(forState state: DriverState,bookingDetail: CompeteTripData? = nil) {
        self.presentType = state
        self.presentView?.removeFromSuperview()
        self.presentView = state.fromNib()
        if let presentView = presentView as? CompleteView {
            presentView.bookingDetail = bookingDetail
        }
        self.presentView?.layoutSubviews()
        bottomContentView?.customAddSubview(presentView!)
        containerBottomConstraint.constant = 0
        self.bottomContentView.layoutSubviews()
    }
    
    func checkDriverStatus() {
        if let status = Singleton.shared.bookingInfo?.statusEnum {
            switch status {
            case .accepted:
                if bookingData.arrivedTime.isEmpty {
                    self.driverData.driverState = .requestAccepted
                    self.presentView(forState: .requestAccepted)
                } else {
                    self.driverData.driverState = .arrived
                    self.presentView(forState: .arrived)
                }
            case .traveling:
                self.presentView(forState: .inTrip)
                self.driverData.driverState = .inTrip
                self.resetMap()
            default:
                break
            }
        }
    }
    
    private func distanceBetween(start: CLLocationCoordinate2D,end: CLLocationCoordinate2D) -> Bool{
        let coordinate = CLLocation(latitude: start.latitude, longitude: start.longitude)
        let coordinate1 = CLLocation(latitude: end.latitude, longitude: end.longitude)
        let distanceInMeters = coordinate.distance(from: coordinate1)
        return (distanceInMeters > 5) ? true : false
    }
    
    private func updateLocation() {
        guard let location = LocationManager.shared.mostRecentLocation else {
            return
        }
        if isFirstTimeLaunch {
            isCameraAnimation = true
            isFirstTimeLaunch = false
            self.checkDriverStatus()
        }
        if(driverMarker == nil || driverMarker!.map == nil) {
            setDriverMarker()
        }
        if oldCoordinate != nil {
            CATransaction.begin()
            CATransaction.setValue(1, forKey: kCATransactionAnimationDuration)
        }else{
            oldCoordinate = location.coordinate
        }
        if isCameraAnimation {
            if (LocationManager.shared.speed ?? 0.0) > 0{
                let curLet = location.coordinate.latitude
                let curLong = location.coordinate.longitude
                let dropLet = oldCoordinate.latitude//dictLocation?["lat"]?.doubleValue ?? 0.0
                let dropLong = oldCoordinate.longitude//dictLocation?["lng"]?.doubleValue ?? 0.0
    //            self.lastCoordinate = newCoordinate
                if curLet != dropLet && curLong != dropLong{
                    let camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2DMake(curLet, curLong), zoom: 17, bearing: UtilityClass.getBearingBetweenTwoPoints(point1: CLLocationCoordinate2DMake(dropLet, dropLong), point2:CLLocationCoordinate2DMake(curLet, curLong)), viewingAngle: 45)
                    mapView.animate(to: camera)
                }
            }
        }
        if let driverMarker = self.driverMarker {
            carMovement.arCarMovement(marker: driverMarker,
                                      oldCoordinate: oldCoordinate ?? location.coordinate,
                                      newCoordinate: location.coordinate,
                                      mapView: mapView, zoomOn: isCameraAnimation)
        }
        if oldCoordinate != nil {
            CATransaction.commit()
        }
        oldCoordinate = location.coordinate
    }
    
}

// ----------------------------------------------------
// MARK: - Location Methods
// ----------------------------------------------------

extension HomeViewController {
    
    func emitDriverLocation(location: CLLocationCoordinate2D) {
        print("Driver Update Location:\(#function) ")
        let param = [
            "driver_id" : "\(Singleton.shared.userProfile?.responseObject.id ?? "")",
            "lat" : "\(location.latitude)",
            "lng" : "\(location.longitude)"
        ] as [String:AnyObject]
        if SocketIOManager.shared.socket.status == .connected {
            emitSocket_UpdateDriverLatLng(param: param)
        }
    }
}


extension HomeViewController: LocationManagerDelegate , GMSMapViewDelegate {
    
    func locationManager(_ manager: LocationManager, didUpdateLocation mostRecentLocation: CLLocation) {
        updateLocation()
        if Singleton.shared.isDriverOnline {
            guard let loc = LocationManager.shared.mostRecentLocation?.coordinate else {
                return
            }
//            emitDriverLocation(location: loc)
        }
    }
    
    func setDriverMarker() {
        guard let location = LocationManager.shared.mostRecentLocation?.coordinate else {
            return
        }
        if(driverMarker == nil || driverMarker!.map == nil) {
            self.driverMarker = GMSMarker(position: location)
            self.driverMarker?.icon = UIImage(named:"ic_carblack")
            self.driverMarker?.map = self.mapView
        } else {
            self.driverMarker?.position = location
        }
    }

    //MARK:- ===== Update placemark ======
    func updateMarker(lat:Double , lng : Double){
        DispatchQueue.main.async {
            //self.MapView.animate(toLocation: CLLocationCoordinate2D(latitude: lat, longitude:lng))
            let location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            if(self.driverMarker == nil || self.driverMarker!.map == nil) {
                self.driverMarker = GMSMarker(position: location)
                self.driverMarker?.icon = UIImage(named:"ic_carblack")
                self.driverMarker?.map = self.mapView
            } else {
                self.driverMarker?.position = location
            }
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            break
        case .denied:
            //            mapView.isHidden = false
            break
        case .notDetermined:
            break
        case .authorizedAlways:
            manager.startUpdatingLocation()
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // print (error)
        if (error as? CLError)?.code == .denied {
            manager.stopUpdatingLocation()
            manager.stopMonitoringSignificantLocationChanges()
        }
    }
}

extension HomeViewController {
    
    func setupMarkerOnGooglMap(markerType: setupGMSMarker, cordinate: CLLocationCoordinate2D){
        if markerType != .from {
            destinationMarker?.map = nil
            destinationMarker = GMSMarker(position: cordinate)
            destinationMarker!.icon = UIImage.init(named: (markerType == setupGMSMarker.from) ? "ic_carblack" : "ic_location_pulse")
            destinationMarker!.map = self.mapView
            destinationMarker!.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            destinationMarker!.title = ""
        }
        setDriverMarker()
        let mapInsets = UIEdgeInsets(top: 50, left: 15, bottom: self.containerTopView.frame.height + 50, right: 15)
        self.mapView.padding = mapInsets
        self.arrMarkers.removeAll()
        if let driverMarker = self.driverMarker {
            self.arrMarkers.append(driverMarker)
        }
        if let destinationMarker = self.destinationMarker {
            self.arrMarkers.append(destinationMarker)
        }
        var bounds = GMSCoordinateBounds()
        for marker in self.arrMarkers{
            bounds = bounds.includingCoordinate(marker.position)
        }
        let update = GMSCameraUpdate.fit(bounds, withPadding: 17)
        self.mapView.animate(with: update)
        delay(seconds: 5) {
            guard let driverCordinate = Singleton.shared.driverLocation else {
                LocationManager.shared.openSettingsDialog()
                return
            }
            let camera = GMSCameraPosition.camera(withLatitude: driverCordinate.latitude, longitude: driverCordinate.longitude, zoom: 17);
            self.mapView.camera = camera
        }
        //self.mapView.animate(to: GMSCameraPosition(target: driverCordinate, zoom: 12))
    }
    
    func resetMap(){
        guard let driverLocation = Singleton.shared.driverLocation else {
            LocationManager.shared.openSettingsDialog()
            return
        }
        mapView.animate(toLocation: driverLocation)
        mapView.clear()
        self.drawRouteOnGoogleMap()
    }
    
    func delay(seconds: Double, closure: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            closure()
        }
    }
}
