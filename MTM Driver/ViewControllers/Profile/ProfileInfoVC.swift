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

class ProfileInfoVC: BaseViewController {
    
    //MARK:- ===== Outlets ========
    var parameterArray = RegistrationParameter.shared
    
    //MARK:- ===== Outlets =======
    @IBOutlet var btnMale: UIButton!
    @IBOutlet var btnFemale: UIButton!
    @IBOutlet var btnOwner: UIButton!
    @IBOutlet var btnRent: UIButton!
    @IBOutlet weak var viewOwner: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var viewImgProfile: UIView!
    @IBOutlet weak var imgProfileHeight: NSLayoutConstraint!
    @IBOutlet weak var txtdriverRole: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtOwnerName: UITextField!
    @IBOutlet weak var txtOwnerMobile: UITextField!
    
    @IBOutlet weak var viewStackMobileNo: UIStackView!
    @IBOutlet weak var txtownerEmail: ThemeUnderLineTextField!
    
    @IBOutlet weak var txtPaymentMethod: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtDOB: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtInviteCode: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var viewCountryPicker: CountryPickerView!
    @IBOutlet weak var btnNext: UIButton!
    
    var isFromSetting = false
    var selectedCounty : Country?
    var pickedImage: UIImage?
    var selectedBirthDate: Date? {
        didSet {
            txtDOB.text = selectedBirthDate?.getDateString(format: .fullDate)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtMobileNumber.font = UIFont.regular(ofSize: 18.0)
        txtMobileNumber.delegate = self
        setupCountryPicker()
        initialSetup()
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
        txtOwnerName.delegate = self
        txtOwnerMobile.delegate = self
        txtEmail.delegate = self
        txtPaymentMethod.delegate = self
        txtFirstName.delegate = self
        txtLastName.delegate = self
        txtDOB.delegate = self
        txtAddress.delegate = self
        
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
        if let parameterArray = SessionManager.shared.registrationParameter {
            print("----------------------------------------------------------")
            print("----------------------------------------------------------")
            print("SCREEN User Info")
            print("----------------------------------------------------------")
            print("----------------------------------------------------------")
            print(parameterArray as Any)
            print("----------------------------------------------------------")
            print("----------------------------------------------------------")
            txtOwnerName.text = parameterArray.owner_name
            txtOwnerMobile.text = parameterArray.owner_mobile_no != "" ? parameterArray.owner_mobile_no.replacingOccurrences(of: "254", with: "") : ""
            txtownerEmail.text = parameterArray.owner_email
            //            txtdriverRole.text = parameterArray.driver_role.replacingOccurrences(of: "_", with: " ").capitalized ?? ""
            carType = parameterArray.car_type == CarType.own.rawValue ? .own : .rent
            gender = parameterArray.gender == Gender.female.rawValue ? .female : .male
            if let savedImage = SessionManager.shared.savedProfileImage {
                imgProfile.image = savedImage
                RegistrationImageParameter.shared.profileImage = savedImage
            }
            txtPaymentMethod.text = parameterArray.payment_method.capitalized
            txtFirstName.text = parameterArray.first_name
            txtLastName.text = parameterArray.last_name
            self.selectedBirthDate = parameterArray.dob.getDate(format: .digitDate)
            txtAddress.text = parameterArray.address
            txtInviteCode.text = parameterArray.invite_code
            txtEmail.text = parameterArray.email
            txtMobileNumber.text = parameterArray.mobile_no
            
        } else if let profile = SessionManager.shared.userProfile {
            
            txtOwnerName.text = profile.responseObject.ownerName ?? ""
            txtOwnerMobile.text = profile.responseObject.ownerMobileNo != "" ? profile.responseObject.ownerMobileNo.replacingOccurrences(of: "254", with: "") : ""
            txtownerEmail.text = profile.responseObject.ownerEmail ?? ""
            //            txtdriverRole.text = profile.driver_role.replacingOccurrences(of: "_", with: " ").capitalized ?? ""
            guard let url = profile.responseObject.profileImage else { return }
            let imgurl = NetworkEnvironment.baseImageURL + url
            UtilityClass.imageGet(url:imgurl, img: imgProfile, UIColor.black, UIImage(named: "Profile") ?? UIImage())
            //txtdriverRole.text = "Driver"
            txtEmail.isUserInteractionEnabled = false
            txtEmail.text = profile.responseObject.email
            txtMobileNumber.text = profile.responseObject.mobileNo
            // txtMobileNumber.isUserInteractionEnabled = false
            carType = profile.responseObject.carType == CarType.own.rawValue ? .own : .rent
            gender = profile.responseObject.gender == Gender.male.rawValue ? .male : .female
            
            txtPaymentMethod.text = profile.responseObject.paymentMethod.capitalized
            txtFirstName.text = profile.responseObject.firstName ?? ""
            txtLastName.text = profile.responseObject.lastName ?? ""
            selectedBirthDate = profile.responseObject.dob.getDate(format: .digitDate)
            txtAddress.text = profile.responseObject.address ?? ""
            txtInviteCode.text = profile.responseObject.inviteCode ?? ""
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
        txtDOB.rightView = imageView
        txtDOB.rightViewMode = .always
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
        guard validation() else {
            return
        }
        if self.isFromSetting {
            let objData = UpdatePersonalInfo()
            objData.address = self.txtAddress.text ?? ""
            objData.gender = self.gender.rawValue
            objData.car_type = self.carType.rawValue
            objData.driver_id = Singleton.shared.driverId
            objData.dob = self.selectedBirthDate?.getDateString(format: .digitDate) ?? ""
            objData.email = self.txtEmail.text ?? ""
            objData.first_name = self.txtFirstName.text ?? ""
            objData.last_name = self.txtLastName.text ?? ""
            objData.mobile_no = self.txtMobileNumber.text ?? ""
            objData.owner_name = self.txtOwnerName.text ?? ""
            objData.owner_email = self.txtownerEmail.text ?? ""
            objData.owner_mobile_no = self.txtOwnerMobile.text ?? ""
            objData.payment_method = "cash"
            self.webserviceForSavePersonalProfile(uerData: objData)
        }
        else {
            if btnRent.isSelected{
                parameterArray.owner_name = txtOwnerName.text!
                parameterArray.owner_mobile_no =  txtOwnerMobile.text!
                parameterArray.owner_email = txtEmail.text!
            }
            parameterArray.payment_method = txtPaymentMethod.text!.lowercased()
            parameterArray.first_name = txtFirstName.text!
            parameterArray.last_name =  txtLastName.text!
            parameterArray.dob = selectedBirthDate?.getDateString(format: .digitDate) ?? ""
            parameterArray.address = txtAddress.text!
            parameterArray.invite_code = txtInviteCode.text!
            
            let loginData = SessionManager.shared.userProfile
            let parameter = loginData?.responseObject.driverDocs
            parameterArray.driver_id = parameter?.driver_id ?? ""
            parameterArray.setNextRegistrationIndex(from: .profile)
            SessionManager.shared.registrationParameter = parameterArray
            
            let bankInfoVC = AppViewControllers.shared.bankInfo
            self.push(bankInfoVC)
        }
    }
    
    private func validation() -> Bool {
        
        let validationParameter2: [(String?,String, ValidatiionType)] = [
            (txtFirstName.text,firstNameErrorString, .isEmpty),
            (txtLastName.text,lastNameErrorString, .isEmpty),
            
            (selectedBirthDate?.getDateString(format: .digitDate), dobErrorString, .isEmpty),
            (txtAddress.text,addressErrorString, .isEmpty)]
        
        guard Validator.validate(validationParameter2) else {
            return false
        }
        if isFromSetting {
            let validationMobileNumber : [(String?,String, ValidatiionType)] = [(txtMobileNumber.text,numberErrorString, .isPhoneNumber),
                                                                                (txtEmail.text,emailEmptyErrorString, .isEmpty),
                                                                                (txtEmail.text,emailErrorString, .email),
            ]
            guard Validator.validate(validationMobileNumber) else {
                return false
            }
        }
        
        if btnRent.isSelected{
            let validationOwner : [(String?,String, ValidatiionType)] = [(txtOwnerName.text,nameErrorString, .isEmpty),
                                                                         (txtOwnerMobile.text,ownernumberErrorString, .isEmpty),
                                                                         (txtOwnerMobile.text,phoneNumberErrorString, .isPhoneNumber),
                                                                         (txtownerEmail.text,owneremailEmptyErrorString, .isEmpty),
                                                                         (txtownerEmail.text,emailErrorString, .email)]
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
        case txtDOB:
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
        case txtPaymentMethod:
            self.view.endEditing(true)
            let arrRole = ["Cash", "Wallet", "Card","Mpesa"]
            let actionSheet = ActionSheetStringPicker(title: "Select Payment Method",
                                                      rows: arrRole,
                                                      initialSelection: 0,
                                                      doneBlock: { (picker, row, data) in
                print((picker, row, data))
                self.txtPaymentMethod.text = arrRole[row]
            },
                                                      cancel: nil,
                                                      origin: self)
            actionSheet?.show()
            return false
        default:
            return true
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var inputValidation: InputValidation?
        switch textField {
        case txtFirstName, txtLastName:
            inputValidation = .name
        case txtMobileNumber, txtOwnerMobile:
            inputValidation = .mobile
        case txtEmail:
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

