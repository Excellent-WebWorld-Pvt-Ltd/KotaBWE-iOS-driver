//
//  ForgotPasswordViewController.swift
//  Pappea Driver
//
//  Created by Mayur iMac on 13/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ForgotPasswordViewController: BaseViewController {

    // ----------------------------------------------------
    // MARK: - Outlets
    // ----------------------------------------------------
  
    @IBOutlet weak var txtEmail: CustomViewOutlinedTxtField!
    
    
    // ----------------------------------------------------
    // MARK: - Base Methods
    // ----------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmail.textField.keyboardType = .emailAddress
        txtEmail.textField.autocapitalizationType = .none
        self.setupNavigation(.normal(title: "Forgot Password".localized, leftItem: .back))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func setLocalization(){
        self.txtEmail.textField.placeholder = "Email".localized
        self.txtEmail.textField.label.text = "Email".localized
    }

    // ----------------------------------------------------
    // MARK: - Actions
    // ----------------------------------------------------
    @IBAction func btnGoBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnResetPassword(_ sender: UIButton) {
//        self.goBack()
        guard validations() else { return }
        webserviceForForrgotPassword()
       
    }
    //MARK:- ===== Validation =======
    func validateFields() -> Bool{
        
        let validationParameter :[(String?,String, ValidatiionType)] =  [(txtEmail.textField.text,emailEmptyErrorString.localized,.isEmpty),
                                                                         (txtEmail.textField.text,emailErrorString.localized,.email)]
        guard Validator.validate(validationParameter) else{
            return false
        }
        return true
    }
    
    func validations() -> (Bool) {
        
        let emailValidation = InputValidation.email.isValid(input: txtEmail.textField.unwrappedText, field: "email address".localized)
        txtEmail.textField.leadingAssistiveLabel.text = emailValidation.error
        txtEmail.textField.setOutlineColor(emailValidation.isValid ? .themeTextFieldDefaultBorderColor : .red, for: .normal)
        
        if emailValidation.isValid{
            return true
        }else{
            return false
        }
        
    }
    
    // ----------------------------------------------------
    // MARK: - Webservice Methods
    // ----------------------------------------------------
    func webserviceForForrgotPassword() {
        Loader.showHUD()
        WebServiceCalls.forgotPassword(strType: ["email": txtEmail.textField.text!]) { (response, status) in
            Loader.hideHUD()
            if status {
                AlertMessage.showMessageForSuccess(response["message"].stringValue)
                self.goBack()
            } else {
                AlertMessage.showMessageForError(response["message"].stringValue)
            }
        }
    }
    
    
}
