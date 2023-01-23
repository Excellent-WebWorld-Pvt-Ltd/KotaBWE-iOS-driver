//
//  LoginVC.swift
//  DSP Driver
//
//  Created by Admin on 06/10/21.
//  Copyright © 2021 baps. All rights reserved.
//

import UIKit
import CountryPickerView
import SwiftyJSON

class LoginVC: UIViewController {
    
    //MARK:- ==== outlet =======
    @IBOutlet weak var txtEmail: CustomViewOutlinedTxtField!
    
    @IBOutlet weak var txtPassword: CustomViewOutlinedTxtField!
    
    
    @IBOutlet weak var btnHidePassword: UIButton!
   
    @IBOutlet weak var btnForgotPassword: UnderlineTextButton!
    
    @IBOutlet weak var tvTermPrivacy: UITextView!
    @IBOutlet weak var viewCountryPicker: CountryPickerView!
    @IBOutlet weak var btnNotUser: UnderlineTextButton!
    @IBOutlet weak var viewBGLine: UIView!
  //  @IBOutlet weak var txtPhoneNumber: UITextField!
    
    
    //MARK:- ===== Variables =====
    var selectedCounty : Country?
    var registerPram = RegistrationParameter.shared
    var iconPasswordClick = true
    var objLoginData : LoginModel!
    var objResponseJSON : JSON!
    
    
    //MARK:- ==== View Controller Life Cycle =====
    override func viewDidLoad() {
        super.viewDidLoad()
#if targetEnvironment(simulator)
  //      txtPhoneNumber.text = "9876543210"
#endif
  //      txtPhoneNumber.font = UIFont.regular(ofSize: 18.0)
   //     txtPhoneNumber.delegate = self
   //     setupCountryPicker()
        setupTextfields()
        formattedTextSetup()
        setupInitView()
        setupRegisterVC()
    
    }
    
