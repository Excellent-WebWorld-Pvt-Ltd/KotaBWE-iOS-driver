//
//  CrediCardListVC.swift
//  DPS
//
//  Created by Gaurang on 01/10/21.
//  Copyright © 2021 Mayur iMac. All rights reserved.
//

import Foundation
import UIKit


class CrediCardListVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()


    var cardArray: [CardsList] = []
    var onSelectCard: ((_ card: CardsList) -> Void)?
    var onSelectPaymentMenthod: PaymentSelectionBlock?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(webserviceForCardList), for: .valueChanged)
        webserviceForCardList()
    }

    private func configUI() {
        setupNavigation(.normal(title: "Cards", leftItem: .back, hasNotification: false))
        tableView.registerNibCell(type: .crediCard)
        tableView.setHorizontalContentPadding(18)
    }
    
    private func deleteCard(AtIndexPath indexPath: IndexPath) {
        let cardInfo = cardArray[indexPath.row]
        tableView.beginUpdates()
        cardArray.remove(at: indexPath.row)
        webserviceForRemoveCardFromWallet(cardId : cardInfo.id)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }
    
    @objc private func webserviceForCardList() {
        if refreshControl.isRefreshing == false {
            refreshControl.beginRefreshing()
        }
        let cardList = CardList()
        cardList.driver_id = "\(Singleton.shared.driverId)"
        WebServiceCalls.CardInList(cardListModel: cardList) { (json, status) in
            self.refreshControl.endRefreshing()
            if status {
                let cardListDetails = AddCardModel.init(fromJson: json)
                self.cardArray = cardListDetails.cards
                SessionManager.shared.cards = cardListDetails
                self.tableView.reloadData()
                self.updateViewConstraints()
            } else {
                AlertMessage.showMessageForError("error")
            }
        }
    }

    private func webserviceForRemoveCardFromWallet(cardId : String) {
        let removeCardReqModel = RemoveCard()
        removeCardReqModel.driver_id = "\(Singleton.shared.driverId)"
        removeCardReqModel.card_id = cardId
        
        WebServiceCalls.RemoveCardFromList(removeCardModel: removeCardReqModel) { json, status in
            if !status {
                AlertMessage.showMessageForError("error")
            }
            self.webserviceForCardList()
        }
    }

    @objc private func addCardTapped() {
        let view = AddCardView { [weak self] in
            self?.webserviceForCardList()
        }
        let viewCtr = AppViewControllers.shared.bottomSheet(title: "Add Card", view: view)
        self.present(viewCtr, animated: true)
    }
}

// MARK: - Tableview datasource delegate
extension CrediCardListVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardArray.count
            
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        let button = ThemeDashedButton(type: .custom)
        footer.addSubview(button)
        button.setTitle("Add New Card", for: .normal)
        button.setAllSideContraints(.init(top: 15, left: 46, bottom: -15, right: -46))
        button.addTarget(self, action: #selector(addCardTapped), for: .touchUpInside)
        return footer
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        80.0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0.1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellType.crediCard.cellId, for: indexPath) as! CreditCardTableViewCell
        let model = cardArray[indexPath.row]
        cell.configureCell(model)
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        if onSelectPaymentMenthod != nil {
//            let cardId = cardArray[indexPath.row].id
//            onSelectPaymentMenthod?(.card, cardId)
//            guard let navVC = navigationController else {
//                return
//            }
//            let navViewCtrs = navVC.viewControllers
//            if let dueVC = navViewCtrs.first(where: {$0.isKind(of: WalleteViewController.self)}) {
//                navVC.popToViewController(dueVC, animated: true)
//            } else {
//                navVC.popToRootViewController(animated: true)
//            }
//        } else
        if onSelectCard != nil {
            self.navigationController?.popViewController(animated: true)
            onSelectCard?(cardArray[indexPath.row])
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        ThemeAlertVC.present(from: self, ofType: .confirmation(title: "Alert", message: "Are you sure you want to delete this card?", onConfirmed: { [weak self] in
            self?.deleteCard(AtIndexPath: indexPath)
        }))
    }

}
