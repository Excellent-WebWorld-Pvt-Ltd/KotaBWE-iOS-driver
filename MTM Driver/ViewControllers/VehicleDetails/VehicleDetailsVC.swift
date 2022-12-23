//
//  VehicleDetailsVC.swift
//  DSP Driver
//
//  Created by Harsh Dave on 26/10/21.
//  Copyright © 2021 baps. All rights reserved.
//

import UIKit

class VehicleDetailsVC: BaseViewController {
    
    //MARK:- ======= Outlets ============
    @IBOutlet var viewCollection: [ThemeContainerView]!
    @IBOutlet var lblExpires: [ThemeLabel]!
    @IBOutlet var btnsEdit: [UIButton]!
    @IBOutlet var buttons : [UIButton]!
    @IBOutlet weak var txtNationalIDNumber: ThemeTextFieldLoginRegister!
    @IBOutlet weak var txtDriverPSV: UITextField!
    @IBOutlet weak var txtClearanceCertificate: UITextField!
    @IBOutlet weak var txtNTSDocument: UITextField!
    @IBOutlet weak var btnVehicleImage: ThemeButton!
    @IBOutlet weak var btnInsurance: UnderlineTextButton!
    @IBOutlet weak var btnDriverLicence: UnderlineTextButton!
    @IBOutlet weak var btnVehicleBookDocument: UnderlineTextButton!
    @IBOutlet weak var btnDriverPSV: UnderlineTextButton!
    @IBOutlet weak var btnPoliceInsuarnceDocument: UnderlineTextButton!
    @IBOutlet weak var btnNationalIDDocument: UnderlineTextButton!
    @IBOutlet weak var btnNTSADocumnt: UnderlineTextButton!
    @IBOutlet weak var txtVehicleName: ThemeUnderLineTextField!
    @IBOutlet weak var txtVehicleNumber: ThemeUnderLineTextField!
    @IBOutlet weak var txtvehicelType: ThemeTextField!
    @IBOutlet weak var txtDriverLicenceDate: UITextField!
    @IBOutlet weak var txtVehicleInsuranceDate: UITextField!
    @IBOutlet weak var txtVehicleRegistrationDate: UITextField!
    @IBOutlet weak var btnVehicleRegistration: UIButton!
    @IBOutlet weak var btnSubmit: ThemeButton!
    
    //MARK:- ======= Variables ======
    let parameterArray = RegistrationParameter.shared
    var isFromSetting = false
    
    //MARK:- ======= View Controller Life Cycle ===
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for lbl in lblExpires {
            lbl.isHidden = true
        }
        for btn in btnsEdit {
            btn.isHidden = true
        }
        for btn in buttons {
            btn.titleLabel?.textColor = .black
            btn.titleLabel?.font = UIFont.regular(ofSize: 15.0)
            btn.underline()
        }
        setupTextField()
        fillAllFields()
        self.navigationController?.navigationBar.isHidden = false
        self.setupNavigation(.normal(title: "Vehicle Details", leftItem: .back))
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnActionEdit(_ sender: UIButton) {
        ImagePickerViewController.open(from: self, allowEditing: false) { [unowned self] image in
            sender.imageView?.contentMode = .scaleAspectFit
            self.uploadImages(image: image, selected: sender.tag)
        }
    }
    
    
    @IBAction func BtnActionVehicleBookDocument(_ sender: UIButton) {
        ImagePickerViewController.open(from: self, allowEditing: false) { [unowned self] image in
            sender.imageView?.contentMode = .scaleAspectFit
            self.uploadImages(image: image, selected: sender.tag)
        }
    }
    
    @IBAction func btnActionNAtionalID(_ sender: UIButton) {
        ImagePickerViewController.open(from: self, allowEditing: false) { [unowned self] image in
            sender.imageView?.contentMode = .scaleAspectFit
            self.uploadImages(image: image, selected: sender.tag)
        }
    }
    
    @IBAction func btnActionPoliceInsurance(_ sender: UIButton) {
        ImagePickerViewController.open(from: self, allowEditing: false) { [unowned self] image in
            sender.imageView?.contentMode = .scaleAspectFit
            self.uploadImages(image: image, selected: sender.tag)
        }
    }
    
