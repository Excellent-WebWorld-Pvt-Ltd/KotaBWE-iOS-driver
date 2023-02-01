//
//  RegistrationViewController.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 19/04/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import SSSpinnerButton
import CountryPickerView

class RegistrationViewController: BaseViewController, UIScrollViewDelegate , UIImagePickerControllerDelegate{
  
    // MARK: - ===== Outlets =======
    @IBOutlet weak var btnHidePassword: UIButton!
    @IBOutlet weak var btnHideConfomPassword: UIButton!
    @IBOutlet weak var tvTermPrivacy: UITextView!
    @IBOutlet weak var btnAlreadyhaveAccount: UIButton!
    @IBOutlet weak var viewCountryPicker: CountryPickerView!
    @IBOutlet weak var viewBgLine: UIView!
  //  @IBOutlet weak var txtPhoneNumber: UITextField!
 //   @IBOutlet weak var txtEmail: ThemeUnderLineTextField!
    @IBOutlet weak var txtPhoneNumber: CustomViewOutlinedTxtField!
    
    @IBOutlet weak var txtPhone: CustomViewOutlinedTxtField!
    @IBOutlet weak var txtPassword: CustomViewOutlinedTxtField!
    
    @IBOutlet weak var txtConformPassword: CustomViewOutlinedTxtField!
    
    @IBOutlet weak var txtEmail: CustomViewOutlinedTxtField!
    @IBOutlet weak var btnCheckBoxTerms: UIButton!
    
    
    // MARK: - ===== Variables ======
    var selectedCounty : Country?
    lazy var parameterArray = RegistrationParameter.shared
    private lazy var registerParameters = RegistrationParameter.shared
    var iconPasswordClick = true
    var iconConformPasswordClick = true
    
