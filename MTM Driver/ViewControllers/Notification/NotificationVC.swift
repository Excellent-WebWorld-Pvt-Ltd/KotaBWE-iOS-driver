//
//  NotificationVC.swift
//  DPS
//
//  Created by Gaurang on 12/11/21.
//  Copyright © 2021 Mayur iMac. All rights reserved.
//

import UIKit

class NotificationVC: BaseViewController {

    //MARK:- Variables
    private var tableView: UITableView!
    private var notificationArray: [NotificationInfo] = []
    private var showNoDataCell: Bool = false
    private var shouldShowLoadingCell = false
    private var page: Int = 1
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    //MARK:- View Life Cycle Methods

    override func loadView() {
        super.loadView()
        tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.registerNibCell(type: .noData)
        tableView.registerNibCell(type: .notification)
        tableView.setVerticalContentPadding(23)
        tableView.delegate = self
        tableView.dataSource = self
        view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation(.normal(title: "Notification", leftItem: .back, hasNotification: false))
        let clearButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearNotifications))
        navigationItem.rightBarButtonItem = clearButton
        webServiceToGetNotification()
    }

    private func fetchNextPage() {
        page += 1
        webServiceToGetNotification()
    }

    private func isLoadingIndexPath(_ indexPath: IndexPath) -> Bool {
        guard shouldShowLoadingCell else { return false }
        return indexPath.row == self.notificationArray.count
    }

    func webServiceToGetNotification() {
        
        let strURLFinal = "\(NetworkEnvironment.apiURL)\(ApiKey.notificationList.rawValue)\("\(Singleton.shared.driverId)")/\(page)"
        WebService.shared.getMethod(url: URL(string: strURLFinal)!, httpMethod: .get) { json, status in
            if status {
                do {
                    let data = try json["data"].rawData()
                    let array = try JSONDecoder().decode([NotificationInfo].self, from: data)
                    self.notificationArray += array
                    self.showNoDataCell = self.notificationArray.isEmpty
                    self.shouldShowLoadingCell = array.isNotEmpty
                    self.tableView.reloadData()
                } catch {
                    AlertMessage.showMessageForError("Something went wrong")
                }
            } else {
                AlertMessage.showMessageForError(json["message"].stringValue)
            }
        }
    }
    
    @objc private func clearNotifications() {
        self.notificationArray = []
        self.showNoDataCell = true
        self.page = 1
        self.tableView.reloadData()
        WebServiceCalls.clearNotification { json, status in
            if status == false {
                self.webServiceToGetNotification()
            }
        }
    }

}

extension NotificationVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showNoDataCell {
            return 1
        }
        return shouldShowLoadingCell ? notificationArray.count + 1 : notificationArray.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if showNoDataCell {
            let cell: NoDataFoundTblCell = tableView.dequeueReusableCell(withType: .noData, for: indexPath)
            cell.setMessage("No notification!")
            return cell
        }
        if isLoadingIndexPath(indexPath) {
            return LoadingCell.getIntance()
        }
        let cell: NotificationCell = tableView.dequeueReusableCell(withType: .notification, for: indexPath) as! NotificationCell
        cell.configuration(notificationArray[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard isLoadingIndexPath(indexPath), self.notificationArray.count > 0 else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.fetchNextPage()
        }
    }
}


class LoadingCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    private func setupSubviews() {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(indicator)
        indicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        indicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        indicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        indicator.startAnimating()

    }

    class func getIntance() -> LoadingCell {
        let cell = LoadingCell(style: .default, reuseIdentifier: "loadingCell")
        cell.isUserInteractionEnabled = false
        return cell
    }
}
