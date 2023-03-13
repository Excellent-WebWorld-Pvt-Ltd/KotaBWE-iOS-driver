//
//  OTPVC.swift
//  DSP Driver
//
//  Created by Admin on 13/10/21.
//  Copyright © 2021 baps. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol OTPTextFieldDelegate   {
    func textFieldDidDelete(currentTextField: OTPTextField)
}

enum Direction { case left, right }

class OTPVC: BaseViewController , OTPTextFieldDelegate{

    //MARK:- ==== Outlets ==========
    @IBOutlet weak var btnResendCode: UnderlineTextButton!
    @IBOutlet weak var lblOTPTitle: UILabel!
    @IBOutlet weak var lblSubTitle: ThemeLabel!
    @IBOutlet weak var btnNext: ThemePrimaryButton!
    @IBOutlet var txtOTPCollection: [OTPTextField]!
    @IBOutlet weak var viewTimer: UIView!
    @IBOutlet weak var lblTimer: ThemeLabel!
    @IBOutlet weak var viewResendCode: UIView!
    @IBOutlet weak var lblTitle: ThemeLabel!
    
    
    //MARK:- ======= Variables ======
    var textFieldsIndexes:[UITextField:Int] = [:]
    var strMobileNo = String()
    var strEmail = ""
    var strOTP = String()
    var isFromRegister = false
    var objLoginData : LoginModel!
    var objResponseJSON : JSON!
    var parameterArray = RegistrationParameter.shared
    var myDelegate: OTPTextFieldDelegate?
    var timer:Timer!
    var totalSecond = 30

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewTimer.isHidden = true
        startTimer()
        viewResendCode.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
       // txtOTPCollection[0].becomeFirstResponder()
        buttonSetup()
        UISetup()
        filledOTP()
        self.setUpData()
        self.setLocalisation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.txtOTPCollection.first?.becomeFirstResponder()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setUpData(){
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }
    
    @objc func changeLanguage(){
        self.setLocalisation()
    }
    
    func setLocalisation(){
        self.lblSubTitle.text = "Enter 6 Digit Code That Has Been Sent To Your Registered Mail Id.".localized
        self.btnNext.setTitle("NEXT".localized, for: .normal)
        self.lblTitle.text = "Account Verification".localized
    }
    
    func filledOTP(){
        guard Singleton.shared.autoFillOTP else {
            return
        }
        let arr = strOTP.map { String($0) }
        txtOTPCollection[0].text = arr[0]
        txtOTPCollection[1].text = arr[1]
        txtOTPCollection[2].text = arr[2]
        txtOTPCollection[3].text = arr[3]
        txtOTPCollection[4].text = arr[4]
        txtOTPCollection[5].text = arr[5]
    }
    
    //MARK:- === Start Timer ======
    func startTimer(){
        lblTimer.text = "00.00"
        self.timer = Timer.scheduledTimer(timeInterval: 1 ,
                                                      target: self,
                                                      selector: #selector(self.countdown),
                                                      userInfo: nil,
                                                      repeats: true)
    }
    
    
    @objc func countdown() {
        var minutes: Int
        var seconds: Int

        if totalSecond == 0 {
            timer?.invalidate()
            let FormattedText = NSMutableAttributedString()
            FormattedText
                .regular("Didn’t receive code? ".localized, Colour: UIColor.black.withAlphaComponent(0.7), 14)
                .bold("Resend".localized)
            btnResendCode.setAttributedTitle(FormattedText, for: .normal)
            btnResendCode.isUserInteractionEnabled = true
        }
        else {
            UIView.setAnimationsEnabled(false)
            totalSecond = totalSecond - 1
            minutes = (totalSecond % 3600) / 60
            seconds = (totalSecond % 3600) % 60
            lblTimer.text = String(format: "%02d:%02d", minutes, seconds)
           
            UIView.performWithoutAnimation {
                let FormattedText = NSMutableAttributedString()
                FormattedText
                    .regular("Didn’t receive code? ".localized, Colour: UIColor.black.withAlphaComponent(0.7), 14)
                    .boldWithOpacity60("\("Resend in".localized) \(lblTimer.text ?? "")")
                btnResendCode.setAttributedTitle(FormattedText, for: .normal)
                btnResendCode.isUserInteractionEnabled = false
                UIView.setAnimationsEnabled(true)
            }
        }
        
    }
    