    @IBAction func btnActionNTSADocumnet(_ sender: UIButton) {
        ImagePickerViewController.open(from: self, allowEditing: false) { [unowned self] image in
            sender.imageView?.contentMode = .scaleAspectFit
            self.uploadImages(image: image, selected: sender.tag)
        }
    }
    
    
    @IBAction func btnActionNext(_ sender: UIButton) {
        guard validateInputs() else {
            return
        }
        if !self.isFromSetting {
            self.webserviceRegistration()
        }else {
            self.webserviceForUpdateVehicleDocuments()
        }
    }
    
    @IBAction func btnActionDriverBadgeDocument(_ sender: UIButton) {
        
        ImagePickerViewController.open(from: self, allowEditing: false) { [unowned self] image in
            sender.imageView?.contentMode = .scaleAspectFit
            self.uploadImages(image: image, selected: sender.tag)
        }
        
    }
    
    
    @IBAction func btnActionnDriverLicence(_ sender: UIButton) {
        ImagePickerViewController.open(from: self, allowEditing: false) { [unowned self] image in
            sender.imageView?.contentMode = .scaleAspectFit
            self.uploadImages(image: image, selected: sender.tag)
        }
    }
    
    
    @IBAction func btnActionvehicleRegisterDocument(_ sender: UIButton){
        ImagePickerViewController.open(from: self, allowEditing: false) { [unowned self] image in
            sender.imageView?.contentMode = .scaleAspectFit
            self.uploadImages(image: image, selected: sender.tag)
        }
    }
    
    
    @IBAction func btnActionVehicleInsuranceDocument(_ sender: UIButton){
        ImagePickerViewController.open(from: self, allowEditing: false) { [unowned self] image in
            sender.imageView?.contentMode = .scaleAspectFit
            self.uploadImages(image: image, selected: sender.tag)
        }
    }
    
    
    @IBAction func btnActionVehiclInfo(_ sender: UIButton){
        ImagePickerViewController.open(from: self, allowEditing: false) { [unowned self] image in
            sender.imageView?.contentMode = .scaleAspectFit
            self.uploadImages(image: image, selected: sender.tag)
        }
    }
    
    
    
    func assignDelegate(){
        txtDriverLicenceDate.delegate = self
        txtVehicleRegistrationDate.delegate = self
        txtVehicleInsuranceDate.delegate = self
        txtNTSDocument.delegate = self
        txtNationalIDNumber.delegate = self
        txtClearanceCertificate.delegate = self
        txtDriverPSV.delegate = self
    }
    
    func validateInputs() -> Bool {
        let validator = BunchEmptyValidator()
        
        validator.append(input: parameterArray.driver_licence_image, message: DrivingLicenseImageMissing)
        validator.append(input: txtDriverLicenceDate.text, message: DrivingLicenseDateMissing)
        
        validator.append(input: parameterArray.vehicle_register_doc, message: VehicleRegisterDocumentImageMissing)
        validator.append(input: txtVehicleRegistrationDate.text, message: VehicleRegisterExpiryMissing)
        
        validator.append(input: parameterArray.vehicle_insurance_certi, message: VehicleInsuranceCertificateImageMissing)
        validator.append(input: txtVehicleInsuranceDate.text, message: VehicleInsuranceCertificateDateMissing)
        
        validator.append(input: parameterArray.ntsa_inspection_image, message: NtsaInspectionImageMissing)
        validator.append(input: txtNTSDocument.text, message: NtsaInspectionDateMissing)
        
        validator.append(input: parameterArray.vehicle_log_book_image, message: VehicleLogBookImageMissing)
        
        validator.append(input: parameterArray.national_id_image, message: NationalIDImageMissing)
        validator.append(input: txtNationalIDNumber.text, message: NationalIDDateMissing)
        
        validator.append(input: parameterArray.police_clearance_certi, message: PoliceClearanceImageMissing)
        validator.append(input: txtClearanceCertificate.text, message: PoliceClearanceDateMissing)
        
        validator.append(input: parameterArray.psv_badge_image, message: DriverPSVBadgeImageMissing)
        validator.append(input: txtDriverPSV.text, message: DriverPSVBadgeDateMissing)
        
        let result = validator.validate()
        if result.isValid == false, let message = result.error {
            AlertMessage.showMessageForError(message)
        }
        if  !isFromSetting {
            parameterArray.ntsa_exp_date = txtNTSDocument.unwrappedText
            parameterArray.vehicle_insurance_exp_date = txtVehicleInsuranceDate.unwrappedText
            parameterArray.driver_licence_exp_date = txtDriverLicenceDate.unwrappedText
            parameterArray.vehicle_reg_expired_date = txtVehicleRegistrationDate.unwrappedText
            parameterArray.police_clearance_exp_date = txtClearanceCertificate.unwrappedText
            parameterArray.psv_badge_exp_date = txtDriverPSV.unwrappedText
            parameterArray.national_id_number = txtNationalIDNumber.unwrappedText
            // txtPsvBadge.text!
            parameterArray.presentIndex = 0
           
            do{
                try UserDefaults.standard.set(object: parameterArray, forKey: keyRegistrationParameter)
            }
            catch{
                print(error)
                return false
            }
        }
        return result.isValid
        
        
    }
    
