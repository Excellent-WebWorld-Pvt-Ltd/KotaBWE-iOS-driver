//
//  UpComingTripHistoryVc.swift
//  Danfo_Driver
//
//  Created by Kinjal on 17/04/21.
//

import UIKit

class UpComingTripHistoryVc: UIViewController {

    //MARK:- ======= Outlets ========
    @IBOutlet weak var tblUpcominTrip: UITableView!
    
    
    //MARK:- ===== Variables ======
    private let refreshControl = UIRefreshControl()
   // private var showNoDataCell = false
    var isRefresh = Bool()
    var NeedToReload:Bool = false
    var PageLimit = 10
    var PageNumber = 1
    var arrUpcomingHistory = [BookingHistoryResponse]()
    var UpcomingBookingHistoryModelDetails = [BookingHistoryResponse]()
    {
        didSet
        {
            self.tblUpcominTrip.reloadData()
        }
    }
     var isLoading = true {
        didSet {
            tblUpcominTrip.isUserInteractionEnabled = !isLoading
            tblUpcominTrip.reloadData()
        }
      }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isLoading = true
        tblUpcominTrip.registerNibCell(type: .noData)

        NotificationCenter.default.removeObserver(self, name: .refresh, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DataRefresh), name:.refresh, object: nil)
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tblUpcominTrip.refreshControl = refreshControl
        } else {
            tblUpcominTrip.addSubview(refreshControl)
        }
        upComingBookingHistory(ShowHud: true, PageNo: PageNumber)
        refreshControl.addTarget(self, action: #selector(self.refreshWeatherData(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.lightGray //
        tblUpcominTrip.registerNibCell(type: .trip)
        tblUpcominTrip.reloadData()
    }
    
    
    
    @objc func DataRefresh(){
       latestReload()
    }
    
    func latestReload(){
        PageNumber = 1
        NeedToReload = false
        upComingBookingHistory(ShowHud: false, PageNo: PageNumber)
    }
    
    func loadMoreData(){
        PageNumber += 1
        NeedToReload = false
        upComingBookingHistory(ShowHud: false, PageNo: PageNumber)
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        
        self.latestReload()
    }

}

//MARK:- ======= Tablview dataSource and Delegate Methods ======
extension UpComingTripHistoryVc : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading == false && arrUpcomingHistory.isEmpty{
            return 1
        } else {
            return arrUpcomingHistory.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrUpcomingHistory.count != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellType.trip.cellId, for: indexPath) as! TripTableViewCell
            cell.mapContainerView.isHidden = true
            cell.mapContainerView.frame.size.height = 0

            cell.isFRomUpcoming = true
            cell.configuration(hasMap: false, info: arrUpcomingHistory[indexPath.row])
            return cell
        }
        else {
            let cell: NoDataFoundTblCell = tableView.dequeueReusableCell(withType: .noData, for: indexPath)
            cell.setMessage("No data found!")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.setTemplateWithSubviews(isLoading, viewBackgroundColor: .systemBackground)
        if indexPath.row == arrUpcomingHistory.count - 4 && NeedToReload == true {
            loadMoreData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return arrUpcomingHistory.count != 0 ? UITableView.automaticDimension : self.tblUpcominTrip.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let TripDetailsVC : TripDetailVC = UIViewController.viewControllerInstance(storyBoard: .myTrips)
        TripDetailsVC.objDetail = arrUpcomingHistory[indexPath.row]
        TripDetailsVC.isFromPast = false
        self.navigationController?.pushViewController(TripDetailsVC, animated: true)
    }

}

extension UpComingTripHistoryVc  {
    
    
    func upComingBookingHistory(ShowHud : Bool , PageNo : Int) {
        
        let param = "/" + (Singleton.shared.userProfile?.responseObject.id  ?? "") + "/" + "\(PageNo)"
        
        if(ShowHud) {
            refreshControl.beginRefreshing()
        }
        isLoading = true
        WebServiceCalls.UpcomingBookingHistory(strType: param) { response, Status in
         
            self.isLoading = false
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
            if Status {
                print(response)
                let objResponse  = RootBookingHistory(fromJson: response)
                if PageNo == 1 {
                    self.arrUpcomingHistory = objResponse.data
                }
                else {
                    self.arrUpcomingHistory.append(contentsOf: objResponse.data)
                }
                print(self.arrUpcomingHistory.count)
                if objResponse.data.isEmpty || objResponse.data.count < self.PageLimit {
                    self.NeedToReload = false
                }
                else {
                    self.NeedToReload = true
                }
                self.tblUpcominTrip.reloadData()
            }
            else {
                
                AlertMessage.showMessageForError(response["message"].stringValue)
            }
        }
    }
   
}
