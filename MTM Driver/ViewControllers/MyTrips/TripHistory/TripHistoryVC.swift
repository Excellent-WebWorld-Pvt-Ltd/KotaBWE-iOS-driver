//
//  TripHistoryVC.swift
//  Danfo_Driver
//
//  Created by Kinjal on 17/04/21.
//

import UIKit

enum tripHistory {
    case upcoming
    case past
}
class TripHistoryVC: BaseViewController {

    //MARK:- ======= Outlets ========
    @IBOutlet weak var viewUpComing: UIView!
    @IBOutlet weak var viewPast: UIView!
    @IBOutlet weak var upcommingButton: UIButton!
    @IBOutlet weak var pastButton: UIButton!
    @IBOutlet weak var tabSelectedView: UIView!
    @IBOutlet weak var tabLeftContraint: NSLayoutConstraint!
    
    //MARK:- ====== Variables =====
    var objTripHistory : tripHistory = .upcoming
    
    
    //MARK:- ======= View Conreller Life Cycle ========
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigation(.normal(title: "My Trips", leftItem: .back))
        viewUpComing.isHidden = false
        viewPast.isHidden = !viewUpComing.isHidden
        btnSetup()
        btnActionUpcoming(upcommingButton)
       
    }
    
    
    func btnSetup(){
        upcommingButton.setTitleColor(UIColor.white, for: .normal)
        upcommingButton.titleLabel?.font = UIFont.bold(ofSize: 16.0)
        pastButton.setTitleColor(UIColor.themeTextFieldFilledBorderColor, for: .normal)
        pastButton.titleLabel?.font = UIFont.bold(ofSize: 16.0)
        
    }
    
    
   //MARK:- ======= Btn Action UpComing ========
    @IBAction func btnActionUpcoming(_ sender: UIButton) {
        viewUpComing.isHidden = false
        viewPast.isHidden = !viewUpComing.isHidden
        objTripHistory = .upcoming
    }
    
    
    //MARK:- ======= Btn Action Past ========
    @IBAction func btnActionPast(_ sender: UIButton) {
          viewPast.isHidden = false
          viewUpComing.isHidden = !viewPast.isHidden
            objTripHistory = .past
    }
    
    
    @IBAction func tabButtonTapped(_ sender: UIButton) {
        tabLeftContraint.constant = sender.frame.origin.x
        [upcommingButton, pastButton].forEach({ button in
            button?.setTitleColor(button == sender ? .white : .themeTextFieldFilledBorderColor, for: .normal)
        })
        UIView.animate(withDuration: 0.3) {
            sender.superview?.superview?.layoutIfNeeded()
        }
       // self.tripType = sender == pastButton ? .past : .upcoming
       // self.loadNewData()
    
    }
    
}
