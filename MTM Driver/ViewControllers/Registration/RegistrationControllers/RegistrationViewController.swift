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
    @IBOutlet weak var tvTermPrivacy: UITextView!
    @IBOutlet weak var btnAlreadyhaveAccount: UIButton!
    @IBOutlet weak var viewCountryPicker: CountryPickerView!
    @IBOutlet weak var viewBgLine: UIView!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtEmail: ThemeUnderLineTextField!
    
    // MARK: - ===== Variables ======
    var selectedCounty : Country?
    lazy var parameterArray = RegistrationParameter.shared

    
    //MARK: - ======= ViewController Life Cycle ======
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        setupCountryPicker()
        txtPhoneNumber.font = UIFont.regular(ofSize: 18.0)
        txtPhoneNumber.delegate = self
        txtPhoneNumber.delegate = self
    
        TermsAndCondtionSetup()
        setupRegisterVC()
        
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
        txtEmail.text = parameterArray.email
        txtPhoneNumber.text = parameterArray.mobile_no
        if parameterArray.shouldAutomaticallyMoveToPage(from: .registration) {
            let profileVC = AppViewControllers
                .shared
                .profile(forSettings: false)
            self.push(profileVC)
        }
    }
    
    //MARK:- ===== Validation ========
    func validateFields() -> Bool{
        
        let validationParameter :[(String?,String, ValidatiionType)] =  [(txtEmail.text,emailEmptyErrorString,.isEmpty),(txtEmail.text,emailErrorString,.email),
                                                                         (txtPhoneNumber.text,phoneNumberEmptyErrorString,.isEmpty),
                                                                         (txtPhoneNumber.text,phoneNumberErrorString, .isPhoneNumber)]
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
                .normal("Already a Showfa user? ", Colour: UIColor.black.withAlphaComponent(0.7))
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
        tvTermPrivacy.textAlignment = .center
        tvTermPrivacy.linkTextAttributes = [.foregroundColor: color]
        btnAlreadyhaveAccount.setAttributedTitle(FormattedText, for: .normal)
    }
    
    @IBAction func btnActionSignIn(_ sender: UnderlineTextButton) {
        if navigationViewController(contains: LoginVC.self) {
            self.goBack()
        } else {
            self.push(AppViewControllers.shared.login)
        }
    }
    
    @IBAction func btnNextClick(_ sender: Any) {
        guard validateFields() else { return }
         webserviceCallRegisterOTP()
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
        otpReqModel.email = txtEmail.text ?? ""
        otpReqModel.mobile_no = txtPhoneNumber.text ?? ""
        parameterArray.email = txtEmail.text ?? ""
        parameterArray.mobile_no = txtPhoneNumber.text ?? ""
        
        WebServiceCalls.registerOTP(otpModel:otpReqModel) { response, status in
            Loader.hideHUD()
            if status {
                print(response)
                AlertMessage.showMessageForSuccess(response["otp"].stringValue  + response["message"].stringValue)
                let otpVC = AppViewControllers.shared.otp
                otpVC.isFromRegister = true
                otpVC.strMobileNo = self.txtPhoneNumber.text ?? ""
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
        let validation: InputValidation = {
            if textField == txtEmail {
                return .email
            } else {
                return .mobile
            }
        }()
        return validation.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtPhoneNumber {
            viewBgLine.backgroundColor = .themeColor
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtPhoneNumber {
            viewBgLine.backgroundColor = .themeLightGray
        }
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
 