    //MARK:- ===== Navigation  =======
    func navigateToVC(){
        if parameterArray.presentIndex == 6 {
            self.push(AppViewControllers.shared.vehicleInfo)
        }
    }
    
    
    func setupTextField() {
        assignDelegate()
        //    txtVehicleNumber.isEnabled = false
        //    txtNationalIDNumber.isEnabled = false
    }
    
    func fillAllFields() {
        
        do {
            //            let parameter = try UserDefaults.standard.get(objectType: RegistrationParameter.self, forKey: keyRegistrationParameter)
            let loginData = SessionManager.shared.userProfile
            let parameter = loginData?.responseObject.driverDocs
            
            let parameterRegisterArray = try UserDefaults.standard.get(objectType: RegistrationParameter.self, forKey: keyRegistrationParameter)
            
            
            if let registerInfo = parameterRegisterArray  {
                btnSubmit.setTitle("Submit", for: .normal)
                print("----------------------------------------------------------")
                print("----------------------------------------------------------")
                print("SCREEN Licence Info ")
                print("----------------------------------------------------------")
                print("----------------------------------------------------------")
                print(parameterRegisterArray as Any)
                print("----------------------------------------------------------")
                print("----------------------------------------------------------")
                
                txtNTSDocument.text = registerInfo.ntsa_exp_date
                txtDriverPSV.text = registerInfo.psv_badge_exp_date
                txtDriverLicenceDate.text = registerInfo.driver_licence_exp_date
                txtVehicleInsuranceDate.text = registerInfo.vehicle_insurance_exp_date
                txtClearanceCertificate.text = registerInfo.police_clearance_exp_date
                txtNationalIDNumber.text = registerInfo.national_id_number
                txtVehicleRegistrationDate.text =  registerInfo.vehicle_reg_expired_date
                
                //
                setButtons()
                Loader.hideHUD()
                
                
                
            } else if let parameter = parameter {
                btnSubmit.setTitle("Save", for: .normal)
                txtNTSDocument.text = parameter.ntsaExpDate
                txtDriverPSV.text = parameter.psvBadgeExpDate
                txtDriverLicenceDate.text =  parameter.driverLicenceExpDate
                txtVehicleInsuranceDate.text = parameter.vehicleInsuranceExpDate
                txtClearanceCertificate.text = parameter.policeClearanceExpDate
                txtNationalIDNumber.text = parameter.nationalIdNumber
                txtVehicleRegistrationDate.text = parameter.vehicleRegExpiredDate
                
                for btn in buttons {
                    //btn.sd_setIndicatorStyle(.gray)
                    // btn.sd_addActivityIndicator()
                    switch btn.tag{
                    case 0:
                        break
                    case 1:
                        self.parameterArray.driver_licence_image = parameter.ntsaInspectionImage ?? ""
                      //  btnDriverLicence.setTitle("Driver Licence document uploaded", for: .normal)
                        
                    case 2:
                        
                        self.parameterArray.vehicle_register_doc = parameter.vehicleRegisterDoc ?? ""
                     //   btnVehicleRegistration.setTitle("Vehicle Register document uploaded", for: .normal)
                        
                    case 3:
                        self.parameterArray.vehicle_insurance_certi = parameter.vehicleInsuranceCerti ?? ""
                       // btnInsurance.setTitle("Vehicle Insurance document uploaded", for: .normal)
                        
                    case 4:
                        self.parameterArray.ntsa_inspection_image = parameter.vehicleInsuranceCerti ?? ""
                        //btnNTSADocumnt.setTitle("NTSA document uploaded", for: .normal)
                    case 5:
                        
                        self.parameterArray.vehicle_log_book_image = parameter.vehicleLogBookImage ?? ""
                       // btnVehicleBookDocument.setTitle("Vehicle LogBook document uploaded", for: .normal)
                        
                    case 6:
                        
                        self.parameterArray.national_id_image = parameter.nationalIdImage ?? ""
                       // btnNationalIDDocument.setTitle("National ID document uploaded", for: .normal)
                        
                    case 7:
                        self.parameterArray.police_clearance_certi = parameter.policeClearanceCerti ?? ""
                     //   btnPoliceInsuarnceDocument.setTitle("Police Clearance document uploaded", for: .normal)
                        
                    case 8 :
                        self.parameterArray.psv_badge_image = parameter.psvBadgeImage ?? ""
                     //   btnDriverPSV.setTitle("PSV document uploaded", for: .normal)
                        
                    default:
                        break
                    }
                    
                   
                }
                setButtons()
                Loader.hideHUD()
                
            }
        }
        catch{
            print(error.localizedDescription)
            return
        }
        
    }
    
    
    func setButtons() {
        for btn in buttons {
            //btn.sd_setIndicatorStyle(.gray)
            // btn.sd_addActivityIndicator()
            switch btn.tag{
            case 0:
                break
            case 1:
                if parameterArray.driver_licence_image != "" {
                    btnDriverLicence.setTitle("Driver Licence document uploaded", for: .normal)
                    let btn = btnsEdit.filter({$0.tag == btn.tag})
                    btn[0].isHidden = false
                }
                
            case 2:
                
                if parameterArray.vehicle_register_doc != "" {
                    btnVehicleRegistration.setTitle("Vehicle Regiater document uploaded", for: .normal)
                    let btn = btnsEdit.filter({$0.tag == btn.tag})
                    btn[0].isHidden = false
                }
                
                
            case 3:
                if parameterArray.vehicle_insurance_certi != "" {
                    btnInsurance.setTitle("Vehicle Insurance document uploaded", for: .normal)
                    let btn = btnsEdit.filter({$0.tag == btn.tag})
                    btn[0].isHidden = false
                }
                //self.parameterArray.vehicle_insurance_certi = urlString
                
            case 4:
                if parameterArray.ntsa_inspection_image != "" {
                    btnNTSADocumnt.setTitle("NTSA document uploaded", for: .normal)
                    let btn = btnsEdit.filter({$0.tag == btn.tag})
                    btn[0].isHidden = false
                }
                //self.parameterArray.ntsa_inspection_image = urlString
            case 5:
                
                if parameterArray.vehicle_log_book_image != "" {
                    btnVehicleBookDocument.setTitle("Vehicle LogBook document uploaded", for: .normal)
                    let btn = btnsEdit.filter({$0.tag == btn.tag})
                    btn[0].isHidden = false
                    
                }
                //self.parameterArray.vehicle_log_book_image = urlString
                
            case 6:
                if parameterArray.national_id_image != "" {
                    btnNationalIDDocument.setTitle("National ID document uploaded", for: .normal)
                    let btn = btnsEdit.filter({$0.tag == btn.tag})
                    btn[0].isHidden = false
                    
                }
                
                //self.parameterArray.national_id_image = urlString
                
            case 7:
                if parameterArray.police_clearance_certi != "" {
                    btnPoliceInsuarnceDocument.setTitle("Police Clearance document uploaded", for: .normal)
                    let btn = btnsEdit.filter({$0.tag == btn.tag})
                    btn[0].isHidden = false
                    
                }
                //self.parameterArray.police_clearance_certi = urlString
                
            case 8 :
                if parameterArray.psv_badge_image != "" {
                    btnDriverPSV.setTitle("PSV document uploaded", for: .normal)
                    let btn = btnsEdit.filter({$0.tag == btn.tag})
                    btn[0].isHidden = false
                    
                }
                //self.parameterArray.psv_badge_image = urlString
                
            default:
                break
            }
        }
    }
    
