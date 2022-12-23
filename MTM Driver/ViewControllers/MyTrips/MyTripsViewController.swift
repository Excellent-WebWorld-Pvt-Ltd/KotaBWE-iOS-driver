//
//  MyTripsViewController.swift
//  Pappea Driver
//
//  Created by EWW-iMac Old on 04/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

class MyTripsViewController: BaseViewController {
  
    
    @IBOutlet weak var collectionTableView: HeaderTableViewController!
    
    
    var tripType = MyTrips.past
    var data = [(String, String)]()
    var pageNoPastBooking: Int = 1
    var pageNoPastUpcoming: Int = 1
    private let refreshControl = UIRefreshControl()
    var isRefresh = Bool()
    var isDataLoading:Bool=false
    var didEndReached:Bool=false
    var NeedToReload:Bool = false
    var PageLimit = 10
    var PageNumber = 1
    var pastBookingHistoryModelDetails = [BookingHistoryResponse]()
    {
        didSet
        {
            self.collectionTableView.tableView.reloadData()
        }
    }
    
    
    //MARK:- ===== View Controller Life Cycle =====
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setCollectionTableView()
//        data = tripType.getDescription()
        webserviceCallForGettingPastHistory(pageNo: 1)
        self.setNavBarWithBack(Title: "My Trips", IsNeedRightButton: false)
        
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            collectionTableView.tableView.refreshControl = refreshControl
        } else {
            collectionTableView.tableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(self.refreshWeatherData(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.red // UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
    }

    
    @objc private func refreshWeatherData(_ sender: Any) {
        self.LoadNewData()
        // Fetch Weather Data
        isRefresh = true
        //        if self.tripType.rawValue.lowercased() == "past" {
        //            self.pageNoPastBooking = 1
        //            webserviceCallForGettingPastHistory(pageNo: 1)
        //        } else {
        //            self.pageNoPastUpcoming = 1
        //            webserviceForUpcommingBooking(pageNo: 1)
        //        }
    }
    
    
    private func setCollectionTableView(){
        collectionTableView.isSizeToFitCellNeeded = true
        collectionTableView.indicatorColor = .black
        collectionTableView.titles = MyTrips.titles
        collectionTableView.parentVC = self
        collectionTableView.textFont = UIFont.regular(ofSize: 15)
        collectionTableView.indicatorColor = .black
        collectionTableView.textColor = .black
        collectionTableView.registerNibs = [MyTripTableViewCell.identifier,
                                            MyTripDescriptionTableViewCell.identifier,
                                            FooterTableViewCell.identifier]
        collectionTableView.cellInset = UIEdgeInsets.zero
        collectionTableView.spacing = 0
        collectionTableView.didSelectItemAt = {
            indexpaths in
            if indexpaths.indexPath != indexpaths.previousIndexPath{
                self.tripType = MyTrips.allCases[indexpaths.indexPath.item]
//                self.data = self.tripType.getDescription()
                self.selectedCell = []
                
                if indexpaths.indexPath.item == 1
                {
                    self.LoadNewData()
                    //                    self.webserviceForUpcommingBooking(pageNo: 1)
                }
                else if indexpaths.indexPath.item == 2
                {
                    self.LoadNewData()
                    //                    self.webserviceForUpcommingBooking(pageNo: 1)
                }
                else
                {
                    self.LoadNewData()
                    //                    self.webserviceCallForGettingPastHistory(pageNo: 1)
                }
                self.collectionTableView.tableView.removeAllSubviews()
                self.collectionTableView.tableView.reloadData()
            }
        }
    }
    
    func LoadMoreData() {
        
        self.PageNumber += 1
        if self.tripType.rawValue.lowercased() == "past"
        {
            self.webserviceCallForGettingPastHistory(pageNo: self.PageNumber)
        }
        else if self.tripType.rawValue.lowercased() == "upcoming"
        {
           // self.webserviceForUpcommingBooking(pageNo: self.PageNumber)
        }
        else
        {
            //self.webserviceForUpcommingBooking(pageNo: self.PageNumber)
        }
        
    }
    
    func LoadNewData() {
        self.PageNumber = 1
        self.pastBookingHistoryModelDetails.removeAll()
        self.collectionTableView.tableView.reloadData()
        if self.tripType.rawValue.lowercased() == "past"
        {
            self.webserviceCallForGettingPastHistory(pageNo: self.PageNumber)
        }
        else if self.tripType.rawValue.lowercased() == "upcoming"
        {
           // self.webserviceForUpcommingBooking(pageNo: self.PageNumber)
        }
        else
        {
           // self.webserviceForUpcommingBooking(pageNo: self.PageNumber)
        }
    }
    
    
    var selectedCell = [Int]()
}

extension MyTripsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedCell.contains(section){
            return 1 + data.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return tableView.dequeueReusableCell(withIdentifier: FooterTableViewCell.identifier)
    }
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedCell.contains(indexPath.section){
           let index = selectedCell.firstIndex(of: indexPath.section)
            selectedCell.remove(at: index!)
            tableView.removeAllSubviews()
            tableView.reloadData()
        }
        else{
            selectedCell.append(indexPath.section)
            tableView.reloadData()
            let rect =  tableView.rect(forSection: indexPath.section)
            let imageView = UIImageView(frame: CGRect(x: 10, y: rect.minY, width: rect.width - 20, height: rect.height))
            imageView.image = #imageLiteral(resourceName: "bird-icon")
            imageView.alpha = 0.8
            imageView.contentMode = .scaleAspectFit
            tableView.removeAllSubviews()
            tableView.addSubview(imageView)
        }
        if indexPath.section == 9{
             tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: MyTripTableViewCell.identifier, for: indexPath) as! MyTripTableViewCell
            cell.setup()
            
//            let dataResponseHeader = self.pastBookingHistoryModelDetails[indexPath.section]
//            cell.lblName.text = "\(dataResponseHeader.driverFirstName ?? "") \(dataResponseHeader.driverLastName ?? "")"
//            cell.lblBookin.text = "Booking Id : \(dataResponseHeader.id ?? "")"
//            cell.lblPickup.text = dataResponseHeader.pickupLocation
//            cell.lblDropoff.text = dataResponseHeader.dropoffLocation
//            cell.btnSendReceipt.isHidden = true
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: MyTripDescriptionTableViewCell.identifier, for: indexPath) as! MyTripDescriptionTableViewCell
            cell.lblTitle.text = data[indexPath.row - 1].0 + ":"
            cell.lblDescription.text = data[indexPath.row - 1].1
            let color = indexPath.row == data.count ? UIColor.orange : UIColor.white
            cell.lblDescription.textColor = color
            cell.lblTitle.textColor = color
            cell.setup()
            return cell
        }
    }
    
    func webserviceCallForGettingPastHistory(pageNo: Int)
    {
        
//        let param = "/" + Singleton.shared.userProfile!.responseObject.id + "/" + "\(pageNo)"
//
//        if(!isRefresh)
//        {
//            Loader.showHUD(with: Helper.currentWindow)
//        }
//
//
//        UserWebserviceSubclass.pastBookingHistory(strType: param) { (response, status) in
//            Loader.hideHUD()
//            self.isRefresh = false
//            if status
//            {
//               print(response)
//                var arrResponseData = [PastBookingHistoryResponse]()
//
//                if let arrayResponse = response.dictionary?["data"]?.array {
//                    arrResponseData = arrayResponse.map({ (item) -> PastBookingHistoryResponse in
//                        return PastBookingHistoryResponse.init(fromJson: item)
//                    })
//                }
//
//                if arrResponseData.count == self.PageLimit {
//                    self.NeedToReload = true
//                } else {
//                    self.NeedToReload = false
//                }
//
//                if self.PageNumber == 1 {
//                    self.pastBookingHistoryModelDetails = arrResponseData
//                } else {
//                    for BookingObj in arrResponseData {
//                        self.pastBookingHistoryModelDetails.append(BookingObj)
//                    }
//                }
//                //                self.pastBookingHistoryModelDetails = self.pastBookingHistoryModelDetails.filter({$0.driverId != "0"})
//                self.collectionTableView.tableView.reloadData()
//                self.refreshControl.endRefreshing()
//            }
//            else
//            {
//                Loader.hideHUD()
//                AlertMessage.showMessageForError(response["message"].stringValue)
//            }
        }
        
        /*
        let model = PastBookingHistory()
        model.customer_id = Singleton.shared.loginData.id
        model.page = "\(pageNo)"
        
        let strURL = model.customer_id + "/" + model.page
        
       
        
        
        UserWebserviceSubclass.pastBookingHistory(strURL: strURL) { (response, status) in
            UtilityClass.hideHUD()
            self.isRefresh = false
            if(status) {
                var arrResponseData = [PastBookingHistoryResponse]()
                
                if let arrayResponse = response.dictionary?["data"]?.array {
                    arrResponseData = arrayResponse.map({ (item) -> PastBookingHistoryResponse in
                        return PastBookingHistoryResponse.init(fromJson: item)
                    })
                }
                
                if arrResponseData.count == self.PageLimit {
                    self.NeedToReload = true
                } else {
                    self.NeedToReload = false
                }
                
                if self.PageNumber == 1 {
                    self.pastBookingHistoryModelDetails = arrResponseData
                } else {
                    for BookingObj in arrResponseData {
                        self.pastBookingHistoryModelDetails.append(BookingObj)
                    }
                }
                //                self.pastBookingHistoryModelDetails = self.pastBookingHistoryModelDetails.filter({$0.driverId != "0"})
                self.collectionTableView.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
            else {
                UtilityClass.hideHUD()
                AlertMessage.showMessageForError(response["message"].stringValue)
            }
        }
        */
   // }
    
    func webserviceForUpcommingBooking(pageNo: Int)
    {
        
        /*
        let param = Singleton.shared.loginData.id + "/" + "\(pageNo)"
        UserWebserviceSubclass.upcomingBookingHistory(strURL: param) { (response, status) in
            print(response)
            UtilityClass.hideHUD()
            self.isRefresh = false
            if(status) {
                var arrResponseData = [PastBookingHistoryResponse]()
                
                if let arrayResponse = response.dictionary?["data"]?.array {
                    arrResponseData = arrayResponse.map({ (item) -> PastBookingHistoryResponse in
                        return PastBookingHistoryResponse.init(fromJson: item)
                    })
                }
                
                if arrResponseData.count == self.PageLimit {
                    self.NeedToReload = true
                } else {
                    self.NeedToReload = false
                }
                
                if self.PageNumber == 1 {
                    self.pastBookingHistoryModelDetails = arrResponseData
                } else {
                    for BookingObj in arrResponseData {
                        self.pastBookingHistoryModelDetails.append(BookingObj)
                    }
                }
                //                self.pastBookingHistoryModelDetails = self.pastBookingHistoryModelDetails.filter({$0.driverId != "0"})
                self.collectionTableView.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
            else {
                UtilityClass.hideHUD()
                AlertMessage.showMessageForError(response["message"].stringValue)
            }
        }
 
 */
   }
    
}
