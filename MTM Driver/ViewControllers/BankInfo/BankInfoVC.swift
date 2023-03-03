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
   
    @IBOutlet weak var txtBankName: CustomViewOutlinedTxtField!
    
    @IBOutlet weak var txtBankHolderName: CustomViewOutlinedTxtField!
    
    @IBOutlet weak var txtAccountNumber: CustomViewOutlinedTxtField!
    
    
    @IBOutlet weak var txtBranchCode: CustomViewOutlinedTxtField!
    
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
        self.setlocalization()
        self.btnNext.setTitle(isFromSetting ? "Save".localized : "Next".localized, for: .normal)
        self.navigationController?.navigationBar.isHidden = false
        setupNavigation(.normal(title: "Bank Info".localized, leftItem: .back, hasNotification: false))
    }
    
    //MARK:- ===== Navigation  =======
    func navigateToVC(){
        if parameterArray.shouldAutomaticallyMoveToPage(from: .bank) {
            push(AppViewControllers.shared.vehicleInfo)
        }
    }
    
    func setlocalization(){
        self.txtBankName.textField.placeholder = "Bank Name".localized
        self.txtBankName.textField.label.text = "Bank Name".localized
        self.txtBankHolderName.textField.placeholder = "Account Holder Name".localized
        self.txtBankHolderName.textField.label.text = "Account Holder Name".localized
        self.txtAccountNumber.textField.placeholder = "Account Number".localized
        self.txtAccountNumber.textField.label.text = "Account Number".localized
        self.txtBranchCode.textField.placeholder = "Branch Code".localized
        self.txtBranchCode.textField.label.text = "Branch Code".localized
    }
    
    //MARK:- ========= Setup Textfield =====
     func setupTextField() {
         
         txtAccountNumber.textField.keyboardType = .phonePad
         txtAccountNumber.textField.font = UIFont.regular(ofSize: 18.0)
         txtAccountNumber.textField.delegate = self
         
         if let registerParams = SessionManager.shared.registrationParameter {
             txtBankHolderName.textField.text = registerParams.account_holder_name
             txtBankName.textField.text = registerParams.bank_name
             txtBranchCode.textField.text = registerParams.bank_branch
             txtAccountNumber.textField.text = registerParams.account_number
         } else if let profile = SessionManager.shared.userProfile {
             txtBankHolderName.textField.text = profile.responseObject.accountHolderName ?? ""
             txtBankName.textField.text = profile.responseObject.bankName ?? ""
             txtBranchCode.textField.text = profile.responseObject.bankBranch ?? ""
             txtAccountNumber.textField.text = profile.responseObject.accountNumber ?? ""
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
        accountData.account_holder_name = txtBankHolderName.textField.text ?? ""
        accountData.bank_name = txtBankName.textField.text ?? ""
        accountData.account_number = txtAccountNumber.textField.text ?? ""
        accountData.bank_branch = txtBranchCode.textField.text ?? ""
    
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
    private func isValidInputes() -> Bool {
      
        let bankNameValidation = InputValidation.nonEmpty.isValid(input: txtBankName.textField.unwrappedText, field: "bank name".localized)
        let bankHolderNameValidation = InputValidation.nonEmpty.isValid(input: txtBankHolderName.textField.unwrappedText, field: "account holder name".localized)
        
        txtBankName.textField.leadingAssistiveLabel.text = bankNameValidation.error
        txtBankName.textField.setOutlineColor(bankNameValidation.isValid ? .themeTextFieldDefaultBorderColor : .red, for: .normal)
        
        txtBankHolderName.textField.leadingAssistiveLabel.text = bankHolderNameValidation.error
        txtBankHolderName.textField.setOutlineColor(bankHolderNameValidation.isValid ? .themeTextFieldDefaultBorderColor : .red, for: .normal)
        
        
        let accountValidation = InputValidation.nonEmpty.isValid(input: txtAccountNumber.textField.unwrappedText, field: "account number".localized)
         txtAccountNumber.textField.leadingAssistiveLabel.text = accountValidation.error
         txtAccountNumber.textField.setOutlineColor(accountValidation.isValid ? .themeTextFieldDefaultBorderColor : .red, for: .normal)
        
        let brnachCodeValidation = InputValidation.nonEmpty.isValid(input: txtBranchCode.textField.unwrappedText, field: "branch code".localized)
        txtBranchCode.textField.leadingAssistiveLabel.text = brnachCodeValidation.error
        txtBranchCode.textField.setOutlineColor(brnachCodeValidation.isValid ? .themeTextFieldDefaultBorderColor : .red, for: .normal)
        
        if bankNameValidation.isValid && bankHolderNameValidation.isValid && accountValidation.isValid && brnachCodeValidation.isValid {
            if !isFromSetting {
                parameterArray.account_holder_name = txtBankHolderName.textField.text ?? ""
                parameterArray.bank_name = txtBankName.textField.text ?? ""
                parameterArray.bank_branch = txtBranchCode.textField.text ?? ""
                parameterArray.account_number = txtAccountNumber.textField.text ?? ""
                parameterArray.setNextRegistrationIndex(from: .bank)
                SessionManager.shared.registrationParameter = parameterArray
            } else {
                let loginData = SessionManager.shared.userProfile
                let parameter = loginData?.responseObject.driverDocs
                parameterArray.driver_id = parameter?.driver_id ?? ""
            }
            return true
        }else {
            return false
        }
    }
    
    //MARK:- ===== Btn Action Save ====
    @IBAction func btnActionSave(_ sender: UIButton) {
            guard isValidInputes() else { return }
            if isFromSetting{
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
