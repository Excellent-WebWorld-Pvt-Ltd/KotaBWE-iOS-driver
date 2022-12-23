//
//  WithDrawSuccessfulVC.swift
//  Danfo_Driver
//
//  Created by Kinjal on 26/04/21.
//

import UIKit

class WithDrawSuccessfulVC: UIViewController {

    //MARK:- ====== Outlets ======
    @IBOutlet weak var viewBG: UIView!
    
    
    //MARK:- ====== Variables ========
    public var userTappedOKClosure: (() -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
          
        viewBG.layoutIfNeeded()
        viewBG.roundCorners([.topLeft,.topRight], radius: 10.0)
    }
    
    
    //MARK:- ====== Btn Action OK ====
     @IBAction func btnActionOK(_ sender: UIButton) {
          
        self.dismiss(animated: true) {
           if let btnTapped = self.userTappedOKClosure {
               btnTapped()
           }
        }
    }
}
