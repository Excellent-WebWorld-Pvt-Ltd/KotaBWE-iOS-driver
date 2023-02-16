//
//  PastTripHistoryVC.swift
//  Danfo_Driver
//
//  Created by Kinjal on 17/04/21.
//

import UIKit

class PastTripHistoryVC: UIViewController {

    //MARK:- ======= Outlets =======
    @IBOutlet weak var TblPastTrip: UITableView!
    
    //MARK:- ===== Variables ======
    private let refreshControl = UIRefreshControl()
    
    var NeedToReload:Bool = false
    var PageLimit = 10
    var PageNumber = 1
    var arrPastHistory = [BookingHistoryResponse]()
    private var showNoDataCell = false
    var isLoading = true {
            didSet {
                TblPastTrip.isUserInteractionEnabled = !isLoading
                TblPastTrip.reloadData()
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isLoading = true
        TblPastTrip.registerNibCell(type: .noData)

        NotificationCenter.default.removeObserver(self, name: .refresh, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DataRefresh), name: .refresh, object: nil)
        
        TblPastTrip.refreshControl = refreshControl
        pastBookingHistory(ShowHud: true, PageNo: PageNumber)
        refreshControl.addTarget(self, action: #selector(self.refreshWeatherData(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.lightGray //
        TblPastTrip.registerNibCell(type: .trip)
        TblPastTrip.reloadData()
    }
    
    @objc func DataRefresh(){
       
       latestReload()
    }
    
    func latestReload(){
        PageNumber = 1
        NeedToReload = false
        pastBookingHistory(ShowHud: false, PageNo: PageNumber)
    }
    
    func loadMoreData(){
        PageNumber += 1
        NeedToReload = false
        pastBookingHistory(ShowHud: false, PageNo: PageNumber)
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        
        self.latestReload()
    }

}

//MARK:- ======= Tablview dataSource and Delegate Methods ======
extension PastTripHistoryVC : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading == false && arrPastHistory.isEmpty{
            return 1
        } else {
            return arrPastHistory.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrPastHistory.count != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellType.trip.cellId, for: indexPath) as! TripTableViewCell
            cell.mapContainerView.isHidden = true
            cell.mapContainerView.frame.size.height = 0
            cell.configuration(hasMap: false, info: arrPastHistory[indexPath.row])
            return cell
        }
        else {
            let cell: NoDataFoundTblCell = tableView.dequeueReusableCell(withType: .noData, for: indexPath)
            cell.setMessage("No data found!")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return arrPastHistory.count != 0 ? UITableView.automaticDimension : self.TblPastTrip.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let TripDetailsVC : TripDetailVC = UIViewController.viewControllerInstance(storyBoard: .myTrips)
        TripDetailsVC.objDetail = arrPastHistory[indexPath.row]
        TripDetailsVC.isFromPast =  true
        self.navigationController?.pushViewController(TripDetailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.setTemplateWithSubviews(isLoading, viewBackgroundColor: .systemBackground)
        if indexPath.row == arrPastHistory.count - 4 && NeedToReload == true {
            loadMoreData()
        }
    }

}

extension PastTripHistoryVC  {
    
    
    func pastBookingHistory(ShowHud : Bool , PageNo : Int) {
        
        let param = "/" + (Singleton.shared.userProfile?.responseObject.id  ?? "") + "/" + "\(PageNo)"
        
        if(ShowHud) {
            refreshControl.beginRefreshing()
        }
        
        self.isLoading = true
        WebServiceCalls.pastBookingHistory(strType: param) { response, Status in
            self.isLoading = false
            self.refreshControl.endRefreshing()
            if Status {
                self.isLoading = false
                print(response)
                
                let objResponse  = RootBookingHistory(fromJson: response)
                if PageNo == 1 {
                    self.arrPastHistory = objResponse.data
                }else {
                    self.arrPastHistory.append(contentsOf: objResponse.data)
                }
                if objResponse.data.isEmpty || objResponse.data.count < self.PageLimit {
                    self.NeedToReload = false
                }else {
                    self.NeedToReload = true
                }
                self.showNoDataCell = self.arrPastHistory.isEmpty
                self.TblPastTrip.reloadData()
            }
            else {
                
                AlertMessage.showMessageForError(response["message"].stringValue)
            }
        }

    }
}
