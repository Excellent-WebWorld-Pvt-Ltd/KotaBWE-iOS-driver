//
//  ChangePasswordVC.swift
//  MTM Driver
//
//  Created by Sanket Panchal on 13/01/23.
//  Copyright © 2023 baps. All rights reserved.
//

import UIKit

class ChangePasswordVC: BaseViewController {
    
    
    @IBOutlet weak var txtOldPassword: CustomViewOutlinedTxtField!
        @IBOutlet weak var txtNewPassword: CustomViewOutlinedTxtField!
        @IBOutlet weak var txtConfirmNewPassword: CustomViewOutlinedTxtField!
        @IBOutlet weak var btnSubmit: UIButton!
        @IBOutlet weak var btnHideShowOldPassword: UIButton!
        @IBOutlet weak var btnHideShowNewPassword: UIButton!
        @IBOutlet weak var btnHideShowConfirmNewPassword: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation(.normal(title: "Change Password", leftItem: .back, hasNotification: false))
                setupTextFields()
        
    }
    
    func setupTextFields() {
            txtOldPassword.textField.isSecureTextEntry = true
            txtNewPassword.textField.isSecureTextEntry = true
            txtConfirmNewPassword.textField.isSecureTextEntry = true
            txtOldPassword.textField.setRightPaddingPoints(30)
            txtNewPassword.textField.setRightPaddingPoints(30)
            txtConfirmNewPassword.textField.setRightPaddingPoints(30)
        }
    
    @IBAction func btnSubmitTapped(_ sender: UIButton) {
        }
        
        @IBAction func btnOldPasswordTapped(_ sender: UIButton) {
            isSecureText(txtOldPassword.textField, btnHideShowOldPassword)
        }
        
        @IBAction func btnNewPasswordTapped(_ sender: UIButton) {
            isSecureText(txtNewPassword.textField, btnHideShowNewPassword)
        }
        
        @IBAction func btnConfirmNewPasswordTapped(_ sender: UIButton) {
            isSecureText(txtConfirmNewPassword.textField, btnHideShowConfirmNewPassword)
        }
   
    
}