    func setupTextfields() {
        
        txtEmail.textField.delegate = self
        txtPassword.textField.delegate = self
        
        txtEmail.textField.keyboardType = .emailAddress
        txtEmail.textField.autocapitalizationType = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
   
    func setupInitView() {
        txtEmail.textField.updateInputType(.email)
        txtPassword.textField.updateInputType(.password)
        txtPassword.textField.setRightPaddingPoints(25)
        self.isPasswordSecure(isSecure: true)
    }
    
    //MARK:- ==== Registration ======
    func setupRegisterVC() {
        guard let registrationParams = SessionManager.shared.registrationParameter else {
            return
        }
        RegistrationParameter.shared = registrationParams
        let registerVC = AppViewControllers.shared.registration
        registerVC.parameterArray = RegistrationParameter.shared
        self.push(registerVC, true)
    }
    
    //MARK:- ==== Terms And Condition =====
    func formattedTextSetup(){
        let formattedText = NSMutableAttributedString()
        formattedText
            .normal("Not a Kota user?  ", Colour: UIColor.black.withAlphaComponent(0.7), 14)
            .bold("Sign Up")
        
        let forgotformattedText = NSMutableAttributedString()
        forgotformattedText
            .medium("Forgot Password?")
        
        btnNotUser.setAttributedTitle(formattedText, for: .normal)
        btnForgotPassword.setAttributedTitle(forgotformattedText, for: .normal)
    }
    
    
    //MARK:- ===== Validation =======
    func validateFields() -> Bool{
        
        let validationParameter :[(String?,String, ValidatiionType)] =  [(txtEmail.textField.text,emailEmptyErrorString,.isEmpty),
                                                                         (txtEmail.textField.text,emailErrorString,.email),
                                                                         (txtPassword.textField.text,passwordEmptyErrorString,.isEmpty),
                                                                         (txtPassword.textField.text,passwordValidErrorString,.password)]
        guard Validator.validate(validationParameter) else{
            return false
        }
        return true
    }
    func validations() -> (Bool) {
        
        let emailValidation = InputValidation.email.isValid(input: txtEmail.textField.unwrappedText, field: "email address")
            txtEmail.textField.leadingAssistiveLabel.text = emailValidation.error
        let passwordValidation = InputValidation.password.isValid(input: txtPassword.textField.unwrappedText, field: "password")
            txtPassword.textField.leadingAssistiveLabel.text = passwordValidation.error ?? ""
        txtPassword.textField.setOutlineColor(passwordValidation.isValid ? .themeTextFieldDefaultBorderColor : .red, for: .normal)
        txtEmail.textField.setOutlineColor(emailValidation.isValid ? .themeTextFieldDefaultBorderColor : .red, for: .normal)
        
//        if model.lat.isBlank || model.lng.isBlank {
//            AlertMessage.showMessageForError("Please enable your location to move forward")
//        }
        if emailValidation.isValid && passwordValidation.isValid {
            return true
        }else{
            return false
        }
        
    }
    
    
    //MARK:- ===== Btn Action Next =====
    @IBAction func btnActionNext(_ sender: UIButton) {
        guard validations() else { return }
        webServiceCallLogin()
    }
    
    
    
    @IBAction func btnForgotPassword(_ sender: Any) {
        
        let forgotVC = AppViewControllers.shared.forgotpassword
        self.navigationController?.pushViewController(forgotVC, animated: true)
        
    }
    
    
    
    @IBAction func btnActionPasswordShow(_ sender: Any) {
        iconPasswordClick = !iconPasswordClick
        self.isPasswordSecure(isSecure:iconPasswordClick)
    }
    func isPasswordSecure(isSecure:Bool){
        if iconPasswordClick {
            txtPassword.textField.isSecureTextEntry = true
            btnHidePassword.setImage(UIImage(named: "ic_hidePasswordRed"), for: .normal)
        } else {
            txtPassword.textField.isSecureTextEntry = false
            btnHidePassword.setImage(UIImage(named: "ic_showPasswordRed"), for: .normal)
        }
    }
    
    @IBAction func btnActionRegister(_ sender: UnderlineTextButton) {
        if navigationViewController(contains: RegistrationViewController.self) {
            self.goBack()
        } else {
            let registerVC = AppViewControllers.shared.registration
            self.navigationController?.pushViewController(registerVC, animated: true)
        }
    }
    
//    //MARK:- ====== Country Picker setup ===
//    func setupCountryPicker(){
//        viewCountryPicker.delegate = self
//        viewCountryPicker.dataSource = self
//        viewCountryPicker.textColor = .black
//        viewCountryPicker.font = UIFont.regular(ofSize: 15.0)
//        viewCountryPicker.setCountryByCode("KE")
//        viewCountryPicker.flagSpacingInView = 10
//        viewCountryPicker.hostViewController = self
//        viewCountryPicker.showCountryCodeInView = false
//        viewCountryPicker.isUserInteractionEnabled = false
//
//    }
    
    //MARK:- === Save Login Data =====
    func saveLoginData(responseObj:JSON!){
        SessionManager.shared.saveSession(json: responseObj)
    }
    
    //MARK:- ===== Webservice Call For Login  ====
    func webServiceCallLogin(){

        let loginModel : loginModel = loginModel()
        loginModel.email = txtEmail.textField.text ?? ""//txtPhoneNumber.text ?? ""
        loginModel.password = txtPassword.textField.text ?? ""
        loginModel.device_type = "ios"
        guard let location = Singleton.shared.driverLocation else {
            LocationManager.shared.openSettingsDialog()
            return
        }
        loginModel.lat = "\(location.latitude)"
        loginModel.lng = "\(location.longitude)"
        loginModel.device_token = SessionManager.shared.fcmToken ?? ""
        Loader.showHUD(with: Helper.currentWindow)
        WebServiceCalls.login(loginModel: loginModel) { response, Status in
            Loader.hideHUD()
            if Status {
                print(response)
                let obj = LoginModel(fromJson: response)
                self.saveLoginData(responseObj: response)
//                AlertMessage.showMessageForSuccess(obj.message)
//                print(obj.otp)
//                let otpVC = AppViewControllers.shared.otp
//                otpVC.strOTP = obj.otp
//                otpVC.objResponseJSON = response
//                otpVC.strMobileNo = obj.responseObject.mobileNo
//                self.navigationController?.pushViewController(otpVC, animated: true)
            }
            else{
                ThemeAlertVC.present(from: self, ofType: .simple(title: "Alert", message: response.getApiMessage()))

            }
        }
    }
}

extension LoginVC {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            var validation: InputValidation?
            switch textField {
            case txtEmail.textField:
                validation = .email
           
            case txtPassword.textField:
                validation = .password
                if (string == " " || string == "  ") {
                    return false
                }
           
            default:
                break
            }
            if let validation = validation {
                return validation.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
            }
            return true
        }
}



//MARK:- Country Picker Methods
extension LoginVC : CountryPickerViewDelegate,CountryPickerViewDataSource {
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        print(country)
        self.selectedCounty = country
    }
    func sectionTitleForPreferredCountries(in countryPickerView: CountryPickerView) -> String? {
        return "Select country"
    }
}


extension LoginVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
//        if textField == txtPhoneNumber {
//            viewBGLine.backgroundColor = .themeColor
//        }
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        return InputValidation.mobile.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
//    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField == txtPhoneNumber {
//            viewBGLine.backgroundColor = .themeLightGray
//        }
    }
}

extension NSMutableAttributedString {
    
    public func setAsLink(textToFind:String, linkURL:String) {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSAttributedString.Key.link, value: linkURL, range: foundRange)
        }
    }
}
