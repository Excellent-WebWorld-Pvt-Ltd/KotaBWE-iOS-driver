//
//  EarningSetalmentVC.swift
//  Danfo_Driver
//
//  Created by Kinjal on 12/04/21.
//

import UIKit

enum SettlementType:String {
    case pending = "Daily"
    case complete = "Weekly"
}

class SettlementData{
    var pageNumber = 1
    var data : EarningSettlementResponseModel?
    var needReload = true
}

class EarningSettlementVC: BaseViewController {
    //MARK:- ======= Outlets ========
    @IBOutlet weak var tblEarning: UITableView!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var pendingButton: UIButton!
    @IBOutlet weak var tabSelectedView: UIView!
    @IBOutlet weak var tabLeftContraint: NSLayoutConstraint!
    @IBOutlet weak var btnWithdrawalView: UIView!
    @IBOutlet weak var lblMessege: UIView!
    @IBOutlet weak var lblAmount: ThemeLabel!
    @IBOutlet weak var btnWithdraw: ThemePrimaryButton!
    @IBOutlet weak var llblTotalAmount: ThemeLabel!
    @IBOutlet weak var lblHistory: ThemeLabel!
    
    //MARK:- ==== Variables ======
    var pendingData =  SettlementData()
    var completeData = SettlementData()
    let Todaydata = Date()
    let dateFormatter = DateFormatter()
    private let refreshControl = UIRefreshControl()
    
    var weekDays : [(day: String, date: String , FullDateFormateString:String)] = []
    var earningType : SettlementType = .pending {
        didSet {
            switch earningType {
            case .pending:
                if (self.pendingData.data?.earnings.count ?? 0) == 0{
                    self.callWebServiceForPending(PageNo: self.pendingData.pageNumber)
                }else{
                    self.setData()
                }
            case .complete :
                if (self.completeData.data?.earnings.count ?? 0) == 0{
                    self.callWebServiceForComplete(PageNo: self.completeData.pageNumber)
                }else{
                    self.setData()
                }
            }
        }
    }
    
    //MARK:- ===== View Controller Life cycle =======
    override func viewDidLoad() {
        super.viewDidLoad()
        earningType = .pending
        tblEarning.registerNibCell(type: .noData)
        setupNavigation(.normal(title: "Earning Settlement".localized, leftItem: .back, hasNotification: false))
        tblEarning.registerNibCell(type: .walletHistory)
        refreshControl.addTarget(self, action: #selector(self.refreshWeatherData(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.lightGray
        tblEarning.refreshControl = refreshControl
        
        tblEarning.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tblEarning.frame.size.width, height: 1))
        self.btnSetup()
    }
    
    //MARK:- Add Shimmer effect  ====
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        view.setTemplateWithSubviews(true, viewBackgroundColor: .lightGray)
    }
    
    //MARK:- ==== Stop Shimmer Effect ====
    func stopShimmer(){
        self.view.setTemplateWithSubviews(false)
    }
    
    func setLocalization(){
        self.pendingButton.setTitle("Pending".localized, for: .normal)
        self.completeButton.setTitle("Completed".localized, for: .normal)
        self.llblTotalAmount.text = "Total amount".localized
        self.lblHistory.text = "History".localized
        
    }
    
    func btnSetup(){
        self.pendingButton.setTitleColor(UIColor.white, for: .normal)
        self.pendingButton.titleLabel?.font = UIFont.bold(ofSize: 16.0)
        self.completeButton.setTitleColor(UIColor.themeTextFieldFilledBorderColor, for: .normal)
        self.completeButton.titleLabel?.font = UIFont.bold(ofSize: 16.0)
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        switch earningType {
        case .pending:
            pendingData.pageNumber = 1
            pendingData.data = nil
            pendingData.needReload = true
            self.earningType = .pending
        case .complete:
            completeData.pageNumber = 1
            completeData.data = nil
            completeData.needReload = true
            self.earningType = .complete
        }
    }
    
    @IBAction func btnActionComplete(_ sender: UIButton) {
        self.btnWithdrawalView.isHidden = true
        earningType = .complete
    }
    
    @IBAction func btnActionPending(_ sender: UIButton) {
        self.btnWithdrawalView.isHidden = false
        earningType = .pending
    }
    
    //MARK:- ======== Btn action withDraw ========
    @IBAction func btnActionWithDraw(_ sender: UIButton){
        if pendingData.data?.isRequested == "1"{
            return
        }
        if (pendingData.data?.earnings.count ?? 0) == 0{
            AlertMessage.showMessageForError("You do not have any earning.".localized)
            return
        }
        ThemeAlertVC.present(from: self, ofType: .confirmation(title: "Withdraw".localized, message: "Are you sure you want to withdraw".localized, onConfirmed: {
            self.callWebServiceToWithdrew()
        }))
    }
    
    @IBAction func tabButtonTapped(_ sender: UIButton) {
        tabLeftContraint.constant = sender.frame.origin.x
        [pendingButton, completeButton].forEach({ button in
            button?.setTitleColor(button == sender ? .white : .themeTextFieldFilledBorderColor, for: .normal)
        })
        UIView.animate(withDuration: 0.3) {
            sender.superview?.superview?.layoutIfNeeded()
        }
    }
    
    func setData(){
        switch earningType{
        case .pending:
            self.lblAmount.text = "\(Currency) \(pendingData.data?.totalPrice ?? "0.00")"
        case .complete:
            self.lblAmount.text = "\(Currency) \(completeData.data?.totalPrice ?? "0.00")"
        }
        self.btnWithdraw.setTitle(pendingData.data?.isRequested == "0" ? "Withdraw Money".localized : "Withdraw request pending...".localized, for: .normal)
        self.tblEarning.reloadData()
    }
}

