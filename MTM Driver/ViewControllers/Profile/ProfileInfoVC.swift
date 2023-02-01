//
//  ProfileInfoVC.swift
//  DSP Driver
//
//  Created by Admin on 28/10/21.
//  Copyright © 2021 baps. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import ActionSheetPicker_3_0
import CountryPickerView
import IQKeyboardManagerSwift
import GooglePlaces

class ProfileInfoVC: BaseViewController {
    
    //MARK:- ===== Outlets ========
    var parameterArray = RegistrationParameter.shared
    
    //MARK:- ===== Outlets =======
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var firstlastNameStackView: UIStackView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var viewImgProfile: UIView!
    @IBOutlet weak var imgProfileHeight: NSLayoutConstraint!
//    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewPhone: UIView!
    
    @IBOutlet weak var txtEmail: CustomViewOutlinedTxtField!
    
  //  @IBOutlet weak var txtOwnerName: UITextField!
    @IBOutlet weak var viewStackMobileNo: UIStackView!

//    @IBOutlet weak var txtFirstName: UITextField!
//    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtFirstName: CustomViewOutlinedTxtField!
    
    @IBOutlet weak var txtLastName: CustomViewOutlinedTxtField!
    
    @IBOutlet weak var txtMobileNumber: CustomViewOutlinedTxtField!
    
    @IBOutlet weak var txtDOB: CustomViewOutlinedTxtField!
    
    @IBOutlet weak var txtAddress: CustomViewOutlinedTxtField!
    @IBOutlet weak var txtCode: CustomViewOutlinedTxtField!
    @IBOutlet weak var txtPostalCode: CustomViewOutlinedTxtField!
    @IBOutlet weak var btnNext: UIButton!
    