    @IBAction func openPicImage(_ sender : UIButton){
        if !(sender.currentTitle?.contains("uploaded"))!{
            
            
            ImagePickerViewController.open(from: self, allowEditing: false) { [unowned self] image in
                sender.imageView?.contentMode = .scaleAspectFit
                self.uploadImages(image: image, selected: sender.tag)
            }
        }
        else {
            var urlString = ""
            let vc : GalaryVC = UIViewController.viewControllerInstance(storyBoard: .myTrips)
            vc.firstTimeSelectedIndex = 0
            
            switch sender.tag{
            case 0:
                break
            case 1:
                urlString = self.parameterArray.driver_licence_image
                
            case 2:
                
                urlString = self.parameterArray.vehicle_register_doc
                
            case 3:
                urlString = self.parameterArray.vehicle_insurance_certi
                
            case 4:
                urlString = self.parameterArray.ntsa_inspection_image
                
            case 5:
                
                urlString = self.parameterArray.vehicle_log_book_image
                
            case 6:
                
                urlString = self.parameterArray.national_id_image
                
            case 7:
                urlString = self.parameterArray.police_clearance_certi
                
            case 8 :
                
                urlString = self.parameterArray.psv_badge_image
                
            default:
                break
            }
            vc.arrImage =  [urlString]
            self.navigationController?.present(vc, animated: true)
        }
    }
 
