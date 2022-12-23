//
//  ChatVC+Tableview.swift
//  DSP Driver
//
//  Created by Admin on 26/11/21.
//  Copyright © 2021 baps. All rights reserved.
//

import Foundation
import UIKit


//MARK:- TableView DataSource and delegate
extension ChatVC : UITableViewDataSource , UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return arrSection.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSection[section].chatData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let objIndex = arrSection[indexPath.section].chatData[indexPath.row]
        if objIndex.isSender {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SenderTblCell", for: indexPath) as!  SenderTblCell
            cell.lblMessage.text = objIndex.message
            cell.lblTime.text = objIndex.time
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverTblCell", for: indexPath) as!  ReceiverTblCell
            cell.lblMessage.text = objIndex.message
            cell.lblTime.text = objIndex.time
            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        view.backgroundColor = UIColor.black
        let label = UILabel(frame: CGRect(x: 10, y: 5, width: tableView.frame.size.width, height: 50))
        label.font = FontBook.semibold.font(ofSize: 16.0)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.text =  arrSection[section].day
        view.addSubview(label)
        view.backgroundColor = UIColor.white
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

