//
//  LicenseInfoView.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 19/04/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
class LicenseInfoView: UIView{

    var parameterArray = RegistrationParameter.shared
    
    @IBOutlet weak var txtNTSA: UITextField!
    @IBOutlet weak var txtInsuranceCertificate: UITextField!
    @IBOutlet weak var txtLogBook: UITextField!
    @IBOutlet weak var txtDrivingLicense: UITextField!
    @IBOutlet weak var txtNationalId: UITextField!
    @IBOutlet weak var txtClearanceReceipt: UITextField!
    @IBOutlet weak var txtPsvBadge: UITextField!
    @IBOutlet var buttons : [UIButton]!

    private func assignDelegate(){
        txtNTSA.delegate = self
        txtInsuranceCertificate.delegate = self
        txtLogBook.delegate = self
        txtDrivingLicense.delegate = self
        txtNationalId.delegate = self
        txtClearanceReceipt.delegate = self
        txtPsvBadge.delegate = self
    }
    
    
    override func validationWithCompletion(_ completion: @escaping ((Bool) -> ())){
         let validationParameter: [(String?,String, ValidatiionType)] = [(txtNTSA.text,NtsaInspectionDateMissing, .isEmpty),
                                                                       (txtInsuranceCertificate.text,VehicleInsuranceCertificateDateMissing, .isEmpty),
                                                                       (txtDrivingLicense.text,DrivingLicenseDateMissing, .isEmpty),
                                                                       (txtPsvBadge.text,DriverPSVBadgeDateMissing, .isEmpty)]
       
        guard Validator.validate(validationParameter) else {
            completion(false)
            return
        }
        
        if txtClearanceReceipt.text!.isEmpty || txtClearanceReceipt.text == "Police Clearance Certificate/  Receipt (Expiry Date) 🗓" {
            AlertMessage.showMessageForError(PoliceClearanceDateMissing)
            completion(false)
            return
        }
        
        var status = true
        
        for button in buttons {
            
            if button.currentImage == #imageLiteral(resourceName: "camera-icon"){
                
                switch button.tag {
                case 1:
                    AlertMessage.showMessageForError(NtsaInspectionImageMissing)
                    status = false
                    completion(status)
                    return
                case 2:
                    AlertMessage.showMessageForError(VehicleInsuranceCertificateImageMissing)
                    status = false
                    completion(status)
                    return
                case 3:
                    AlertMessage.showMessageForError(VehicleLogBookImageMissing)
                    status = false
                    completion(status)
                    return
                case 4:
                    AlertMessage.showMessageForError(DrivingLicenseImageMissing)
                    status = false
                    completion(status)
                    return
                case 5:
                    AlertMessage.showMessageForError(NationalIDImageMissing)
                    status = false
                    completion(status)
                    return
                case 6:
                    AlertMessage.showMessageForError(PoliceClearanceImageMissing)
                    status = false
                    completion(status)
                    return
                case 7:
                    AlertMessage.showMessageForError(DriverPSVBadgeImageMissing)
                    status = false
                    completion(status)
                    return
                default:
                    AlertMessage.showMessageForError(documentImageErrorString)
                    status = false
                    completion(status)
                    return
                }
            }
        }
        
        
//

//
//        buttons.forEach{
//            if $0.currentImage == #imageLiteral(resourceName: "camera-icon"){
//
//                switch $0.tag {
//                case 1:
//                    AlertMessage.showMessageForError(NtsaInspectionImageMissing)
//                    status = false
//                    completion(status)
//                    return
//                case 2:
//                    AlertMessage.showMessageForError(VehicleInsuranceCertificateImageMissing)
//                    status = false
//                    completion(false)
//                    return
//                case 3:
//                    AlertMessage.showMessageForError(VehicleLogBookImageMissing)
//                    status = false
//                    completion(false)
//                    return
//                case 4:
//                    AlertMessage.showMessageForError(DrivingLicenseImageMissing)
//                    status = false
//                    completion(false)
//                    return
//                case 5:
//                    AlertMessage.showMessageForError(NationalIDImageMissing)
//                    status = false
//                    completion(false)
//                    return
//                case 6:
//                    AlertMessage.showMessageForError(PoliceClearanceImageMissing)
//                    status = false
//                    completion(false)
//                    return
//                case 7:
//                    AlertMessage.showMessageForError(DriverPSVBadgeImageMissing)
//                    status = false
//                    completion(false)
//                    return
//                default:
//                    AlertMessage.showMessageForError(documentImageErrorString)
//                    status = false
//                    completion(false)
//                    return
//                }
//            }
        