    func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    
    func addDismissButton(_ sender: UIButton){
        let height: CGFloat = 14
        let button = UIButton(frame: CGRect(x: sender.bounds.width - height + 1, y: -(height / 3), width: height, height: height))
        button.layer.cornerRadius = (height / 2)
        button.clipsToBounds = true
        button.setImage(#imageLiteral(resourceName: "LogoWhite"), for: .normal)
        
        button.backgroundColor = .black
        button.tag = sender.tag
        button.addTarget(self, action: #selector(removeImage(_:)), for: .touchUpInside)
        sender.addSubview(button)
    }
    @objc func removeImage(_ sender: UIButton){
        self.setButtonData(tag: sender.tag, urlString: "")
        sender.removeFromSuperview()
    }
    
}
extension VehicleDetailsVC{
    func uploadImages(image: UIImage, selected index: Int){
        Loader.showHUD(with: self.view)
        WebService.shared.postDataWithImage(api: .docUpload, parameter: [:],  image: image, imageParamName: "image"){ json,status in
            Loader.hideHUD()
            if status{
                let urlString = json["url"].stringValue
                self.setButtonData(tag: index, urlString: urlString)
                
            }
        }
    }
    
    func setButtonData(tag: Int, urlString: String){
        switch tag{
        case 0:
            break
        case 1:
            self.parameterArray.driver_licence_image = urlString
            btnDriverLicence.setTitle("Driver Licence document uploaded", for: .normal)
            
        case 2:
            
            self.parameterArray.vehicle_register_doc = urlString
            btnVehicleRegistration.setTitle("Vehicle Regiater document uploaded", for: .normal)
            
            
            
        case 3:
            self.parameterArray.vehicle_insurance_certi = urlString
            btnInsurance.setTitle("Vehicle Insurance document uploaded", for: .normal)
            
        case 4:
            self.parameterArray.ntsa_inspection_image = urlString
            btnNTSADocumnt.setTitle("NTSA document uploaded", for: .normal)
            
        case 5:
            
            self.parameterArray.vehicle_log_book_image = urlString
            btnVehicleBookDocument.setTitle("Vehicle LogBook uploaded", for: .normal)
            
        case 6:
            
            self.parameterArray.national_id_image = urlString
            btnNationalIDDocument.setTitle("National ID document uploaded", for: .normal)
            
        case 7:
            self.parameterArray.police_clearance_certi = urlString
            btnPoliceInsuarnceDocument.setTitle("Police Clearance uploaded", for: .normal)
            
        case 8 :
            self.parameterArray.psv_badge_image = urlString
            btnDriverPSV.setTitle("PSV document uploaded", for: .normal)
            
        default:
            break
        }
        Loader.hideHUD()
        
        let btn = btnsEdit.filter({$0.tag == tag})
        btn[0].isHidden = false
        
    }
}

extension VehicleDetailsVC : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.textColor = UIColor.init(custom: .theme)
        if textField.tag != 6 {
            openDatePicker(textField)
            return false
        }
        
        return true
    }
    