    //MARK: - ======= ViewController Life Cycle ======
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
//        setupCountryPicker()
        txtPhone.textField.text = Singleton.shared.countryCode
        setupTextfields()
        TermsAndCondtionSetup()
        setupRegisterVC()
        self.isPasswordSecure(isSecure: true)
        self.isConformPasswordSecure(isSecure: true)
        txtPassword.textField.setRightPaddingPoints(25)
        txtConformPassword.textField.setRightPaddingPoints(25)
    }
    
    func setupTextfields() {
        
        txtPhoneNumber.textField.keyboardType = .phonePad
        txtPhoneNumber.textField.delegate = self
        txtEmail.textField.delegate = self
        txtPassword.textField.delegate = self
        txtConformPassword.textField.delegate = self
        txtEmail.textField.keyboardType = .emailAddress
        txtEmail.textField.autocapitalizationType = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setupRegisterVC() {
        if SessionManager.shared.registrationParameter != nil {
            navigateToVC()
        }
    }
    
    func navigateToVC(){
        txtEmail.textField.text = parameterArray.email
        txtPassword.textField.text = parameterArray.password
        registerParameters.password = txtPassword.textField.text!
        txtPhoneNumber.textField.text =  parameterArray.mobile_no
        if parameterArray.shouldAutomaticallyMoveToPage(from: .registration) {
            let profileVC = AppViewControllers
                .shared
                .profile(forSettings: false)
            self.push(profileVC)
        }
    }
    
    //MARK:- ===== Validation ========
    func validateFields() -> Bool{
        
        let validationParameter :[(String?,String, ValidatiionType)] =  [
            (txtEmail.textField.text,emailEmptyErrorString,.isEmpty),(txtEmail.textField.text,emailErrorString,.email),
            (txtPhoneNumber.textField.text,phoneNumberEmptyErrorString,.isEmpty),
            (txtPassword.textField.text,passwordEmptyErrorString,.isEmpty),
            (txtPassword.textField.text,passwordValidErrorString,.password),
            (txtConformPassword.textField.text,confirmPasswordEmptyErrorString,.isEmpty),
            (txtConformPassword.textField.text,confirmPasswordValidErrorString,.password),
            (txtPhoneNumber.textField.text,phoneNumberErrorString, .isPhoneNumber)]
        guard Validator.validate(validationParameter) else{
            return false
        }
        return true
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
    
    
    func TermsAndCondtionSetup(){
        let FormattedText = NSMutableAttributedString()
        
              FormattedText
                .normal("Already a Kota user? ", Colour: UIColor.black.withAlphaComponent(0.7), 14)
                .bold("Sign In")
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
        tvTermPrivacy.linkTextAttributes = [.foregroundColor: color]
        btnAlreadyhaveAccount.setAttributedTitle(FormattedText, for: .normal)
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
    func isConformPasswordSecure(isSecure:Bool){
        if iconConformPasswordClick {
            txtConformPassword.textField.isSecureTextEntry = true
            btnHideConfomPassword.setImage(UIImage(named: "ic_hidePasswordRed"), for: .normal)
        } else {
            txtConformPassword.textField.isSecureTextEntry = false
            btnHideConfomPassword.setImage(UIImage(named: "ic_showPasswordRed"), for: .normal)
        }
    }
    
    private func isValidInputes() -> Bool {

           let emailValidation = InputValidation.email.isValid(input: txtEmail.textField.unwrappedText, field: "email")
           txtEmail.textField.leadingAssistiveLabel.text = emailValidation.error
           txtEmail.textField.setOutlineColor(emailValidation.isValid ? .themeTextFieldDefaultBorderColor : .red, for: .normal)
           
           let mobileValidation = InputValidation.mobile.isValid(input: txtPhoneNumber.textField.unwrappedText, field: "mobile number")
            txtPhoneNumber.textField.leadingAssistiveLabel.text = mobileValidation.error
            txtPhoneNumber.textField.setOutlineColor(mobileValidation.isValid ? .themeTextFieldDefaultBorderColor : .red, for: .normal)

           let passwordValidation = InputValidation.password.isValid(input: txtPassword.textField.unwrappedText, field: "password")
           txtPassword.textField.leadingAssistiveLabel.text = passwordValidation.error
           txtPassword.textField.setOutlineColor(passwordValidation.isValid ? .themeTextFieldDefaultBorderColor : .red, for: .normal)
           
           var confirmPasswordValidation = InputValidation.nonEmpty.isValid(input: txtConformPassword.textField.unwrappedText, field: "confirm password")
           txtConformPassword.textField.leadingAssistiveLabel.text = confirmPasswordValidation.error
           txtConformPassword.textField.setOutlineColor(confirmPasswordValidation.isValid ? .themeTextFieldDefaultBorderColor : .red, for: .normal)
           if confirmPasswordValidation.isValid {
               if txtConformPassword.textField.text != txtPassword.textField.text {
                   txtConformPassword.textField.leadingAssistiveLabel.text = "Your password and confirmation password do not match."
                   confirmPasswordValidation.isValid = false
                   txtConformPassword.textField.setOutlineColor(.red, for: .normal)
               }else{
                   txtConformPassword.textField.leadingAssistiveLabel.text = ""
                   txtConformPassword.textField.setOutlineColor(.themeTextFieldDefaultBorderColor, for: .normal)
               }
           }
        
        if !btnCheckBoxTerms.isSelected {
                    AlertMessage.showMessageForError("Please accept terms & conditions and privacy policy")
                }
        
           if emailValidation.isValid && mobileValidation.isValid && passwordValidation.isValid && confirmPasswordValidation.isValid && btnCheckBoxTerms.isSelected{
               return true
           }else{
               return false
           }
       }
    
    @IBAction func btnActionSignIn(_ sender: UnderlineTextButton) {
        if navigationViewController(contains: LoginVC.self) {
            self.goBack()
        } else {
            self.push(AppViewControllers.shared.login)
        }
    }
    
    @IBAction func checkBoxTermsConditionClicked(_ sender: Any) {
        btnCheckBoxTerms.isSelected = !btnCheckBoxTerms.isSelected
        self.btnCheckBoxTerms.setImage(btnCheckBoxTerms.isSelected ? UIImage(named: "CheckBox") : UIImage(named: "emptyCheckbox"), for: .normal)
    }
    @IBAction func btnNextClick(_ sender: Any) {
        
//        let otpVC = AppViewControllers.shared.otp
//        otpVC.isFromRegister = true
//        otpVC.strMobileNo = self.txtPhoneNumber.textField.text ?? ""
//        otpVC.strOTP = ""
//        self.navigationController?.pushViewController(otpVC, animated: true)
        
        guard isValidInputes() else { return }
        webserviceCallRegisterOTP()

    }
    @IBAction func btnActionPasswordShow(_ sender: Any) {
        iconPasswordClick = !iconPasswordClick
        self.isPasswordSecure(isSecure:iconPasswordClick)
    }
    
    @IBAction func btnActionConformPasswordShow(_ sender: Any) {
        iconConformPasswordClick = !iconConformPasswordClick
        self.isConformPasswordSecure(isSecure:iconConformPasswordClick)
    }
    
    
    func setupViews(){
        let main_string = "Already a Showfa user? Sign In"
        let string_to_color = "Sign In"
        let range = (main_string as NSString).range(of: string_to_color)
        let attribute = NSMutableAttributedString.init(string: main_string)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.themeBlack.withAlphaComponent(0.7) , range: range)
        attribute.addAttribute(NSAttributedString.Key.font, value: FontBook.regular.font(ofSize: 14.0) , range: range)
        btnAlreadyhaveAccount.setAttributedTitle(attribute, for: .normal)
        btnAlreadyhaveAccount.isUserInteractionEnabled = false
        btnAlreadyhaveAccount.backgroundColor =  UIColor.clear
    }
  
    //MARK: - ====== Webservice call Register OTP ========
    func webserviceCallRegisterOTP(){
        Loader.showHUD(with: Helper.currentWindow)
        let otpReqModel = OTPModel()
        otpReqModel.email = txtEmail.textField.text ?? ""
        otpReqModel.mobile_no = txtPhoneNumber.textField.text ?? ""
        parameterArray.email = txtEmail.textField.text ?? ""
        parameterArray.password = txtPassword.textField.text ?? ""
        parameterArray.mobile_no = txtPhoneNumber.textField.text ?? ""
        
        WebServiceCalls.registerOTP(otpModel:otpReqModel) { response, status in
            Loader.hideHUD()
            if status {
                AlertMessage.showMessageForSuccess(response["message"].stringValue)
                let otpVC = AppViewControllers.shared.otp
                otpVC.isFromRegister = true
                otpVC.strMobileNo = self.txtPhoneNumber.textField.text ?? ""
                otpVC.strOTP = response["otp"].stringValue
                self.navigationController?.pushViewController(otpVC, animated: true)
            }
            else{
                AlertMessage.showMessageForError(response["message"].stringValue)
             }
        }
    }

    func webserviceForVehicleList()
    {
//        Loader.showHUD(with: Helper.currentWindow)
        let param: [String: Any] = ["": ""]
        WebServiceCalls.VehicleTypeListApi(strType: param) { (json, status) in
//            Loader.hideHUD()
            if status {

                print(json)
                let info = VehicleListResultModel.init(fromJson: json)
                Singleton.shared.vehicleListData = info
                
            }
            else
            {
                AlertMessage.showMessageForError(json["message"].stringValue)
            }

            self.webserviceForCompanyList()
        }
    }
    
    func webserviceForCompanyList()
    {
//        Loader.showHUD(with: Helper.currentWindow)

        let param: [String: Any] = ["": ""]
        WebServiceCalls.companyList(strType: param) { (json, status) in
//            Loader.hideHUD()
//             Loader.hideHUD()
            if status
            {
                print(json)
                let companyListDetails = CompanyListModel.init(fromJson: json)
                Singleton.shared.companyListData = companyListDetails
            }
            else
            {
                AlertMessage.showMessageForError(json["message"].stringValue)
            }
        }
    }
}

extension RegistrationViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            var validation: InputValidation?
            switch textField {
            case txtEmail.textField:
                validation = .email
            case txtPhoneNumber.textField:
                validation = .mobile
            case txtPassword.textField:
                validation = .password
                if (string == " " || string == "  ") {
                    return false
                }
            case txtConformPassword.textField:
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
extension RegistrationViewController : CountryPickerViewDelegate,CountryPickerViewDataSource {
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        print(country)
        self.selectedCounty = country
    }
    func sectionTitleForPreferredCountries(in countryPickerView: CountryPickerView) -> String? {
            return "Select country"
    }
}
 