    //MARK:- ===== Btn Action Next =====
    @IBAction func btnActionNext(_ sender: UIButton) {
        guard validation() else { return }
        UIView.setAnimationsEnabled(true)
        if isFromRegister {
//            parameterArray.setNextRegistrationIndex(from: .registration)
//            SessionManager.shared.registrationParameter = parameterArray
            let profileInfo = AppViewControllers.shared.profile()
            self.navigationController?.isNavigationBarHidden = false
            self.push(profileInfo)
        }else {
            saveLoginData()
            AppDelegate.shared.setHome()
            
        }
    }
    
    
    //MARK:- ====== Resend OTP =======
    func webserviceCallReSendOTP(){
        
//        do {
//            let parameterSavedArray = try UserDefaults.standard.get(objectType: RegistrationParameter.self, forKey: keyRegistrationParameter)
//
//            let parameter = try! parameterSavedArray.asDictionary()
//
//
        Loader.showHUD(with: Helper.currentWindow)
        let resendOtpModel = ResendOTPModel()
        resendOtpModel.mobile_no = strMobileNo
        resendOtpModel.email = strEmail
        WebServiceCalls.resendOTP(OtpModel: resendOtpModel) { response, status in
            Loader.hideHUD()
            if status {
                print(response)
                AlertMessage.showMessageForSuccess(response["message"].stringValue)
                self.strOTP = response["otp"].stringValue
                self.filledOTP()
                self.totalSecond = 30
                self.startTimer()
            }
            else{
                AlertMessage.showMessageForError(response["message"].stringValue)
             }
            }
          }
//        catch {
//            print(error.localizedDescription)
//        }
    //}
        
        
    //MARK:- === Save Login Data =====
    func saveLoginData(){
        SessionManager.shared.saveSession(json: objResponseJSON)
    }
    
    
    //MARK:- ===== UISetup ======
    func UISetup(){
        lblOTPTitle.font = UIFont.regular(ofSize: 15.0)
        for (count,i) in txtOTPCollection.enumerated() {
            textFieldsIndexes[txtOTPCollection[count]] = count
            i.textColor = UIColor.black
            i.font = UIFont.regular(ofSize: 20.0)
            i.borderColor = UIColor.themeColor.withAlphaComponent(0.3)
            i.delegate = self
            i.myDelegate = self
        }
    }
    
    
    //MARK:- ===== Btn Action Resend =====
    @IBAction func btnActionResendOTP(_ sender: UIButton) {
        webserviceCallReSendOTP()
    }
    
    
    //MARK:- ==== Validation =======
    func validation() -> Bool {
        var strEnteredOTP = ""
        for index in 0 ..< txtOTPCollection.count {
            strEnteredOTP.append(txtOTPCollection[index].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
        }
        if strEnteredOTP == "" {
            AlertMessage.showMessageForError("Please enter otp.".localized)
            return false
        } else if self.strOTP != strEnteredOTP {
            self.clearAllFields()
            AlertMessage.showMessageForError("Please enter valid otp.".localized)
            return false
        }
        return true
    }

    
    //MARK:- ==== Clear All Fields ====
    func clearAllFields() {
        for index in 0 ..< txtOTPCollection.count {
            txtOTPCollection[index].text = ""
            txtOTPCollection[index].borderColor = UIColor.themeColor.withAlphaComponent(0.3)
         }
    }
    
    //MARK:- ==== Terms And Condition =====
    func buttonSetup(){
        let FormattedText = NSMutableAttributedString()
        FormattedText
            .normal("Didn’t receive code? ".localized, Colour: UIColor.black.withAlphaComponent(0.7))
            .bold("Resend".localized)
        btnResendCode.setAttributedTitle(FormattedText, for: .normal)
    }
    

    func setNextResponder(_ index:Int?, direction:Direction) {
            guard let index = index else { return }
            
            if direction == .left {
                if index == 0{
                    txtOTPCollection.first?.resignFirstResponder()
                }else{
                    txtOTPCollection[(index - 1)].becomeFirstResponder()
                }
                if index > 0 {
                    let neIndex = index + 1
                    for i in neIndex..<txtOTPCollection.count {
                        txtOTPCollection[i].text = ""
                    }
                }
            } else {
                if index == txtOTPCollection.count - 1{
                    txtOTPCollection.last?.resignFirstResponder()
                }else{
                    txtOTPCollection[(index + 1)].becomeFirstResponder()
                }
            }
        }
        
        func setNextResponderBlank(_ index:Int?) {
            if index! >= 0 {
                let neIndex = index! + 1
                for i in neIndex..<txtOTPCollection.count {
                    txtOTPCollection[i].text = ""
                }
            }
        }
}

//MARK:- class OTPTextField
class OTPTextField: UITextField {
    
    var myDelegate: OTPTextFieldDelegate?
    override func deleteBackward() {
        super.deleteBackward()
        myDelegate?.textFieldDidDelete(currentTextField: self)
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        self.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.9529411765, blue: 0.968627451, alpha: 1)
//        self.textAlignment = .center
//        self.layer.cornerRadius = 16
//        self.clipsToBounds = true
//        self.layer.borderColor = UIColor.black.cgColor
//        self.layer.borderWidth = 0
//        self.font = FontBook.semibold.font(ofSize: 12.0)
//        self.tintColor = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
//    }
}

//MARK:- UITextFieldDelegate
extension OTPVC : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.length == 0 {
            self.setNextResponder(textFieldsIndexes[textField as! OTPTextField], direction: .right)
            textField.text = string
            textField.borderColor = UIColor.themeColor.withAlphaComponent(1)
            return true
        } else if range.length == 1 {
            self.setNextResponder(textFieldsIndexes[textField as! OTPTextField], direction: .left)
            textField.text = ""
            textField.borderColor = UIColor.themeColor.withAlphaComponent(0.3)
            return false
        }
        return false
    }
    
    func textFieldDidDelete(currentTextField: OTPTextField) {
        self.setNextResponder(textFieldsIndexes[currentTextField], direction: .left)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        self.setNextResponderBlank(textFieldsIndexes[textField as! OTPTextField])
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField.text == ""){
            textField.borderColor = UIColor.themeColor.withAlphaComponent(0.3)
        }
    }
}