    var isFromSetting = false
    var selectedCounty : Country?
    var pickedImage: UIImage?
    var selectedBirthDate: Date?
    private var selectedAddress: LocationInfoWithCoordinates? {
            didSet {
                self.txtAddress.textField.text = selectedAddress?.address
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let date = Calendar.current.date(byAdding: .year, value: -18, to: Date())
//                selectedBirthDate = date
//        txtDOB.textField.text = selectedBirthDate?.getDateString(format: .fullDate)
        self.txtCode.textField.text = Singleton.shared.countryCode
        setupTextfields()
        initialSetup()
        mainStackView.setCustomSpacing(16, after: viewStackMobileNo)
      
        if !self.isFromSetting {
            mainStackView.setCustomSpacing(18, after: firstlastNameStackView)
        }
        mainStackView.setCustomSpacing(20, after: txtAddress)
        
//        imageSetup()
        if !isFromSetting {
            navigateToVC()
        }
        self.btnNext.setTitle(isFromSetting ? "Save" : "Next", for: .normal)
        self.navigationController?.navigationBar.isHidden = false
        self.setupNavigation(.normal(title: "Profile Details", leftItem: .back))    }

    func imageSetup() {
        imgProfile.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
        imgProfile.layer.masksToBounds = true
        imgProfile.contentMode = .scaleToFill
        imgProfile.layer.borderWidth = 1
    }
    func setupTextfields() {
        
        txtAddress.textField.delegate = self
        txtMobileNumber.textField.keyboardType = .phonePad
        txtMobileNumber.textField.delegate = self
        txtEmail.textField.keyboardType = .emailAddress
        txtEmail.textField.autocapitalizationType = .none
    }
    
    func initialSetup() {
        // txtdriverRole.delegate = self
        txtEmail.textField.delegate = self
        txtFirstName.textField.delegate = self
        txtPostalCode.textField.delegate = self
        txtLastName.textField.delegate = self
        txtDOB.textField.delegate = self
        txtAddress.textField.delegate = self
        txtPostalCode.textField.keyboardType = .numberPad
        if !isFromSetting {
            viewEmail.isHidden = true
            viewPhone.isHidden = true
        }
        else {
            viewEmail.isHidden = false
            viewPhone.isHidden = false
        }
        
        setProfile()
        //setDobField()
        if isFromSetting{
            if let profile = SessionManager.shared.userProfile {
               //            txtdriverRole.text = profile.driver_role.replacingOccurrences(of: "_", with: " ").capitalized ?? ""
               guard let url = profile.responseObject.profileImage else { return }
               let imgurl = NetworkEnvironment.baseImageURL + url
               UtilityClass.imageGet(url:imgurl, img: imgProfile, UIColor.black, UIImage(named: "Profile") ?? UIImage())
               //txtdriverRole.text = "Driver"
               txtEmail.textField.isUserInteractionEnabled = false
               txtEmail.textField.text = profile.responseObject.email
               txtMobileNumber.textField.text = profile.responseObject.mobileNo
               // txtMobileNumber.isUserInteractionEnabled = false
               txtFirstName.textField.text = profile.responseObject.firstName ?? ""
               txtLastName.textField.text = profile.responseObject.lastName ?? ""
               selectedBirthDate = profile.responseObject.dob.getDate(format: .digitDate)
               txtDOB.textField.text = selectedBirthDate?.getDateString(format: .fullDate)
               txtAddress.textField.text = profile.responseObject.address ?? ""
                txtPostalCode.textField.text = profile.responseObject.postalCode ?? ""
           }
        }else{
            if let parameterArray = SessionManager.shared.registrationParameter {
                print(parameterArray as Any)
                if let savedImage = SessionManager.shared.savedProfileImage {
                    imgProfile.image = savedImage
                    RegistrationImageParameter.shared.profileImage = savedImage
                }
                txtFirstName.textField.text = parameterArray.first_name
                txtLastName.textField.text = parameterArray.last_name
                self.selectedBirthDate = parameterArray.dob.getDate(format: .digitDate)
                txtDOB.textField.text = selectedBirthDate?.getDateString(format: .fullDate)
                txtAddress.textField.text = parameterArray.address
                txtEmail.textField.text = parameterArray.email
                txtMobileNumber.textField.text = parameterArray.mobile_no
            }
        }
        
    }
    
    
    
    @IBAction func openPicImage(_ sender : UIButton){
        
        ImagePickerViewController.open(from: self, allowEditing: true) { [unowned self] image in
            self.imgProfile.image = image
            self.pickedImage = image
            if isFromSetting == false {
                RegistrationImageParameter.shared.profileImage = image
                SessionManager.shared.savedProfileImage = image
            }
        }
    }
    
    
    func openDatePicker(){
        ThemeDatePickerViewController.open(from: self, title: "Select Birthdate", type: .birthDate, selectedDate: selectedBirthDate) { [unowned self] date in
            self.selectedBirthDate = date
            self.txtDOB.textField.text = self.selectedBirthDate?.getDateString(format: .fullDate) ?? ""
        }
    }
    
    
    private func setProfile(){
        imgProfile.layer.cornerRadius = imgProfileHeight.constant / 2
        //        imgProfile.layer.borderWidth = 3
        //        imgProfile.layer.borderColor = UIColor.lightGray.cgColor
        
        imgProfile.clipsToBounds = true
        viewImgProfile.layer.shadowRadius = (imgProfileHeight.constant - 10) / 2
        viewImgProfile.layer.shadowColor = UIColor.lightGray.cgColor
        viewImgProfile.layer.shadowOpacity = 1
        
    }
    private func setDobField(){
        let imageView = UIImageView(frame: CGRect(x: 0, y: 6, width: 30, height: 30))
        imageView.image = UIImage(named: "calendar")
        txtDOB.textField.rightView = imageView
        txtDOB.textField.rightViewMode = .always
    }
    
    func navigateToVC(){
        if parameterArray.shouldAutomaticallyMoveToPage(from: .profile) {
            let bankInfoVC = AppViewControllers.shared.bankInfo
            self.push(bankInfoVC)
        }
    }
    
    // MARK: - Webservice Methods
    // ----------------------------------------------------
    func webserviceForSavePersonalProfile(uerData: UpdatePersonalInfo) {
        Loader.showHUD(with: self.view)
        WebServiceCalls.updatePersonal(requestModel: uerData, image: pickedImage, imageParamName: "profile_image") { (response, status) in
                Loader.hideHUD()
            if status {
                let loginModelDetails = LoginModel.init(fromJson: response)
                SessionManager.shared.userProfile = loginModelDetails
                Singleton.shared.userProfile = loginModelDetails
                UserDefaults.standard.synchronize()
                AlertMessage.showMessageForSuccess(loginModelDetails.message)
                NotificationCenter.postCustom(.updateProfile)
                self.navigationController?.popViewController(animated: true)
            } else {
                AlertMessage.showMessageForError(response["message"].arrayValue.first?.stringValue ?? response["message"].stringValue)
            }
        }
    }
    
    //MARK:- ======= Btn Action ProfileInfo ====
    @IBAction func btnActionProfileInfo(_ sender: UIButton) {
        guard isValidInputes() else {
            return
        }
        if self.isFromSetting {
            let objData = UpdatePersonalInfo()
            objData.address = self.txtAddress.textField.text ?? ""
            objData.driver_id = Singleton.shared.driverId
            objData.dob = self.selectedBirthDate?.getDateString(format: .digitDate) ?? ""
            objData.email = self.txtEmail.textField.text ?? ""
            objData.first_name = self.txtFirstName.textField.text ?? ""
            objData.last_name = self.txtLastName.textField.text ?? ""
            objData.mobile_no = self.txtMobileNumber.textField.text ?? ""
            objData.payment_method = "cash"//"cash"
            objData.postal_code = txtPostalCode.textField.text!
            self.webserviceForSavePersonalProfile(uerData: objData)
        }else {
            parameterArray.first_name = txtFirstName.textField.text!
            parameterArray.last_name =  txtLastName.textField.text!
            parameterArray.postal_code = txtPostalCode.textField.text!
            parameterArray.dob = selectedBirthDate?.getDateString(format: .digitDate) ?? ""
            parameterArray.address = txtAddress.textField.text!
            let loginData = SessionManager.shared.userProfile
            let parameter = loginData?.responseObject.driverDocs
            parameterArray.driver_id = parameter?.driver_id ?? ""
            parameterArray.setNextRegistrationIndex(from: .profile)
            SessionManager.shared.registrationParameter = parameterArray
            let bankInfoVC = AppViewControllers.shared.bankInfo
            self.push(bankInfoVC)
        }
    }
    
    private func isValidInputes() -> Bool {
            let firstNameValidation = InputValidation.name.isValid(input: txtFirstName.textField.unwrappedText, field: "first name")
            let lastNameValidation = InputValidation.name.isValid(input: txtLastName.textField.unwrappedText, field: "last name")
            let postalValidation = InputValidation.nonEmpty.isValid(input: txtPostalCode.textField.unwrappedText, field: "Postal code")
            txtFirstName.textField.leadingAssistiveLabel.text = firstNameValidation.error
            txtFirstName.textField.setOutlineColor(firstNameValidation.isValid ? .themeTextFieldDefaultBorderColor : .red, for: .normal)
            txtLastName.textField.leadingAssistiveLabel.text = lastNameValidation.error
            txtLastName.textField.setOutlineColor(lastNameValidation.isValid ? .themeTextFieldDefaultBorderColor : .red, for: .normal)
            if txtDOB.textField.text == "" {
                txtDOB.textField.leadingAssistiveLabel.text = dobErrorString
                txtDOB.textField.setOutlineColor(UIColor.red, for: .normal)
            }else {
                txtDOB.textField.leadingAssistiveLabel.text = ""
                txtDOB.textField.setOutlineColor(.themeTextFieldDefaultBorderColor, for: .normal)
            }
            let addressValidation = InputValidation.nonEmpty.isValid(input: txtAddress.textField.unwrappedText, field: "address")
            txtAddress.textField.leadingAssistiveLabel.text = addressValidation.error
            txtAddress.textField.setOutlineColor(addressValidation.isValid ? .themeTextFieldDefaultBorderColor : .red, for: .normal)
            txtPostalCode.textField.leadingAssistiveLabel.text = postalValidation.error
            txtPostalCode.textField.setOutlineColor(postalValidation.isValid ? .themeTextFieldDefaultBorderColor : .red, for: .normal)
        let emailValidation = InputValidation.email.isValid(input: txtEmail.textField.unwrappedText, field: "email address")
        let mobileValidation = InputValidation.mobile.isValid(input: txtMobileNumber.textField.unwrappedText, field: "mobile number")
        if isFromSetting {
            txtEmail.textField.leadingAssistiveLabel.text = emailValidation.error
            txtEmail.textField.setOutlineColor(emailValidation.isValid ? .themeTextFieldDefaultBorderColor : .red, for: .normal)
            txtMobileNumber.textField.leadingAssistiveLabel.text = mobileValidation.error
            txtMobileNumber.textField.setOutlineColor(mobileValidation.isValid ? .themeTextFieldDefaultBorderColor : .red, for: .normal)
        }
        
        if !isFromSetting && RegistrationImageParameter.shared.profileImage == nil {
            AlertMessage.showMessageForError("Please select profile image")
        }
        
            if !isFromSetting && firstNameValidation.isValid && postalValidation.isValid && lastNameValidation.isValid  && RegistrationImageParameter.shared.profileImage != nil && txtDOB.textField.text != nil && addressValidation.isValid {
                return true
            }else if isFromSetting && firstNameValidation.isValid && postalValidation.isValid && lastNameValidation.isValid  && SessionManager.shared.userProfile != nil && txtDOB.textField.text != nil && addressValidation.isValid && mobileValidation.isValid{
                return true
            }else {
                return false
            }
       
        
//        if !isFromSetting && ownerNameValidation.isValid && ownerEmailValidation.isValid && ownermobileValidation.isValid && RegistrationImageParameter.shared.profileImage == nil {
//            AlertMessage.showMessageForError("Please select profile image")
//            return false
//        }
  //      return true
        }
    
    
    private func validation() -> Bool {
        
        let validationParameter2: [(String?,String, ValidatiionType)] = [
            (txtFirstName.textField.text,firstNameErrorString, .isEmpty),
            (txtLastName.textField.text,lastNameErrorString, .isEmpty),
            
            (selectedBirthDate?.getDateString(format: .digitDate), dobErrorString, .isEmpty),
            (txtPostalCode.textField.text,postalCodeErrorString, .isEmpty),
            (txtAddress.textField.text,addressErrorString, .isEmpty)]
        
        guard Validator.validate(validationParameter2) else {
            return false
        }
        if isFromSetting {
            let validationMobileNumber : [(String?,String, ValidatiionType)] = [(txtMobileNumber.textField.text,numberErrorString, .isPhoneNumber),
                                                                                (txtEmail.textField.text,emailEmptyErrorString, .isEmpty),
                                                                                (txtEmail.textField.text,emailErrorString, .email),
            ]
            guard Validator.validate(validationMobileNumber) else {
                return false
            }
        }
        if !isFromSetting && RegistrationImageParameter.shared.profileImage == nil {
            AlertMessage.showMessageForError("Please select profile image")
            return false
        }
        return true
    }
}

// MARK: - TextField delegate
extension ProfileInfoVC : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if IQKeyboardManager.shared.canGoNext {
            IQKeyboardManager.shared.goNext()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case txtDOB.textField:
            DispatchQueue.main.async {
                self.view.endEditing(true)
                self.openDatePicker()
            }
            return false
        case txtAddress.textField:
                self.presentPlacePickerViewController()
            return false
        default:
            return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var inputValidation: InputValidation?
        switch textField {
        case txtFirstName.textField, txtLastName.textField:
            inputValidation = .name
        case txtMobileNumber.textField :
            inputValidation = .mobile
        case txtEmail.textField:
            inputValidation = .email
        default:
            break
        }
        if let inputValidation = inputValidation {
            return inputValidation.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
        }
        return true
    }
}
//MARK:- Country Picker Methods
extension ProfileInfoVC : CountryPickerViewDelegate,CountryPickerViewDataSource {
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        print(country)
        self.selectedCounty = country
    }
    func sectionTitleForPreferredCountries(in countryPickerView: CountryPickerView) -> String? {
        return "Select country"
    }
}


extension ProfileInfoVC: GMSAutocompleteViewControllerDelegate {

    func presentPlacePickerViewController() {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        acController.presentationController?.delegate = self
        AppDelegate.shared.setSystemNavigationStyle()
        present(acController, animated: true, completion: nil)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        AppDelegate.shared.setupNavigationAppearance()

        selectedAddress = LocationInfoWithCoordinates(address: "\(place.name ?? "") \(place.formattedAddress ?? "")", coordinate: place.coordinate)
        let array = place.addressComponents
        for i in array ?? []{
            let key:String = "\(i.value(forKey: "type") ?? "")"
            let name:String = "\(i.value(forKey: "name") ?? "")"
            if key == "postal_code"{
                self.txtPostalCode.textField.text = name
            }
        }
        dismiss(animated: true, completion: nil)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        AppDelegate.shared.setupNavigationAppearance()
        dismiss(animated: true, completion: nil)
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        AppDelegate.shared.setupNavigationAppearance()
        dismiss(animated: true, completion: nil)
    }

}

struct LocationInfoWithCoordinates {
    let address: String
    let coordinate: CLLocationCoordinate2D
}
extension ProfileInfoVC: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        AppDelegate.shared.setupNavigationAppearance()
    }
}