    func openDatePicker(_ textField: UITextField){
        let date = textField.text?.getDate(format: .digitDate)
        ThemeDatePickerViewController.open(from: self, title: textField.placeholder ?? "", type: .expiryDate, selectedDate: date) { [unowned self] date in
            textField.text = date.getDateString(format: .digitDate)
            let viewTag = self.viewCollection.filter({$0.tag == textField.tag})
            let lblTag = self.lblExpires.filter({$0.tag == textField.tag})
            
            if Date.getCurrentDate() == textField.text {
                viewTag[0].layer.borderWidth = 1
                viewTag[0].borderColor = UIColor.red
                lblTag[0].isHidden = false
            }
            else {
                viewTag[0].layer.borderWidth = 0
                viewTag[0].borderColor = UIColor.clear
                lblTag[0].isHidden = true
            }
        }
    }
    
}

extension VehicleDetailsVC {
    func webserviceRegistration(){
        
        RegistrationParameter.shared.driver_role = "Driver"
        let parameter = try! RegistrationParameter.shared.asDictionary()
        
        let image = RegistrationImageParameter.shared.profileImage ?? UIImage()
        Loader.showHUD(with: view)
        WebService.shared.postDataWithImage(api: .register, parameter: parameter as [String : AnyObject], image: image, imageParamName: "profile_image"){ json,status in
            Loader.hideHUD()
            if status{
                AlertMessage.showMessageForSuccess(json["message"].arrayValue.first?.stringValue ?? json["message"].stringValue)
                SessionManager.shared.saveSession(json: json)
                
            }else{
                AlertMessage.showMessageForError(json["message"].array?.first?.stringValue ?? json["message"].stringValue)
            }
        }
    }
    
    
    // ----------------------------------------------------
    // MARK: - Webservice
    // ----------------------------------------------------
    
    func webserviceForUpdateVehicleDocuments() {
        let vehicleDocRequet = VehicleDocRequestModel()
        vehicleDocRequet.driver_id = Singleton.shared.driverId
        vehicleDocRequet.ntsa_exp_date = txtNTSDocument.unwrappedText
        vehicleDocRequet.vehicle_insurance_exp_date =  txtVehicleInsuranceDate.unwrappedText // txtInsuranceCertificate.text!
        
        vehicleDocRequet.driver_licence_exp_date =  txtDriverLicenceDate.unwrappedText // txtDrivingLicense.text!
        vehicleDocRequet.vehicle_reg_expired_date =  txtVehicleRegistrationDate.unwrappedText
        vehicleDocRequet.police_clearance_exp_date =  txtClearanceCertificate.unwrappedText // txtClearanceReceipt.text!
        vehicleDocRequet.psv_badge_exp_date =  txtDriverPSV.unwrappedText
        vehicleDocRequet.national_id_number = txtNationalIDNumber.text ?? ""
        
        vehicleDocRequet.driver_licence_image = parameterArray.driver_licence_image
        vehicleDocRequet.vehicle_register_doc = parameterArray.vehicle_register_doc
        vehicleDocRequet.vehicle_insurance_certi = parameterArray.vehicle_insurance_certi
        vehicleDocRequet.ntsa_inspection_image = parameterArray.ntsa_inspection_image
        vehicleDocRequet.vehicle_log_book_image = parameterArray.vehicle_log_book_image
        vehicleDocRequet.national_id_image = parameterArray.national_id_image
        vehicleDocRequet.police_clearance_certi = parameterArray.police_clearance_certi
        vehicleDocRequet.psv_badge_image = parameterArray.psv_badge_image
        Loader.showHUD(with: view)
        WebServiceCalls.updateDoucments(VehicleDocumentsModel: vehicleDocRequet) { response, status in
            Loader.hideHUD()
            if status {
                print(response)
                let loginModelDetails = LoginModel.init(fromJson: response)
                SessionManager.shared.userProfile = loginModelDetails
                AlertMessage.showMessageForSuccess(loginModelDetails.message)
                NotificationCenter.postCustom(.updateOnlineStatus(false))
                self.navigationController?.popViewController(animated: true)
            } else {
                AlertMessage.showMessageForError(response["message"].arrayValue.first?.stringValue ?? response["message"].stringValue)
            }
        }
    }
    
}
