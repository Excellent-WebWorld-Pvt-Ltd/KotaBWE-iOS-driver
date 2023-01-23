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
    
    
    @IBOutlet weak var genderStackView: UIStackView!
    
    
    @IBOutlet weak var firstlastNameStackView: UIStackView!
    
    
    @IBOutlet weak var CarDriverStackView: UIStackView!
    
    
    @IBOutlet var btnMale: UIButton!
    @IBOutlet var btnFemale: UIButton!
    @IBOutlet var btnOwner: UIButton!
    @IBOutlet var btnRent: UIButton!
    @IBOutlet weak var viewOwner: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var viewImgProfile: UIView!
    @IBOutlet weak var imgProfileHeight: NSLayoutConstraint!
    @IBOutlet weak var txtdriverRole: UITextField!
//    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtEmail: CustomViewOutlinedTxtField!
    
  //  @IBOutlet weak var txtOwnerName: UITextField!
    
    @IBOutlet weak var ownerStackView: UIStackView!
    
    @IBOutlet weak var txtOwnerName: CustomViewOutlinedTxtField!
    
    @IBOutlet weak var txtOwnerMobile: CustomViewOutlinedTxtField!
    
    
    @IBOutlet weak var txtownerEmail: CustomViewOutlinedTxtField!
    
    
    @IBOutlet weak var viewStackMobileNo: UIStackView!
 
    @IBOutlet weak var txtPaymentMethod: CustomViewOutlinedTxtField!
    
   
//    @IBOutlet weak var txtFirstName: UITextField!
//    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtFirstName: CustomViewOutlinedTxtField!
    
    @IBOutlet weak var txtLastName: CustomViewOutlinedTxtField!
    
    @IBOutlet weak var txtMobileNumber: CustomViewOutlinedTxtField!
    
    @IBOutlet weak var txtDOB: CustomViewOutlinedTxtField!
    
    @IBOutlet weak var txtAddress: CustomViewOutlinedTxtField!
    
    @IBOutlet weak var txtPostalCode: CustomViewOutlinedTxtField!
    
    @IBOutlet weak var txtInviteCode: CustomViewOutlinedTxtField!
    
  
    
    @IBOutlet weak var viewCountryPicker: CountryPickerView!
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
        
        setupCountryPicker()
        setupTextfields()
        initialSetup()
        
        mainStackView.setCustomSpacing(14, after: CarDriverStackView)
        mainStackView.setCustomSpacing(16, after: viewStackMobileNo)
      
        if !self.isFromSetting {
            mainStackView.setCustomSpacing(18, after: firstlastNameStackView)
            mainStackView.setCustomSpacing(10, after: genderStackView)
        }
        mainStackView.setCustomSpacing(20, after: txtAddress)
        mainStackView.setCustomSpacing(10, after: genderStackView
                                       
        )
        
