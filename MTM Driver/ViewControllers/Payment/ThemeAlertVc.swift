//
//  ThemeAlertVc.swift
//  DSP Driver
//
//  Created by Admin on 24/11/21.
//  Copyright © 2021 baps. All rights reserved.
//

import Foundation
import UIKit

class ThemeAlertVC: UIViewController {

    @IBOutlet weak var transperentView: UIView!
    @IBOutlet weak var titleLabel: ThemeLabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var textField: ThemeUnderLineTextField!
    
    var onConfirmed: (() -> Void)?
    var onPinSelected: ((_ pin: String) -> Void)?
    var onDismiss: (() -> Void)?

    var alertType: AlertType?

    class func present(from viewCtr: UIViewController, ofType type: AlertType, onDismiss: (() -> Void)? = nil) {
        let alertCtr = AppViewControllers.shared.alertView
        alertCtr.modalTransitionStyle = .crossDissolve
        alertCtr.modalPresentationStyle = .overCurrentContext
        alertCtr.alertType = type
        alertCtr.onDismiss = onDismiss
        viewCtr.present(alertCtr, animated: true)
        UtilityClass.triggerHapticFeedback(.warning)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        transperentView.addTouchGesture {
            self.hide()
        }
        guard let type = alertType else {
            self.hide()
            return
        }
        var attrString: NSAttributedString?
        let font = FontBook.regular.font(ofSize: 16)
        let dismissButton = ThemePrimaryButton(smallStyle: true)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        paragraphStyle.alignment = .center
        switch type {
        case .simple(let title, let message):
            textField.isHidden = true
            titleLabel.isHidden = title == nil
            titleLabel.text = title
            attrString = NSAttributedString(string: message, attributes: [.font: font,
                                                                          .foregroundColor: UIColor.themeBlack,
                                                                          .paragraphStyle: paragraphStyle])
            dismissButton.setTitle("OK".localized, for: .normal)
        case .otp(let title, let message, let otp):
            textField.isHidden = true
            titleLabel.isHidden = title == nil
            titleLabel.text = title
            let mutableAttrStr = NSMutableAttributedString(string: message)
            let fullRange = message.nsRange
            let otpRange = message.nsRange(of: otp)
            mutableAttrStr.addAttribute(.font, value: font, range: fullRange)
            mutableAttrStr.addAttribute(.foregroundColor, value: UIColor.themeGray, range: fullRange)
            mutableAttrStr.addAttribute(.font, value: FontBook.semibold.font(ofSize: 20), range: otpRange)
            mutableAttrStr.addAttribute(.foregroundColor, value: UIColor.themeBlack, range: otpRange)
            mutableAttrStr.addAttribute(.paragraphStyle, value: paragraphStyle, range: fullRange)
            attrString = mutableAttrStr
            dismissButton.setTitle("OK".localized, for: .normal)
        case .logout:
            textField.isHidden = true
            titleLabel.text = "Log Out".localized
            let attribute: [NSAttributedString.Key: Any] = [.font: font,
                                                            .foregroundColor: UIColor.themeBlack,
                                                            .paragraphStyle: paragraphStyle]
            attrString = NSAttributedString(string: "Are you sure you want to logout?".localized, attributes: attribute)
            dismissButton.setTitle("Cancel".localized, for: .normal)
            let logoutButton = ThemePrimaryButton(smallStyle: true)
            logoutButton.setTitle("Logout".localized, for: .normal)
            logoutButton.addTarget(self, action: #selector(logoutTapped(_:)), for: .touchUpInside)
            buttonStackView.addArrangedSubview(logoutButton)
        case .confirmation(let title, let message, let onConfirmed):
            textField.isHidden = true
            titleLabel.text = title
            self.onConfirmed = onConfirmed
            let attribute: [NSAttributedString.Key: Any] = [.font: font,
                                                            .foregroundColor: UIColor.themeBlack,
                                                            .paragraphStyle: paragraphStyle]
            attrString = NSAttributedString(string: message, attributes: attribute)
            dismissButton.setTitle("Cancel".localized, for: .normal)
            let logoutButton = ThemePrimaryButton(smallStyle: true)
            logoutButton.setTitle("Yes".localized, for: .normal)
            logoutButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
            buttonStackView.addArrangedSubview(logoutButton)
        case .cardPin(let onPinSelected):
            self.onPinSelected = onPinSelected
            titleLabel.text = "Enter card pin"
            messageLabel.isHidden = true
            textField.keyboardType = .decimalPad
            textField.placeholder = "Pin"
            textField.becomeFirstResponder()
            dismissButton.setTitle("Cancel", for: .normal)
            dismissButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
            buttonStackView.addArrangedSubview(dismissButton)
            let logoutButton = ThemePrimaryButton(smallStyle: true)
            logoutButton.setTitle("Done", for: .normal)
            logoutButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
            buttonStackView.addArrangedSubview(logoutButton)
            return
        case .deleteUser:
            textField.isHidden = true
            titleLabel.text = "Delete Account".localized
            let attribute: [NSAttributedString.Key: Any] = [.font: font,
                                                            .foregroundColor: UIColor.themeBlack,
                                                            .paragraphStyle: paragraphStyle]
            attrString = NSAttributedString(string: "\("Are you sure you want to delete your".localized) \"\(Helper.appName)\" \("Account".localized)?", attributes: attribute)
            dismissButton.setTitle("Not Now".localized, for: .normal)
            let logoutButton = ThemePrimaryButton(smallStyle: true)
            logoutButton.setTitle("Delete".localized, for: .normal)
            logoutButton.addTarget(self, action: #selector(deleteAccountRequest(_:)), for: .touchUpInside)
            buttonStackView.addArrangedSubview(logoutButton)
            Helper.triggerHapticFeedback(.warning)
        }
        messageLabel.attributedText = attrString
        dismissButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
        buttonStackView.addArrangedSubview(dismissButton)
    }

    @objc private func confirmTapped() {
        onConfirmed?()
        onPinSelected?(textField.unwrappedText)
        hide()
    }

    @objc private func hide() {
        self.dismiss(animated: true) {
            self.onDismiss?()
        }
    }

    @objc private func logoutTapped(_ sender: ThemePrimaryButton) {
        hide()
        ThemeAlertVC.webserviceForLogout()
    }

    @objc private func deleteAccountRequest(_ sender: ThemePrimaryButton) {
        hide()
        let param: [String: String] = ["driver_id": Singleton.shared.userProfile?.responseObject.id ?? ""]
        Loader.showHUD()
        WebServiceCalls.deleteAccountAPi(params: param) { json, status in
            Loader.hideHUD()
            if status {
                SessionManager.shared.logout()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute:{
                    AlertMessage.showMessageForSuccess("\(json[ "message"])")
                })
            }else {
                AlertMessage.showMessageForError(json.getApiMessage())
            }
        }
    }
    
    class func webserviceForLogout() {
        let param: [String: Any] = ["driver_id": Singleton.shared.userProfile!.responseObject.id, "device_token": SessionManager.shared.fcmToken ?? ""]
        Loader.showHUD()
        WebServiceCalls.LogoutApi(strType: param) { (response, status) in
            Loader.hideHUD()
            SessionManager.shared.logout()
        }
    }
}

extension ThemeAlertVC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

extension ThemeAlertVC {

    enum AlertType {
        case simple(title: String? = nil, message: String)
        case otp(title: String? = nil, message: String, otp: String)
        case logout
        case confirmation(title: String? = nil, message: String, onConfirmed: () -> Void )
        case cardPin(onConfirmed: (_ pin: String) -> Void)
        case deleteUser
    }

}
