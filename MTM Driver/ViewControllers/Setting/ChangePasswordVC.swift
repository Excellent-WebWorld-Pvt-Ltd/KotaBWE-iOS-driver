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
    
    func isValidInputes() -> (Bool) {
        let oldPasswordValidation = InputValidation.password.isValid(input: self.txtOldPassword.textField.unwrappedText, field: "old password")
        let newPasswordValidation = InputValidation.password.isValid(input: self.txtNewPassword.textField.unwrappedText, field: "new password")
        var newConfirmPasswordValidation = InputValidation.nonEmpty.isValid(input: self.txtConfirmNewPassword.textField.unwrappedText, field: "confirm new password")
        txtOldPassword.textField.leadingAssistiveLabel.text = oldPasswordValidation.error
        txtOldPassword.textField.setOutlineColor(oldPasswordValidation.isValid ? .themeTextFieldDefaultBorderColor : .red, for: .normal)
        txtNewPassword.textField.leadingAssistiveLabel.text = newPasswordValidation.error
        txtNewPassword.textField.setOutlineColor(newPasswordValidation.isValid ? .themeTextFieldDefaultBorderColor : .red, for: .normal)
        
        txtConfirmNewPassword.textField.leadingAssistiveLabel.text = newConfirmPasswordValidation.error
        txtConfirmNewPassword.textField.setOutlineColor(newConfirmPasswordValidation.isValid ? .themeTextFieldDefaultBorderColor : .red, for: .normal)
        
        if newConfirmPasswordValidation.isValid {
            if txtNewPassword.textField.text != txtConfirmNewPassword.textField.text {
                txtConfirmNewPassword.textField.leadingAssistiveLabel.text = "Your new password and confirmation new password do not match."
                newConfirmPasswordValidation.isValid = false
                txtConfirmNewPassword.textField.setOutlineColor(.red, for: .normal)
            }else{
                txtConfirmNewPassword.textField.leadingAssistiveLabel.text = ""
                txtConfirmNewPassword.textField.setOutlineColor(.themeTextFieldDefaultBorderColor, for: .normal)
            }
        }
        
        if oldPasswordValidation.isValid && newPasswordValidation.isValid && newConfirmPasswordValidation.isValid {
            return true
        }else{
            return false
        }
    }
    
    @IBAction func btnSubmitTapped(_ sender: UIButton) {
        let requestModel = ChangePassword()
        requestModel.old_password = txtOldPassword.textField.unwrappedText
        requestModel.new_password = txtNewPassword.textField.unwrappedText
        requestModel.driver_id = Singleton.shared.driverId
        
        guard isValidInputes() else {
            return
        }
        webserviceCallForChangePassword(requestModel)
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

//MARK: - Web service method
extension ChangePasswordVC{
    func webserviceCallForChangePassword(_ requestModel: ChangePassword) {
        Loader.showHUD()
        WebServiceCalls.changePassword(ChangePasswordModel: requestModel) { (json, status) in
            Loader.hideHUD()
            if status {
                self.goBack()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    AlertMessage.showMessageForSuccess(json["message"].stringValue)
                }
                
            } else{
                AlertMessage.showMessageForError(json["message"].stringValue)
            }
        }
    }
}