        if !status { completion(status); return }
        
        do {
            //            let parameter = try UserDefaults.standard.get(objectType: RegistrationParameter.self, forKey: keyRegistrationParameter)
            let loginData = try UserDefaults.standard.get(objectType: LoginModel.self, forKey: "userProfile") // .set(object: loginModelDetails, forKey: "userProfile")
            let parameter = loginData?.responseObject.driverDocs
            parameterArray.driver_id = parameter?.driverId ?? ""
        } catch{
            print(error.localizedDescription)
            return
        }
        
        parameterArray.ntsa_exp_date = sendToApiFormat(strDate: txtNTSA.text!) // txtNTSA.text!
        parameterArray.vehicle_insurance_exp_date = sendToApiFormat(strDate: txtInsuranceCertificate.text!) // txtInsuranceCertificate.text!
        
        parameterArray.driver_licence_exp_date = sendToApiFormat(strDate: txtDrivingLicense.text!) // txtDrivingLicense.text!
       
        parameterArray.police_clearance_exp_date = sendToApiFormat(strDate: txtClearanceReceipt.text!) // txtClearanceReceipt.text!
        parameterArray.psv_badge_exp_date = sendToApiFormat(strDate: txtPsvBadge.text!) // txtPsvBadge.text!
        parameterArray.presentIndex = 0
        do{
            try UserDefaults.standard.set(object: parameterArray, forKey: keyRegistrationParameter)
        }
        catch{
            completion(false)
            return
        }
        completion(true)
    }
    
    
    override func setupTextField() {
        assignDelegate()
        txtLogBook.isEnabled = false
        txtNationalId.isEnabled = false
    }
    
    func fillAllFields() {
        
        do {
//            let parameter = try UserDefaults.standard.get(objectType: RegistrationParameter.self, forKey: keyRegistrationParameter)
            let loginData = try UserDefaults.standard.get(objectType: LoginModel.self, forKey: "userProfile") // .set(object: loginModelDetails, forKey: "userProfile")
            let parameter = loginData?.responseObject.driverDocs
            
            let parameterRegisterArray = try UserDefaults.standard.get(objectType: RegistrationParameter.self, forKey: keyRegistrationParameter)
            
            if parameterRegisterArray != nil {
                print("----------------------------------------------------------")
                print("----------------------------------------------------------")
                print("SCREEN Licence Info ")
                print("----------------------------------------------------------")
                print("----------------------------------------------------------")
                print(parameterRegisterArray as Any)
                print("----------------------------------------------------------")
                print("----------------------------------------------------------")
            }
   
            
            txtNTSA.text = changeFormat(strDate: parameter?.ntsaExpDate ?? "") // parameter?.ntsaExpDate
            txtPsvBadge.text = changeFormat(strDate: parameter?.psvBadgeExpDate ?? "")
            txtDrivingLicense.text = changeFormat(strDate: parameter?.driverLicenceExpDate ?? "")
            txtInsuranceCertificate.text = changeFormat(strDate: parameter?.vehicleInsuranceExpDate ?? "")
            txtClearanceReceipt.text = changeFormat(strDate: parameter?.policeClearanceExpDate ?? "")
            
            let imageBase = NetworkEnvironment.imageBaseURL
          
            let NTSAinspectionImage = imageBase + "\(parameter?.ntsaInspectionImage ?? "")"
            let VehicleInsuranceImage = imageBase + "\(parameter?.vehicleInsuranceCerti ?? "")"
            let VehicleLogBookImage = imageBase + "\(parameter?.vehicleLogBookImage ?? "")"
            let DriverLicenceImage = imageBase + "\(parameter?.driverLicenceImage ?? "")"
            let NationalIDImage = imageBase + "\(parameter?.nationalIdImage ?? "")"
            let PoliceClearanceImage = imageBase + "\(parameter?.policeClearanceCerti ?? "")"
            let DriverPSVBadgeImage = imageBase + "\(parameter?.psvBadgeImage ?? "")"
            
            for btn in buttons {
                btn.sd_setIndicatorStyle(.gray)
                btn.sd_addActivityIndicator()
                
                if btn.tag == 1 {
                    btn.sd_setImage(with: URL(string: NTSAinspectionImage), for: .normal, completed: nil)
                } else if btn.tag == 2 {
                    btn.sd_setImage(with: URL(string: VehicleInsuranceImage), for: .normal, completed: nil)
                } else if btn.tag == 3 {
                    btn.sd_setImage(with: URL(string: VehicleLogBookImage), for: .normal, completed: nil)
                } else if btn.tag == 4 {
                    btn.sd_setImage(with: URL(string: DriverLicenceImage), for: .normal, completed: nil)
                } else if btn.tag == 5 {
                    btn.sd_setImage(with: URL(string: NationalIDImage), for: .normal, completed: nil)
                } else if btn.tag == 6 {
                    btn.sd_setImage(with: URL(string: PoliceClearanceImage), for: .normal, completed: nil)
                } else if btn.tag == 7 {
                    btn.sd_setImage(with: URL(string: DriverPSVBadgeImage), for: .normal, completed: nil)
                }
            }
        } catch{
            print(error.localizedDescription)
            return
        }
    }
    
    func changeFormat(strDate: String) -> String {
        
        let apiFormat = "yyyy-MM-dd"
        let dateFormat = "dd/MM/yy" // "dd MMM yyyy"
        
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        datePickerView.locale = .current
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = apiFormat
        let givenDate = dateFormatter.date(from: strDate)
       
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = dateFormat
        let givenDateString = dateFormatter2.string(from: givenDate ?? Date())
        
        return givenDateString
    }
    
    func sendToApiFormat(strDate: String) -> String {
        
        let apiFormat = "dd/MM/yy"
        let dateFormat = "yyyy-MM-dd" // "dd MMM yyyy"
        
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        datePickerView.locale = .current
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = apiFormat
        let givenDate = dateFormatter.date(from: strDate)
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = dateFormat
        let givenDateString = dateFormatter2.string(from: givenDate ?? Date())
        
        return givenDateString
    }
    
    @IBAction func openPicImage(_ sender : UIButton){
        if let vc = self.parentContainerViewController() as? RegistrationViewController{
            let imageVC : ImagePickerViewController = UIViewController.viewControllerInstance(storyBoard: .picker)
            imageVC.onDismiss = {
                sender.imageView?.contentMode = .scaleAspectFit
                sender.setImage(imageVC.pickedImage, for: .normal)
                self.uploadImages(image:imageVC.pickedImage, selected: sender.tag)
                self.addDismissButton(sender)

                imageVC.dismiss(animated: true)
                vc.dismiss(animated: true)
            }
            vc.present(imageVC, animated: true)
        }
        else
        {
            let imageVC : ImagePickerViewController = UIViewController.viewControllerInstance(storyBoard: .picker)
            imageVC.onDismiss = {
                sender.imageView?.contentMode = .scaleAspectFit
                sender.setImage(imageVC.pickedImage, for: .normal)
                self.uploadImages(image:imageVC.pickedImage, selected: sender.tag)
                self.addDismissButton(sender)
                
                imageVC.dismiss(animated: true)
                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.dismiss(animated: true, completion: nil)
            }
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(imageVC, animated: true)
        }
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
       let button = buttons.first(where: { $0.tag == sender.tag })
        button?.setImage(#imageLiteral(resourceName: "camera-icon"), for: .normal)
        self.setButtonData(tag: sender.tag, urlString: "")
        
        sender.removeFromSuperview()
    }
    
}
extension LicenseInfoView{
    func uploadImages(image: UIImage, selected index: Int){
        Loader.showHUD(with: self.parentContainerViewController()!.view)
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
            self.parameterArray.ntsa_inspection_image = urlString
        case 2:
            self.parameterArray.vehicle_insurance_certi = urlString
        case 3:
            self.parameterArray.vehicle_log_book_image = urlString
        case 4:
            self.parameterArray.driver_licence_image = urlString
        case 5:
            self.parameterArray.national_id_image = urlString
        case 6:
            self.parameterArray.police_clearance_certi = urlString
        case 7:
            self.parameterArray.psv_badge_image = urlString
        default:
            break
        }
    }
}
extension LicenseInfoView : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.textColor = UIColor.init(custom: .theme)
        openDatePicker(textField)
        return false
    }
    
    func openDatePicker(_ textField: UITextField){
        if let vc = self.parentContainerViewController() as? RegistrationViewController{
            let dateVC : DatePickerViewController = UIViewController.viewControllerInstance(storyBoard: .picker)
            dateVC.onDismiss = {
                textField.text = dateVC.date
//                vc.dismiss(animated: true)
            }
            vc.present(dateVC, animated: true)
        }
        else {
            let dateVC : DatePickerViewController = UIViewController.viewControllerInstance(storyBoard: .picker)
            dateVC.onDismiss = {
                textField.text = dateVC.date
                //                vc.dismiss(animated: true)
            }
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(dateVC, animated: true)
        }
    }

}
