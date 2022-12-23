//
//  WalleteViewController.swift
//  DPS
//
//  Created by Gaurang on 28/09/21.
//  Copyright © 2021 Mayur iMac. All rights reserved.
//

import UIKit

class WalleteViewController: BaseViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var balanceLabel: ThemeLabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    
    private var walletHistorydata: [walletHistoryListData] = []
    var walletHistoryRequest : WalletHistory = WalletHistory()
    private var showNoDataCell = false
    private var shouldShowLoadingCell = false
    private var page: Int = 1
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNibCell(type: .noData)
        configUI()
        setValues()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webserviceCallForHistoryList()
    }
    
    //MARK:- Add Shimmer effect  ====
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // view.setTemplateWithSubviews(true, viewBackgroundColor: .lightGray)
    }
    
    //MARK:- ==== Stop Shimmer Effect ====
    func stopShimmer(){
        self.view.setTemplateWithSubviews(false)
    }
    
    private func configUI() {
        
        setupNavigation(.normal(title: "Wallet", leftItem: .back, hasNotification: false))
        tableView.registerNibCell(type: .walletHistory)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
    }
    
    private func setValues() {
        if Singleton.shared.walletBalance == "" {
            self.balanceLabel.text = "0.00".toCurrencyString()
        }
        else{
            self.balanceLabel.text = Singleton.shared.walletBalance.toCurrencyString()
        }
    }
    
    @objc func refresh() {
        page = 1
        webserviceCallForHistoryList()
    }
    
    private func reloadTableView() {
        // tableHeightConstraint.constant = CGFloat.greatestFiniteMagnitude
        tableView.reloadData()
        tableView.layoutIfNeeded()
        // tableHeightConstraint.constant = tableView.contentSize.height
    }
    
    @IBAction func addMoneyTapped(_ sender: ThemePrimaryButton) {
        
        let view = AddMoneyView { [weak self] amount in
            let viewCtr = AppViewControllers.shared.paymentMethod(for: .addMoney(amount: amount))
            self?.push(viewCtr)
        }
        let viewCtr = AppViewControllers.shared.bottomSheet(title: "Add Money", view: view)
        self.present(viewCtr, animated: true)
    }
    
    
    @IBAction func btnActionwithDrawMoney(_ sender: UIButton) {
        
        let view = AddMoneyView(isfromWithDraw: true) { [unowned self] amount in
            print("Amount: ", amount)
            self.withdrawMoney(amount)
        }
        let viewCtr = AppViewControllers.shared.bottomSheet(title: "Withdraw Money", view: view)
        self.present(viewCtr, animated: true)
        
        
    }
    
    
    private func presentPinSelectionView(amount: String, cardId: String) {
        ThemeAlertVC.present(from: self, ofType: .cardPin(onConfirmed: { [weak self] pin in
            self?.addMoneyUsingCard(amount: amount, cardId: cardId, pin: pin)
        }))
    }
    
    private func addMoneyUsingCard(amount: String, cardId: String, pin: String) {
        let requestModel = AddMoneyRequestModel()
        requestModel.amount = amount
        requestModel.driver_id = "\(Singleton.shared.driverId)"
        requestModel.payment_type = "card"
        requestModel.card_id = cardId
        requestModel.pin = pin
        webserviceToAddMoney(requestModel: requestModel)
    }
    
    func handleWebPayment(_ paymentUrl: URL) {
        let webPageView = PaymentWebPageVC(paymentUrl, completion: { isPaid in
            if isPaid {
                AlertMessage.showMessageForSuccess("Money added successfully")
            } else {
                AlertMessage.showMessageForError("Transaction Failed")
            }
        })
        self.push(webPageView)
    }
    
    func webserviceToAddMoney(requestModel: AddMoneyRequestModel) {
        Loader.showHUD(with: self.view)
        WebServiceCalls.AddMoneytoWallet(addMoneyModel: requestModel) { (json, status) in
            Loader.hideHUD()
            if status {
                if let paymentUrlStr = json["payment_url"].string,
                   let paymentURL = URL(string: paymentUrlStr)  {
                    self.handleWebPayment(paymentURL)
                    
                } else {
                    Singleton.shared.walletBalance = json["wallet_balance"].stringValue
                    AlertMessage.showMessageForSuccess(json["message"].stringValue)
                }
            } else {
                AlertMessage.showMessageForError(json["message"].string ?? "Error")
            }
        }
    }
    
    
    @IBAction func sendMoneyTapped(_ sender: ThemePrimaryButton) {
        let view = SendMoneyView {[weak self] in
            self?.refresh()
        }
        let viewCtr = AppViewControllers.shared.bottomSheet(title: "Send Money", view: view)
        self.present(viewCtr, animated: true)
    }
    
    private func fetchNextPage() {
        page += 1
        webserviceCallForHistoryList()
    }
    
    private func isLoadingIndexPath(_ indexPath: IndexPath) -> Bool {
        guard shouldShowLoadingCell else { return false }
        return indexPath.row == walletHistorydata.count
    }
    
    
    //MARK:- ===== WebService Call Wallet History =====
    func webserviceCallForHistoryList() {
        // Loader.showHUD(with: self.view)
        guard SessionManager.shared.userProfile != nil else {
            return
        }
        if page == 1 && !self.refreshControl.isRefreshing {
            self.refreshControl.beginRefreshing()
        }
        walletHistoryRequest.driver_id = "\(Singleton.shared.driverId)"
        walletHistoryRequest.page = "\(page)"
        shouldShowLoadingCell = false
        showNoDataCell = false
        
        WebServiceCalls.walletHistory(transferMoneyModel: walletHistoryRequest) { json, status in
            self.stopShimmer()
            //Loader.hideHUD()
            self.refreshControl.endRefreshing()
            if status{
                let info = WalletHistoryListModel.init(fromJson: json)
                if let walletBalance = json["wallet_balance"].double {
                    Singleton.shared.walletBalance = String(walletBalance)
                    self.setValues()
                }
                if self.page == 1 {
                    self.walletHistorydata = info.walletHistorydata
                } else {
                    self.walletHistorydata += info.walletHistorydata
                }
                self.shouldShowLoadingCell = info.walletHistorydata.isNotEmpty
                self.showNoDataCell = self.walletHistorydata.isEmpty
            }
            else{
                AlertMessage.showMessageForError(json["message"].stringValue)
            }
            self.reloadTableView()
        }
    }
    
    private func withdrawMoney(_ amount: String) {
        Loader.showHUD(with: self.view)
        WebServiceCalls.withdrawMoney(amount: amount) { json, status in
            Loader.hideHUD()
            UtilityClass.showAlert(message: json.getApiMessage())
        }
    }
    
}

// MARK: - Tableview datasource delegate
extension WalleteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showNoDataCell {
            return 1
        } else if shouldShowLoadingCell {
            return walletHistorydata.count + 1
        } else {
            return walletHistorydata.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  showNoDataCell {
            let cell: NoDataFoundTblCell = tableView.dequeueReusableCell(withType: .noData, for: indexPath)
            cell.setMessage("No record found!")
            return cell
        }
        if isLoadingIndexPath(indexPath) {
            return LoadingCell.getIntance()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellType.walletHistory.cellId, for: indexPath) as! WalletHistoryTableViewCell
        let info = walletHistorydata[indexPath.row]
        cell.configureCell(info)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard isLoadingIndexPath(indexPath),
              self.walletHistorydata.count > 0 else {
            return
        }
        DispatchQueue.main.async {
            self.fetchNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return showNoDataCell ?  tableView.frame.size.height : UITableView.automaticDimension
    }
    
}
