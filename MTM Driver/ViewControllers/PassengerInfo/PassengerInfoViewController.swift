//
//  PassengerInfoViewController.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 03/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import SwiftyJSON

class PassengerInfoViewController: UIViewController {

    @IBOutlet weak var tblParcel: UITableView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var tblHeight : NSLayoutConstraint!
    
    var data : JSON?
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var viewPassengerInfo: UIView!
    @IBOutlet weak var imgPassengerProfile: UIImageView!
    @IBOutlet weak var lblPickUpLocationInFo: UILabel!
    @IBOutlet weak var lblDroPoffLocationInFo: UILabel!
    @IBOutlet weak var lblFlightNumberInFo: UILabel!
    @IBOutlet weak var lblNotesInFo: UILabel!
    
    @IBOutlet weak var lblPickupLocationDetails: UILabel!
    @IBOutlet weak var lblDropoffLocationDetails: UILabel!
    @IBOutlet weak var lblContactNumber: UILabel!
    @IBOutlet weak var lblPassengerInfo: UILabel!
    @IBOutlet weak var lblPassengerName: UILabel!
    @IBOutlet weak var lblFlightNumber: UILabel!
    @IBOutlet weak var lblNotes: UILabel!
    @IBOutlet weak var lblFlightNumberDetail: UILabel!
    @IBOutlet weak var lblNotesDetail: UILabel!
    
    //stackview
    @IBOutlet weak var stackViewFlightNumber: UIStackView!
    @IBOutlet weak var stackViewNotes: UIStackView!
    //button
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var btnCall: UIButton!

}
