//
//  BankInfoVC.swift
//  DSP Driver
//
//  Created by Admin on 21/10/21.
//  Copyright © 2021 baps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class BankInfoVC: BaseViewController {

    //MARK:- ===== Outlets ======
    @IBOutlet weak var txtBankName: ThemeUnderLineTextField!
    @IBOutlet weak var txtBankHolderName: ThemeUnderLineTextField!
    @IBOutlet weak var txtBranchCode: ThemeUnderLineTextField!
    @IBOutlet weak var txtAccountNumber: ThemeUnderLineTextField!
    @IBOutlet weak var btnNext: UIButton!
    
    //MARK:- ===== Variables =======
    var isFromSetting = false
    var parameterArray = RegistrationParameter.shared

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        if !isFromSetting {
            navigateToVC()
        }
        self.btnNext.setTitle(isFromSetting ? "Save" : "Next", for: .normal)
        self.navigationController?.navigationBar.isHidden = false
        setupNavigation(.normal(title: "Bank Info", leftItem: .back, hasNotification: false))
    }
    
    
    //MARK:- ===== Vaidation ========
     func validateFields() -> Bool{

        let validationParameter :[(String?,String, ValidatiionType)] = [(txtBankName.text,bankNameErrorString, .isEmpty),(txtBankHolderName.text,accountHolderNameErrorString, .isEmpty),
                                                                         
                                                                         (txtAccountNumber.text,accountNumberErrorString, .numeric),
                                                                         (txtBranchCode.text,branchCodeErrorString,.isEmpty)]
        guard Validator.validate(validationParameter) else{
            return false
        }
        
        if !isFromSetting {
            parameterArray.account_holder_name = txtBankHolderName.text!
            parameterArray.bank_name = txtBankName.text!
            parameterArray.bank_branch = txtBranchCode.text!
            parameterArray.account_number = txtAccountNumber.text!
            parameterArray.setNextRegistrationIndex(from: .bank)
            SessionManager.shared.registrationParameter = parameterArray
        } else {
            let loginData = SessionManager.shared.userProfile
            let parameter = loginData?.responseObject.driverDocs
            parameterArray.driver_id = parameter?.driver_id ?? ""
        }
        
        return true
    }
    
    //MARK:- ===== Navigation  =======
    func navigateToVC(){
        if parameterArray.shouldAutomaticallyMoveToPage(from: .bank) {
            push(AppViewControllers.shared.vehicleInfo)
        }
    }
    
    //MARK:- ========= Setup Textfield =====
     func setupTextField() {
         if let registerParams = SessionManager.shared.registrationParameter {
             txtBankHolderName.text = registerParams.account_holder_name 
             txtBankName.text = registerParams.bank_name 
             txtBranchCode.text = registerParams.bank_branch 
             txtAccountNumber.text = registerParams.account_number 
         } else if let profile = SessionManager.shared.userProfile {
             txtBankHolderName.text = profile.responseObject.accountHolderName ?? ""
             txtBankName.text = profile.responseObject.bankName ?? ""
             txtBranchCode.text = profile.responseObject.bankBranch ?? ""
             txtAccountNumber.text = profile.responseObject.accountNumber ?? ""
         }
        
    }
    
    //MARK:- ====
    func webserviceForUpdateAccount() {
        
        Loader.showHUD(with: self.view)
        var loginModelDetails: LoginModel = LoginModel()
        if let model = SessionManager.shared.userProfile {
            loginModelDetails = model
        }
        let accountData : UpdateAccountData = UpdateAccountData()
        accountData.driver_id = loginModelDetails.responseObject.id
        accountData.account_holder_name = txtBankHolderName.text ?? ""
        accountData.bank_name = txtBankName.text ?? ""
        accountData.account_number = txtAccountNumber.text ?? ""
        accountData.bank_branch = txtBranchCode.text ?? ""
    
        WebServiceCalls.updateAccount(transferMoneyModel: accountData) { (response, status) in
            Loader.hideHUD()
            print("updateAccount: \n", response)
            if status {
                
                let loginModelDetails = LoginModel.init(fromJson: response)
                Singleton.shared.driverId = loginModelDetails.responseObject.id
                Singleton.shared.isDriverOnline = !(loginModelDetails.responseObject.duty == "0")
                SessionManager.shared.userProfile = loginModelDetails
                self.navigationController?.popViewController(animated: true)
            } else {
                AlertMessage.showMessageForError(response["message"].arrayValue.first?.stringValue ?? response["message"].stringValue)
            }
        }
    }
    
    
    //MARK:- ===== Btn Action Save ====
    @IBAction func btnActionSave(_ sender: UIButton) {
            guard validateFields() else { return }
            if isFromSetting == true {
                webserviceForUpdateAccount()
            }
            else {
                self.push(AppViewControllers.shared.vehicleInfo)
            }
    }
    
}

// MARK: - TextField delegate
extension BankInfoVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if IQKeyboardManager.shared.canGoNext {
            IQKeyboardManager.shared.goNext()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
