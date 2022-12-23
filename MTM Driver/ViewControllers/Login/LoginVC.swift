//
//  LoginVC.swift
//  DSP Driver
//
//  Created by Admin on 06/10/21.
//  Copyright © 2021 baps. All rights reserved.
//

import UIKit
import CountryPickerView

class LoginVC: UIViewController {
    
    //MARK:- ==== outlet =======
    @IBOutlet weak var tvTermPrivacy: UITextView!
    @IBOutlet weak var viewCountryPicker: CountryPickerView!
    @IBOutlet weak var btnNotUser: UnderlineTextButton!
    @IBOutlet weak var viewBGLine: UIView!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    
    
    //MARK:- ===== Variables =====
    var selectedCounty : Country?
    var registerPram = RegistrationParameter.shared
    
    
    //MARK:- ==== View Controller Life Cycle =====
    override func viewDidLoad() {
        super.viewDidLoad()
#if targetEnvironment(simulator)
        txtPhoneNumber.text = "9876543210"
#endif
        txtPhoneNumber.font = UIFont.regular(ofSize: 18.0)
        txtPhoneNumber.delegate = self
        setupCountryPicker()
        TermsAndCondtionSetup()
        setupRegisterVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
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
    func TermsAndCondtionSetup(){
        let formattedText = NSMutableAttributedString()
        formattedText
            .normal("Not a Showfa user? ", Colour: UIColor.black.withAlphaComponent(0.7))
            .bold("Register")
        let termAttributed = NSMutableAttributedString()
        let color = UIColor.hexStringToUIColor(hex: "#7D7D7D").withAlphaComponent(0.7)
        termAttributed
            .normal("By creating an account, you agree to our\n", Colour: color, 14)
            .Semibold("Terms of Service")
            .normal(" and ", Colour:color, 14)
            .Semibold("Privacy Policy")
        termAttributed.setAsLink(textToFind: "Terms of Service", linkURL: Singleton.shared.termsAndConditionURL)
        termAttributed.setAsLink(textToFind: "Privacy Policy", linkURL: Singleton.shared.privacyURL)
        tvTermPrivacy.attributedText = termAttributed
        tvTermPrivacy.textAlignment = .center
        tvTermPrivacy.linkTextAttributes = [.foregroundColor: color]
        btnNotUser.setAttributedTitle(formattedText, for: .normal)
    }
    
    //MARK:- ===== Validation =======
    func validateFields() -> Bool{
        let validation = InputValidation.mobile.isValid(input: txtPhoneNumber.unwrappedText, field: "mobile number")
        if validation.isValid == false {
            AlertMessage.showMessageForError(validation.error ?? "")
        }
        return validation.isValid
    }
    
    
    //MARK:- ===== Btn Action Next =====
    @IBAction func btnActionNext(_ sender: UIButton) {
        guard validateFields() else { return }
        webServiceCallLogin()
    }
    
    
    @IBAction func btnActionRegister(_ sender: UnderlineTextButton) {
        if navigationViewController(contains: RegistrationViewController.self) {
            self.goBack()
        } else {
            let registerVC = AppViewControllers.shared.registration
            self.navigationController?.pushViewController(registerVC, animated: true)
        }
    }
    
    //MARK:- ====== Country Picker setup ===
    func setupCountryPicker(){
        viewCountryPicker.delegate = self
        viewCountryPicker.dataSource = self
        viewCountryPicker.textColor = .black
        viewCountryPicker.font = UIFont.regular(ofSize: 15.0)
        viewCountryPicker.setCountryByCode("KE")
        viewCountryPicker.flagSpacingInView = 10
        viewCountryPicker.hostViewController = self
        viewCountryPicker.showCountryCodeInView = false
        viewCountryPicker.isUserInteractionEnabled = false
        
    }
    
    //MARK:- ===== Webservice Call For Login  ====
    func webServiceCallLogin(){
        
        let loginModel : loginModel = loginModel()
        
        if txtPhoneNumber.text!.isEmail
        {
            loginModel.username = txtPhoneNumber.text ?? ""
        }
        else
        {
            if txtPhoneNumber.text!.count < 9
            {
                
                AlertMessage.showMessageForError(phoneNumberErrorString)
                
            }
            else
            {
                loginModel.username = "254" + txtPhoneNumber.text!
            }
        }
        
        loginModel.username = txtPhoneNumber.text ?? ""
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
                AlertMessage.showMessageForSuccess(obj.message)
                print(obj.otp)
                let otpVC = AppViewControllers.shared.otp
                otpVC.strOTP = obj.otp
                otpVC.objResponseJSON = response
                otpVC.strMobileNo = self.txtPhoneNumber.text ?? ""
                self.navigationController?.pushViewController(otpVC, animated: true)
            }
            else{
                ThemeAlertVC.present(from: self, ofType: .simple(title: "Alert", message: response.getApiMessage()))
                
            }
        }
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
        
        if textField == txtPhoneNumber {
            viewBGLine.backgroundColor = .themeColor
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return InputValidation.mobile.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtPhoneNumber {
            viewBGLine.backgroundColor = .themeLightGray
        }
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
