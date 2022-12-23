//
//  PromoCodeVC.swift
//  DPS
//
//  Created by Gaurang on 20/10/21.
//  Copyright © 2021 Mayur iMac. All rights reserved.
//

import UIKit

class PromoCodeVC: BaseViewController {

    //MARK:- ===== Outlets =======
    @IBOutlet weak var promoCodeTextField: ThemeUnderLineTextField!
    @IBOutlet weak var tableView: UITableView!

    var onSelectedCode: ((_ code: String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
       // webserviceForCardList()
    }

    private func configUI() {
        setupNavigation(.normal(title: "Promo Codes", leftItem: .back, hasNotification: false))
        tableView.registerNibCell(type: .promoCode)

        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Apply", for: .normal)
        button.titleLabel?.font = FontBook.bold.font(ofSize: 18)
        promoCodeTextField.rightView = button
        promoCodeTextField.rightViewMode = .always
    }
}

extension PromoCodeVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellType.promoCode.cellId,
                                                 for: indexPath) as! PromoCodeTableViewCell
        return cell
    }
}
