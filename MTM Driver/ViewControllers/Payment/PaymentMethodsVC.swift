//
//  PaymentMethodsVC.swift
//  MTM Driver
//
//  Created by Admin on 07/01/22.
//  Copyright © 2022 baps. All rights reserved.
//

import Foundation
import UIKit

typealias PaymentSelectionBlock = ((_ method: PaymentMethod, _ cardId: String?) -> Void)

class PaymentMethodsVC: BaseViewController {

    enum Operation {
        case none
        case paymentSelection(onSelectPaymentMenthod: PaymentSelectionBlock)
        case addMoney(amount: String)
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitButton: ThemeButton!

    var operation: Operation = .none

    private var allPaymentMethod: [PaymentMethod] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        switch self.operation{
        case .paymentSelection:
            self.allPaymentMethod = PaymentMethod.modeSelection
        case .addMoney:
            self.allPaymentMethod = PaymentMethod.typesForAddMoney
        default:
            self.allPaymentMethod = PaymentMethod.all
        }
        configUI()
    }

    private func configUI() {
        setupNavigation(.normal(title: "Payment Method", leftItem: .back, hasNotification: false))
        tableView.registerNibCell(type: .paymentMethod)
        tableView.setVerticalContentPadding(10)
        submitButton.isHidden = true
        /*if isFromPayment {
            tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
        }*/
    }

    @IBAction func submitTapped() {
        
    }

    private func presentPinSelectionView(amount: String, cardId: String) {
        ThemeAlertVC.present(from: self, ofType: .cardPin(onConfirmed: { [weak self] pin in
            self?.addMoneyUsingCard(amount: amount, cardId: cardId, pin: pin)
        }))
    }

    private func addMoneyUsingMPessa(amount: String) {
        let requestModel = AddMoneyRequestModel()
        requestModel.amount = amount
        requestModel.driver_id = Singleton.shared.driverId
        requestModel.payment_type = PaymentMethod.mPesa.rawValue
        webserviceToAddMoney(requestModel: requestModel)
    }
    
    private func addMoneyUsingJambopay(amount: String) {
        let requestModel = AddMoneyRequestModel()
        requestModel.amount = amount
        requestModel.driver_id = Singleton.shared.driverId
        requestModel.payment_type = PaymentMethod.jambopay.rawValue
        webserviceToAddMoney(requestModel: requestModel)
    }

    private func addMoneyUsingCard(amount: String, cardId: String, pin: String) {
        let requestModel = AddMoneyRequestModel()
        requestModel.amount = amount
        requestModel.driver_id = "\(Singleton.shared.driverId)"
        requestModel.payment_type = PaymentMethod.card.rawValue
        requestModel.card_id = cardId
        requestModel.pin = pin
        webserviceToAddMoney(requestModel: requestModel)
    }
    
    func handleWebPayment(_ paymentUrl: URL) {
        let webPageView = PaymentWebPageVC(paymentUrl, completion: { [unowned self] isPaid in
            if isPaid {
                AlertMessage.showMessageForSuccess("Money added successfully")
            } else {
                AlertMessage.showMessageForError("Transaction Failed")
            }
            self.goBack()
        })
        self.push(webPageView)
    }

    func webserviceToAddMoney(requestModel: AddMoneyRequestModel) {
        Loader.showHUD(with: Helper.currentWindow)
        WebServiceCalls.AddMoneytoWallet(addMoneyModel: requestModel) { (json, status) in
            Loader.hideHUD()
            if status {
                if let paymentUrlStr = json["payment_url"].string,
                   let paymentURL = URL(string: paymentUrlStr)  {
                    self.handleWebPayment(paymentURL)
                } else {
                    AlertMessage.showMessageForSuccess(json["message"].stringValue)
                    self.goBack()
                }
            } else {
                AlertMessage.showMessageForError(json["message"].string ?? "Error")
            }
        }
    }

}

// MARK: - Tableview datasource delegate
extension PaymentMethodsVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPaymentMethod.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellType.paymentMethod.cellId, for: indexPath) as! PaymentMethodTableViewCell
        cell.configureCell(allPaymentMethod[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = allPaymentMethod[indexPath.row]
        switch self.operation {
        case .none:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                tableView.deselectRow(at: indexPath, animated: false)
            }
            switch item {
            case .wallet:
                let viewCtr = AppViewControllers.shared.walletHistory
                push(viewCtr)
            case .card:
                let viewCtr = AppViewControllers.shared.creditCardList
                push(viewCtr)
            case .mPesa:
                break
            case .cash:
                break
            case .jambopay:
                break
            }
        case .addMoney(let amount):
            if item == .card {
                let viewCtr = AppViewControllers.shared.creditCardList
                viewCtr.onSelectCard = { [weak self] card in
                    self?.presentPinSelectionView(amount: amount, cardId: card.id)
                }
                push(viewCtr)
            } else if item == .jambopay {
                self.addMoneyUsingJambopay(amount: amount)
            } else if item == .mPesa {
                self.addMoneyUsingMPessa(amount: amount)
            }
        case .paymentSelection(let onSelectPaymentMenthod):
            if item == .card {
                let viewCtr = AppViewControllers.shared.creditCardList
                viewCtr.onSelectPaymentMenthod = onSelectPaymentMenthod
                push(viewCtr)
            } else {
                onSelectPaymentMenthod(item, nil)
                self.goBack()
            }
            
        }
    }
}
