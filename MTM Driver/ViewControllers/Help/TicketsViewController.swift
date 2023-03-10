//
//  TicketsViewController.swift
//  Peppea
//
//  Created by EWW074 on 22/01/20.
//  Copyright © 2020 Mayur iMac. All rights reserved.
//

import UIKit

class TicketsViewController: BaseViewController {

   
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variable Declaration
    var aryData = [Ticket]()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation(.normal(title: "Tickets".localized, leftItem: .back, hasNotification: false))
        tableView.registerNibCell(type: .noData)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        webserviceForGettingAllTicketList()
    }
    
    // MARK: - Actions
    
    // MARK: - Custom Methods
    func webserviceForGettingAllTicketList() {
        Loader.showHUD(with: view)
    
        WebServiceCalls.TicketListService(strURL: Singleton.shared.driverId) { (response, status) in
            Loader.hideHUD()
            print(response)
            if status {
                let res = TicketListingModel(fromJson: response)
                self.aryData = res.tickets
                
                if self.aryData.count != 0 {
                    self.tableView.isHidden = false
                    
                } else {
//                    self.tableView.isHidden = true
                }
                self.tableView.reloadData()
                
            } else {
            }
        }
    }
}

extension TicketsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryData.count == 0 ? 1 : aryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if aryData.count == 0{
            let cell: NoDataFoundTblCell = tableView.dequeueReusableCell(withType: .noData, for: indexPath)
            cell.setMessage("No data found.".localized)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TicketsCell", for: indexPath) as! TicketsCell
            cell.selectionStyle = .none
            let currentItem = aryData[indexPath.row]
           cell.setupData(currentItem: currentItem)
            return cell
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 70
//    }
}


class TicketsCell: UITableViewCell {
    
    @IBOutlet var viewBackground: UIView!
    @IBOutlet var lblTicketId: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupData(currentItem: Ticket) {
        lblTicketId.text = "\("Ticket Id".localized):- " + currentItem.ticketId // "Loading..."
        lblTitle.text = currentItem.ticketTitle // "Loading..."
        
        if currentItem.status == "0" {
            lblStatus.text = "Pending".localized
        } else if currentItem.status == "1" {
            lblStatus.text = "Processing".localized
        } else {
            lblStatus.text = "Resolved".localized
        }
        
    }
    
//    0 - Pending
//    1 - Processing
//    else Resolved
    
}