extension EarningSettlementVC : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = self.earningType == .pending ? pendingData : completeData
        if (data.data?.earnings?.count ?? 0) == 0{
            return 1
        }else if data.needReload{
            return (data.data?.earnings?.count ?? 0) + 1
        }else{
            return data.data?.earnings?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.getList()
        let show = self.earningType == .pending ? pendingData.needReload : completeData.needReload
        if  data?.count == 0 {
            let cell: NoDataFoundTblCell = tableView.dequeueReusableCell(withType: .noData, for: indexPath)
            cell.setMessage("\("No earning history found".localized)!")
            return cell
        }else if show && indexPath.row == data?.count ?? 0{
            return LoadingCell.getIntance()
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellType.walletHistory.cellId, for: indexPath) as! WalletHistoryTableViewCell
            cell.amountLable.textColor = .themeSuccess
            cell.amountLable.text = "+" + (data?[indexPath.row].driverAmount.toCurrencyString() ?? "0.00")
            cell.timeLabel.text = data?[indexPath.row].createdAt ?? ""
            cell.titleLabel.text = "ID #\(data?[indexPath.row].id ?? "0")"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = self.getList()
        return data?.count == 0 ? tblEarning.frame.size.height : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let list = earningType == .pending ? pendingData : completeData
        if indexPath.row == ((list.data?.earnings.count ?? 0) - 1) && list.needReload {
            self.loadNextPage()
        }
    }
    
    func loadNextPage(){
        switch earningType{
        case .pending:
            self.pendingData.pageNumber += 1
            self.callWebServiceForPending(PageNo: self.pendingData.pageNumber)
        case .complete:
            self.completeData.pageNumber += 1
            self.callWebServiceForComplete(PageNo: self.completeData.pageNumber)
        }
    }
    
    func getList() -> [EarningData]?{
        switch earningType{
        case .pending:
            return pendingData.data?.earnings
        case .complete:
            return completeData.data?.earnings
        }
    }
}

extension EarningSettlementVC {
    
    func callWebServiceForPending(PageNo : Int){
        var dictData = [String: Any]()
        if PageNo == 1{
            Loader.showHUD()
        }
        dictData["key"] = "\(Singleton.shared.driverId)/\(PageNo)"
        WebService.shared.requestMethod(api: .driverPendingEarningSettlement, httpMethod: .get, parameters: dictData) { (json, status) in
            DispatchQueue.main.async {
                Loader.hideHUD()
                self.refreshControl.endRefreshing()
            }
            let objResponse = EarningSettlementResponseModel(fromJson: json)
            if objResponse.earnings.count < 10 {
                self.pendingData.needReload = false
            }
            if PageNo == 1{
                self.pendingData.data = objResponse
            }else{
                if objResponse.earnings.count > 0 {
                    for i in objResponse.earnings{
                        self.pendingData.data?.earnings.append(i)
                    }
                }
            }
            if self.earningType == .pending{
                self.setData()
            }
        }
    }
    
    func callWebServiceForComplete(PageNo : Int){
        var dictData = [String: Any]()
        if PageNo == 1{
            Loader.showHUD()
        }
        dictData["key"] = "\(Singleton.shared.driverId)/\(PageNo)"
        WebService.shared.requestMethod(api: .driverCompletedEarningSettlement, httpMethod: .get, parameters: dictData) { (json, status) in
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
            let objResponse = EarningSettlementResponseModel(fromJson: json)
            if objResponse.earnings.count < 10 {
                self.completeData.needReload = false
            }
            if PageNo == 1{
                Loader.hideHUD()
                self.completeData.data = objResponse
            }else{
                if objResponse.earnings.count > 0 {
                    for i in objResponse.earnings{
                        self.completeData.data?.earnings.append(i)
                    }
                }
            }
            if self.earningType == .complete{
                self.setData()
            }
        }
    }
    
    func callWebServiceToWithdrew(){
        let params = ["driver_id": Singleton.shared.driverId]
        Loader.showHUD()
        WebService.shared.requestMethod(api: .withdraw, httpMethod: .post, parameters: params, completion: { json,status in
            Loader.hideHUD()
            if status{
                self.pendingData.data?.isRequested = "1"
                self.setData()
                AlertMessage.showMessageForSuccess("\(json[ "message"])")
            }else{
                AlertMessage.showMessageForError(json.getApiMessage())
            }
        })
    }
}