//        imageSetup()
        if !isFromSetting {
            navigateToVC()
        }
        self.btnNext.setTitle(isFromSetting ? "Save" : "Next", for: .normal)
        self.navigationController?.navigationBar.isHidden = false
        self.setupNavigation(.normal(title: "Profile Details", leftItem: .back))    }
    
    
    var gender = Gender.male{
        didSet{
            parameterArray.gender = gender.rawValue
            btnMale.isSelected = gender == .male
            btnFemale.isSelected = !btnMale.isSelected
        }
    }
    var carType = CarType.own{
        didSet{
            parameterArray.car_type = carType.rawValue
            btnOwner.isSelected = carType == .own
            btnRent.isSelected = !btnOwner.isSelected
            
            hideOwnerDetails(btnOwner.isSelected)
        }
    }
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
        
        txtOwnerMobile.textField.keyboardType = .phonePad
        txtOwnerMobile.textField.delegate = self
        
        txtEmail.textField.keyboardType = .emailAddress
        txtEmail.textField.autocapitalizationType = .none
        
        txtownerEmail.textField.keyboardType = .emailAddress
        txtownerEmail.textField.autocapitalizationType = .none
      
    }
    
    @IBAction func rentCar(_ sender: UIButton){
        view.endEditing(true)
        carType = .rent
    }
    
    
    @IBAction func ownerCar(_ sender: UIButton){
        view.endEditing(true)
        carType = .own
    }
    
    @IBAction func genderMale(_ sender: UIButton){
        gender = .male
    }
    
    @IBAction func genderFemale(_ sender: UIButton){
        gender = .female
        
    }
    
    func initialSetup() {
        // txtdriverRole.delegate = self
        txtOwnerName.textField.delegate = self
        txtOwnerMobile.textField.delegate = self
        txtEmail.textField.delegate = self
        txtPaymentMethod.textField.delegate = self
        txtFirstName.textField.delegate = self
        txtPostalCode.textField.delegate = self
        txtLastName.textField.delegate = self
        txtDOB.textField.delegate = self
        txtAddress.textField.delegate = self
    
        if !isFromSetting {
            txtEmail.isHidden = true
            viewStackMobileNo.isHidden = true
        }
        else {
            txtEmail.isHidden = false
            viewStackMobileNo.isHidden = false
        }
        
        setProfile()
        //setDobField()
        gender = .male
        carType = .own
        if isFromSetting{
            if let profile = SessionManager.shared.userProfile {
               txtOwnerName.textField.text = profile.responseObject.ownerName ?? ""
               txtOwnerMobile.textField.text = profile.responseObject.ownerMobileNo != "" ? profile.responseObject.ownerMobileNo.replacingOccurrences(of: "254", with: "") : ""
               txtownerEmail.textField.text = profile.responseObject.ownerEmail ?? ""
               //            txtdriverRole.text = profile.driver_role.replacingOccurrences(of: "_", with: " ").capitalized ?? ""
               guard let url = profile.responseObject.profileImage else { return }
               let imgurl = NetworkEnvironment.baseImageURL + url
               UtilityClass.imageGet(url:imgurl, img: imgProfile, UIColor.black, UIImage(named: "Profile") ?? UIImage())
               //txtdriverRole.text = "Driver"
               txtEmail.textField.isUserInteractionEnabled = false
               txtEmail.textField.text = profile.responseObject.email
               txtMobileNumber.textField.text = profile.responseObject.mobileNo
               // txtMobileNumber.isUserInteractionEnabled = false
               carType = profile.responseObject.carType == CarType.own.rawValue ? .own : .rent
               gender = profile.responseObject.gender == Gender.male.rawValue ? .male : .female
               
               txtPaymentMethod.textField.text = profile.responseObject.paymentMethod.capitalized
               txtFirstName.textField.text = profile.responseObject.firstName ?? ""
               txtLastName.textField.text = profile.responseObject.lastName ?? ""
               selectedBirthDate = profile.responseObject.dob.getDate(format: .digitDate)
               txtDOB.textField.text = selectedBirthDate?.getDateString(format: .fullDate)
               txtAddress.textField.text = profile.responseObject.address ?? ""
               txtInviteCode.textField.text = profile.responseObject.inviteCode ?? ""
           }
        }else{
            if let parameterArray = SessionManager.shared.registrationParameter {
                print(parameterArray as Any)
                txtOwnerName.textField.text = parameterArray.owner_name
                txtOwnerMobile.textField.text = parameterArray.owner_mobile_no != "" ? parameterArray.owner_mobile_no.replacingOccurrences(of: "254", with: "") : ""
                txtownerEmail.textField.text = parameterArray.owner_email
                //            txtdriverRole.text = parameterArray.driver_role.replacingOccurrences(of: "_", with: " ").capitalized ?? ""
                carType = parameterArray.car_type == CarType.own.rawValue ? .own : .rent
                gender = parameterArray.gender == Gender.female.rawValue ? .female : .male
                if let savedImage = SessionManager.shared.savedProfileImage {
                    imgProfile.image = savedImage
                    RegistrationImageParameter.shared.profileImage = savedImage
                }
                txtPaymentMethod.textField.text = parameterArray.payment_method.capitalized
                txtFirstName.textField.text = parameterArray.first_name
                txtLastName.textField.text = parameterArray.last_name
                self.selectedBirthDate = parameterArray.dob.getDate(format: .digitDate)
                txtDOB.textField.text = selectedBirthDate?.getDateString(format: .fullDate)
                txtAddress.textField.text = parameterArray.address
                txtInviteCode.textField.text = parameterArray.invite_code
                txtEmail.textField.text = parameterArray.email
                txtMobileNumber.textField.text = parameterArray.mobile_no
            }
        }
        
    }
    
    private func hideOwnerDetails(_ hide: Bool){
        self.viewOwner.isHidden = hide
        self.txtOwnerMobile.isHidden = hide
        self.txtOwnerName.isHidden = hide
        
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
        viewImgProfile.layer.shadowRadius = imgProfileHeight.constant / 2
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
            
            print(response)
            
            if status {
                Loader.hideHUD()
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
            self.navigationController?.popViewController(animated: true)
//            let objData = UpdatePersonalInfo()
//            objData.address = self.txtAddress.textField.text ?? ""
//            objData.gender = self.gender.rawValue
//            objData.car_type = self.carType.rawValue
//            objData.driver_id = Singleton.shared.driverId
//            objData.dob = self.selectedBirthDate?.getDateString(format: .digitDate) ?? ""
//            objData.email = self.txtEmail.textField.text ?? ""
//            objData.first_name = self.txtFirstName.textField.text ?? ""
//            objData.last_name = self.txtLastName.textField.text ?? ""
//            objData.mobile_no = self.txtMobileNumber.textField.text ?? ""
//            objData.owner_name = self.txtOwnerName.textField.text ?? ""
//            objData.owner_email = self.txtownerEmail.textField.text ?? ""
//            objData.owner_mobile_no = self.txtOwnerMobile.textField.text ?? ""
//            objData.payment_method = self.txtPaymentMethod.textField.text ?? "cash"//"cash"
//            self.webserviceForSavePersonalProfile(uerData: objData)
        }
        else {
            if btnRent.isSelected{
                parameterArray.owner_name = txtOwnerName.textField.text!
                parameterArray.owner_mobile_no =  txtOwnerMobile.textField.text!
                parameterArray.owner_email = txtEmail.textField.text!
            }
            parameterArray.payment_method = txtPaymentMethod.textField.text!.lowercased()
            parameterArray.first_name = txtFirstName.textField.text!
            parameterArray.last_name =  txtLastName.textField.text!
            parameterArray.postal_code = txtPostalCode.textField.text!
            parameterArray.dob = selectedBirthDate?.getDateString(format: .digitDate) ?? ""
            parameterArray.address = txtAddress.textField.text!
            parameterArray.invite_code = txtInviteCode.textField.text!

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
        
            if txtDOB.textField.text == nil {
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
        
        let ownerNameValidation = InputValidation.name.isValid(input: txtOwnerName.textField.unwrappedText, field: "Owner name")
        let ownermobileValidation = InputValidation.mobile.isValid(input: txtOwnerMobile.textField.unwrappedText, field: "Owner mobile number")
        let ownerEmailValidation = InputValidation.email.isValid(input: txtownerEmail.textField.unwrappedText, field: "Owner email address")
        
        
        if txtPaymentMethod.textField.text == nil || txtPaymentMethod.textField.text == ""  {
            
            txtPaymentMethod.textField.leadingAssistiveLabel.text = paymentMethodErrorString
            txtPaymentMethod.textField.setOutlineColor(UIColor.red, for: .normal)
        }else {
            
            txtPaymentMethod.textField.leadingAssistiveLabel.text = ""
            txtPaymentMethod.textField.setOutlineColor(.themeTextFieldDefaultBorderColor, for: .normal)
            
        }
        
        if isFromSetting {
           
            txtEmail.textField.leadingAssistiveLabel.text = emailValidation.error
            txtEmail.textField.setOutlineColor(emailValidation.isValid ? .themeTextFieldDefaultBorderColor : .red, for: .normal)
            
            let mobileValidation = InputValidation.mobile.isValid(input: txtMobileNumber.textField.unwrappedText, field: "mobile number")
            txtMobileNumber.textField.leadingAssistiveLabel.text = mobileValidation.error
            txtMobileNumber.textField.setOutlineColor(mobileValidation.isValid ? .themeTextFieldDefaultBorderColor : .red, for: .normal)

        }
            
        if btnRent.isSelected{
         
            txtOwnerName.textField.leadingAssistiveLabel.text = ownerNameValidation.error
            txtOwnerName.textField.setOutlineColor(firstNameValidation.isValid ? .themeTextFieldDefaultBorderColor : .red, for: .normal)
           
            txtOwnerMobile.textField.leadingAssistiveLabel.text = ownermobileValidation.error
            txtOwnerMobile.textField.setOutlineColor(ownermobileValidation.isValid ? .themeTextFieldDefaultBorderColor : .red, for: .normal)
            
            txtownerEmail.textField.leadingAssistiveLabel.text = ownerEmailValidation.error
            txtownerEmail.textField.setOutlineColor(ownerEmailValidation.isValid ? .themeTextFieldDefaultBorderColor : .red, for: .normal)
        }
        
        if !isFromSetting && RegistrationImageParameter.shared.profileImage == nil {
            AlertMessage.showMessageForError("Please select profile image")
        }
        
        if btnRent.isSelected {
            if !isFromSetting && firstNameValidation.isValid && postalValidation.isValid && lastNameValidation.isValid  && ownerNameValidation.isValid && ownerEmailValidation.isValid && ownermobileValidation.isValid && RegistrationImageParameter.shared.profileImage != nil && txtPaymentMethod.textField.text != "" && txtDOB.textField.text != nil && addressValidation.isValid {
                return true
            } else if isFromSetting && firstNameValidation.isValid && postalValidation.isValid && lastNameValidation.isValid  && ownerNameValidation.isValid && ownerEmailValidation.isValid && ownermobileValidation.isValid &&  txtPaymentMethod.textField.text != "" && txtDOB.textField.text != nil  && addressValidation.isValid {
                return true
            }else {
                return false
            }
        }else {
            if !isFromSetting && firstNameValidation.isValid && postalValidation.isValid && lastNameValidation.isValid  && RegistrationImageParameter.shared.profileImage != nil &&  txtPaymentMethod.textField.text != "" && txtDOB.textField.text != nil && addressValidation.isValid {
                return true
            }else if isFromSetting && firstNameValidation.isValid && postalValidation.isValid && lastNameValidation.isValid  && SessionManager.shared.userProfile != nil && txtPaymentMethod.textField.text != "" && txtDOB.textField.text != nil && addressValidation.isValid {
                return true
            }else {
                return false
            }
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
        
        if btnRent.isSelected{
            let validationOwner : [(String?,String, ValidatiionType)] = [(txtOwnerName.textField.text,nameErrorString, .isEmpty),
                                                                         (txtOwnerMobile.textField.text,ownernumberErrorString, .isEmpty),
                                                                         (txtOwnerMobile.textField.text,phoneNumberErrorString, .isPhoneNumber),
                                                                         (txtownerEmail.textField.text,owneremailEmptyErrorString, .isEmpty),
                                                                         (txtownerEmail.textField.text,emailErrorString, .email)]
            guard Validator.validate(validationOwner) else {
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
            
        case txtdriverRole:
            self.view.endEditing(true)
            let arrRole = ["Captain", "Super Driver", "Driver"]
            let actionSheet = ActionSheetStringPicker(title: "Select Driver Role",
                                                      rows: arrRole,
                                                      initialSelection: 0,
                                                      doneBlock: { (picker, row, data) in
                print((picker, row, data))
                self.txtdriverRole.text = arrRole[row]
            },
                                                      cancel: nil,
                                                      origin: self)
           
            actionSheet?.show()
            return false
        case txtAddress.textField:
            
                self.presentPlacePickerViewController()
            
            return false
        case txtPaymentMethod.textField:
            
                self.view.endEditing(true)
                let arrRole = ["Cash", "Wallet", "Card","Mpesa"]
                DispatchQueue.main.async {
                let actionSheet = ActionSheetStringPicker(title: "Select Payment Method",
                                                          rows: arrRole,
                                                          initialSelection: 0,
                                                          doneBlock: { (picker, row, data) in
                    print((picker, row, data))
                    self.txtPaymentMethod.textField.text = arrRole[row]
                },
                                                          cancel: nil,
                                                          origin: self.txtPaymentMethod.textField)
                actionSheet?.toolbarBackgroundColor =  UIColor.systemGray
                actionSheet?.show()
            }
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
        case txtMobileNumber.textField, txtOwnerMobile.textField:
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
