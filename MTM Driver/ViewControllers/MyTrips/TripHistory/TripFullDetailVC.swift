//
//  TripFullDetailVC.swift
//  KotaBWE
//
//  Created by Harshit K on 11/01/23.
//  Copyright © 2023 Mayur iMac. All rights reserved.
//

import UIKit
import GoogleMaps
import Cosmos
import SwiftyJSON

class TripFullDetailVC: BaseViewController {
    
    
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var collectionImages: UICollectionView!
    @IBOutlet weak var viewPastInvoice: UIView!
    
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
    @IBOutlet weak var viewNotes: UIView!
    @IBOutlet weak var lblNotes: ThemeLabel!
    @IBOutlet weak var lblPickUpTitle: ThemeLabel!
    @IBOutlet weak var lblDropoffTitle: ThemeLabel!
    @IBOutlet weak var lblcargoWeight: ThemeLabel!
    @IBOutlet weak var lblItemQuantity: ThemeLabel!
    @IBOutlet weak var lblTruckLoad: ThemeLabel!
    @IBOutlet weak var lblVehicleInfo: ThemeLabel!
    @IBOutlet weak var lblTitleNotes: ThemeLabel!
    @IBOutlet weak var lblTitleTripTime: ThemeLabel!
    @IBOutlet weak var lblTitleWaitingTime: ThemeLabel!
    @IBOutlet weak var lblTitleTotalTime: ThemeLabel!
    @IBOutlet weak var lblTitleDistance: ThemeLabel!
    @IBOutlet weak var lblTitleTripPrice: ThemeLabel!
    @IBOutlet weak var lblTitleEarning: ThemeLabel!
    
    
    var mapView: GMSMapView?
    var objDetail : BookingInfo?
    var arrMarker = [GMSMarker]()
    var arrTruckImages = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation(.normal(title: "Trip Detail".localized, leftItem: .back, hasNotification: false))
        setupUI()
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
        
        viewPastInvoice.isHidden = true
    }

    //MARK :- Other Function
    func setLocalization(){
        self.lblPickUpTitle.text = "Pickup".localized
        self.lblDropoffTitle.text = "Drop-off".localized
        self.lblcargoWeight.text = "Cargo weight".localized
        self.lblItemQuantity.text = "Item Quantity".localized
        self.lblTruckLoad.text = "Truck Load Type".localized
        self.lblVehicleInfo.text = "Vehicle Info".localized
        self.lblTitleNotes.text = "\("Notes".localized) :"
        self.lblTitleTripTime.text = "\("Trip Time".localized):"
        self.lblTitleWaitingTime.text = "\("Waiting Time".localized):"
        self.lblTitleTotalTime.text = "\("Total Time".localized):"
        self.lblTitleDistance.text = "\("Distance".localized):"
        self.lblTitleTripPrice.text = "\("Trip Price".localized):"
        self.lblTitleEarning.text = "\("Your Earning".localized):"
    }
    
    func setupData(){
        setupMapView()
        viewNotes.isHidden = objDetail?.notes != "" ? false : true
                lblNotes.text = objDetail?.notes
        lblPickup.text = objDetail?.pickupLocation
        lblDropoff.text = objDetail?.dropoffLocation
        lblTripId.text = "ID: \(objDetail?.id ?? "")"
        
        if let bookingTime = objDetail?.bookingTime?.timeStampToDate() {
            lblTime.text = bookingTime.getDayDifferentTextWithTime()
        } else {
            lblTime.text = "--"
        }
        
        lblCargoWeight.text = "\(objDetail?.cargoWeightKg ?? "") Kg"
        lblItemQty.text = objDetail?.itemQuantity
        lblVehicleLoadType.text = objDetail?.truckLoadType
        lblVehicleName.text = objDetail?.vehicleType.name
        let platnumber = SessionManager.shared.userProfile?.responseObject.vehicleInfo.first?.plateNumber
        lblPlateNumber.text = "(\(platnumber ?? ""))"
        self.arrTruckImages = objDetail?.cargoImage ?? []
        if arrTruckImages.count > 0 {
            self.viewImages.isHidden = false
            self.collectionImages.reloadData()
        }else{
            self.viewImages.isHidden = true
        }
        
    }
    
    private func setupMapView() {
        mapView = GMSMapView()
        guard let mapView = self.mapView else {
            return
        }
        mapView.isUserInteractionEnabled = false
        mapContainerView.addSubview(mapView)
        mapView.setAllSideContraints(.zero)
        guard let pickUpLocation = CLLocationCoordinate2D(latString: objDetail?.pickupLat, lngString: objDetail?.pickupLng),
              let dropOffLocation = CLLocationCoordinate2D(latString: objDetail?.dropoffLat, lngString: objDetail?.dropoffLng) else {
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
    
}


extension TripFullDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        let galaryVC : GalaryVC = UIViewController.viewControllerInstance(storyBoard: .home)
        galaryVC.Image = arrTruckImages[indexPath.row].stringValue
        self.navigationController?.present(galaryVC, animated: true)
//        self.openWebURL( arrTruckImages[indexPath.row].stringValue)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
}
