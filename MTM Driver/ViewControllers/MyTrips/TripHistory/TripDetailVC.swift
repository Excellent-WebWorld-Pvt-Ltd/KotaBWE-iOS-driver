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

class TripDetailVC: BaseViewController {
    
    
    @IBOutlet weak var viewAcceptReject: UIView!
    
    
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var collectionImages: UICollectionView!
    @IBOutlet weak var viewPastInvoice: UIView!
    
    @IBOutlet weak var viewCallMessage: UIView!
    @IBOutlet weak var viewAccept: ThemeButton!
    var isFromPast: Bool = true
    var mapView: GMSMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionImages.reloadData()
        self.setupNavigation(.normal(title: "Trip Detail", leftItem: .back, hasNotification: false))
        setupUI()
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
        viewCallMessage.isHidden = isFromPast
        viewAccept.isHidden = isFromPast
        viewAcceptReject.isHidden = isFromPast
    }

}


extension TripDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCell", for: indexPath) as! ImagesCell
        if indexPath.row == 0 {
            cell.imgCargoPhotos.image = UIImage(named: "truck")
        }else if indexPath.row == 1 {
            cell.imgCargoPhotos.image = UIImage(named: "truck-2")
        }else{
            cell.imgCargoPhotos.image = UIImage(named: "truck-3")
        }
        cell.imgCargoPhotos.contentMode = .scaleAspectFill
        cell.btnRemoveImage.isHidden = true
//        cell.btnRemoveImage.addTarget(self, action: #selector(removeImage(sender:)), for: .touchUpInside)
//        cell.btnRemoveImage.tag = indexPath.row
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Index:\(indexPath.row)")
        //selectedIndex = indexPath
        //collectionViewImages.reloadData()
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
