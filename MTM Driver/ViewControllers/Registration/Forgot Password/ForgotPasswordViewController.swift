//
//  ForgotPasswordViewController.swift
//  Pappea Driver
//
//  Created by Mayur iMac on 13/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ForgotPasswordViewController: UIViewController {

    // ----------------------------------------------------
    // MARK: - Outlets
    // ----------------------------------------------------
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    
    
    // ----------------------------------------------------
    // MARK: - Base Methods
    // ----------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func btnGoBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    // ----------------------------------------------------
    // MARK: - Actions
    // ----------------------------------------------------
    @IBAction func btnResetPassword(_ sender: UIButton) {
        
        if txtEmail.text!.isBlank {
            AlertMessage.showMessageForError("Please enter email id")
        } else {
            webserviceForForrgotPassword()
        }
    }
    
    
    // ----------------------------------------------------
    // MARK: - Webservice Methods
    // ----------------------------------------------------
    func webserviceForForrgotPassword() {
        WebServiceCalls.forgotPassword(strType: ["email": txtEmail.text!]) { (response, status) in
            if status {
                AlertMessage.showMessageForSuccess(response["message"].stringValue)
                
            } else {
                AlertMessage.showMessageForError(response["message"].stringValue)
            }
        }
    }
    
    
}
