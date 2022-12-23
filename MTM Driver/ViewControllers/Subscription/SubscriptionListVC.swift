//
//  SubscriptionListVC.swift
//  MTM Driver
//
//  Created by Gaurang on 27/09/22.
//  Copyright © 2022 baps. All rights reserved.
//

import UIKit

class SubscriptionListVC: BaseViewController {
    @IBOutlet weak var subscriptionContentView: UIView!
    @IBOutlet weak var expiredDateLabel: ThemeLabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var planList: [SubscriptionDetailsModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation(.normal(title: "Membership", leftItem: .back, hasNotification: false))
        tableView.contentInset.top = 10
        tableView.registerNibCell(type: .subscription)
        reloadData(true)
        self.fetchSubscriptionPlans()
    }
    
    private func reloadData(_ isFirstTime: Bool = false) {
        if let subscriptionDetails = Singleton.shared.subscriptionInfo {
            subscriptionContentView.isHidden = false
            setSubscriptionInfo(with: subscriptionDetails)
        } else {
            subscriptionContentView.isHidden = true
        }
        tableView.reloadData()
    }
    
    private func setSubscriptionInfo(with info: SubscriptionDetailsModel) {
        let endDate = DateFormatHelper.standard.convert(to: .fullDateTime, string: info.endDate ?? "") ?? "--"
        expiredDateLabel.text = "Valid till \(endDate)"
    }
    
    private func fetchSubscriptionPlans() {
        Loader.showHUD(with: view)
        WebServiceCalls.subscriptionList { json, _ in
            Loader.hideHUD()
            let model = SubscriptionDetailsBase(json: json)
            if model.status {
                Singleton.shared.subscriptionInfo = model.driverSubscription
                self.planList = model.data
                self.reloadData()
            } else {
                self.goBack()
                UtilityClass.showAlert(message: model.message ?? "")
            }
        }
    }
    
    private func purchaseSubscription(_ info: SubscriptionDetailsModel) {
        let viewCtr = AppViewControllers.shared.paymentMethod(for: .paymentSelection(onSelectPaymentMenthod: { [unowned self] method, cardId in
            let reqModel = SubscriptionPurchaseRequest(subscription_id: info.id, payment_type: method.rawValue, cardId: cardId ?? "")
            self.purchaseSubscriptionRequest(reqModel)
        }))
        self.push(viewCtr)
    }
    
    private func handleWebPayment(_ paymentUrl: URL, subscriptionInfo: SubscriptionDetailsModel?) {
        let webPageView = PaymentWebPageVC(paymentUrl, completion: { [unowned self] isPaid in
            if isPaid {
                AlertMessage.showMessageForSuccess("Membership purchased successfully")
                Singleton.shared.subscriptionInfo = subscriptionInfo
            } else {
                AlertMessage.showMessageForError("Transaction Failed")
            }
            UIView.animate(withDuration: 0.3) {
                self.reloadData()
            }
        })
        self.push(webPageView)
    }
    
    private func purchaseSubscriptionRequest(_ reqModel: SubscriptionPurchaseRequest) {
        Loader.showHUD(with: view)
        WebServiceCalls.subscriptionPurchase(model: reqModel) { json, _ in
            Loader.hideHUD()
            let model = SubscriptionPurchaseBase(json: json)
            if model.status {
                if let paymentUrlStr = json["payment_url"].string,
                   let paymentURL = URL(string: paymentUrlStr)  {
                    self.handleWebPayment(paymentURL, subscriptionInfo: model.data)
                } else {
                    Singleton.shared.subscriptionInfo = model.data
                    AlertMessage.showMessageForSuccess(model.message ?? "")
                }
            } else {
                UtilityClass.showAlert(message: model.message ?? "")
            }
            UIView.animate(withDuration: 0.3) {
                self.reloadData()
            }
        }
    }
    
}

// MARK: - TableView methods
extension SubscriptionListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        planList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SubscriptionCell = tableView.dequeueReusableCell(withType: .subscription, for: indexPath)
        let info = planList[indexPath.row]
        cell.configCell(info, subscriptionAction: { [unowned self] in
            self.purchaseSubscription(info)
        })
        return cell
    }
    
}
