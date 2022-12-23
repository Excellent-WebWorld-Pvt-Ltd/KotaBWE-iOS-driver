//
//  SendMoneyView.swift
//  DPS
//
//  Created by Gaurang on 29/09/21.
//  Copyright © 2021 Mayur iMac. All rights reserved.
//


import Foundation
import UIKit

class SendMoneyView: UIView {

    let amountTextField = ThemeUnderLineTextField(smallStyle: true)
    let numberTextField = ThemeUnderLineTextField(smallStyle: true)
    let stackView = UIStackView()
    let textStack = UIStackView()
    let sendingLabel = UILabel()
    let numberLabel = UILabel()
    let button = ThemePrimaryButton()

    var amount = String()
    var phone = String()
  //  var completion: (_ title: String) -> Void

    var hasInput: Bool = false
    var isMobileVerified: Bool = false
    var onSent: () -> Void

    
    init(onSent: @escaping () -> Void) {
        self.onSent = onSent
        super.init(frame: .zero)
        self.setViews()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        setViews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

    }
    

    func setViews() {

        button.isEnabled = false

        stackView.axis = .vertical
        stackView.spacing = 60
        addSubview(stackView)
        stackView.setAllSideContraints(.zero)
        textStack.axis = .vertical
        textStack.spacing = 20

        amountTextField.placeholder = "Enter Amount"
        amountTextField.keyboardType = .decimalPad
        textStack.addArrangedSubview(amountTextField)
        numberTextField.placeholder = "Enter Phone Number"
        numberTextField.keyboardType = .numberPad
        numberTextField.textContentType = .telephoneNumber
        textStack.addArrangedSubview(numberTextField)

        sendingLabel.font = FontBook.semibold.font(ofSize: 18)
        sendingLabel.textColor = .themeBlack
        sendingLabel.textAlignment = .center
        numberLabel.textAlignment = .center

        textStack.addArrangedSubview(sendingLabel)
        textStack.addArrangedSubview(numberLabel)

        stackView.addArrangedSubview(textStack)
        button.setTitle("Send Money", for: .normal)
        stackView.addArrangedSubview(button)
        button.addTarget(self, action: #selector(addMoneyTapped), for: .touchUpInside)

        setVisibilityState()
        amountTextField.addTarget(self, action: #selector(checkField), for: .editingChanged)
        numberTextField.addTarget(self, action: #selector(checkField), for: .editingChanged)
    }

    private func setSendingText( ){
        sendingLabel.text = "Sending \(amount.toCurrencyString())"
        let fullString = "to +254 \(phone)"
        let fullRange = fullString.nsRange
        let underlineString = "+254 \(phone)"
        let underlineRange = fullString.nsRange(of: underlineString)
        let attrStr = NSMutableAttributedString(string: fullString)
        attrStr.addAttributes([.font: FontBook.semibold.font(ofSize: 14), .foregroundColor: UIColor.themeGray], range: fullRange)
        attrStr.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: underlineRange)
        numberLabel.attributedText = attrStr
    }

    func setVisibilityState() {
        setTitle()
        textStack.spacing = 10
        setSendingText()
        amountTextField.isHidden = isMobileVerified
        numberTextField.isHidden = isMobileVerified
        UIView.animate(withDuration: 0.5) {
            self.sendingLabel.isHidden = !self.isMobileVerified
            self.numberLabel.isHidden = !self.isMobileVerified
        }

    }
//    @objc func addMoneyTapped() {
//        if !hasInput {
//            hasInput = true
//            amount = amountTextField.unwrappedText
//            phone = numberTextField.unwrappedText
//
//            setVisibilityState()
//
//        } else {
//            if let viewCtr = self.parentContainerViewController() as? BottomSheetViewController {
//                viewCtr.hide()
//            }
//        }
//    }
    
    @objc func addMoneyTapped() {
        if !isMobileVerified {
            phone = numberTextField.unwrappedText
            amount = amountTextField.unwrappedText
            self.endEditing(true)
            self.webServiceForTransferMoneyMobileVerification()
        } else {
            self.webServiceForTransferMoney()
        }
    }

    @objc private func goBack() {
        if let viewCtr = self.parentContainerViewController() as? BottomSheetViewController {
            viewCtr.hide()
        }
    }
    
    
    func setTitle() {
        if let viewCtr = self.parentContainerViewController() as? BottomSheetViewController {
            viewCtr.titleLabel.text = isMobileVerified ? "Confirm Payment" : "Send Money"
        }
    }

    @objc func checkField() {
        if amountTextField.unwrappedText.isEmpty || numberTextField.unwrappedText.isEmpty {
            button.isEnabled = false
        } else {
            button.isEnabled = true
        }
    }
    
    func webServiceForTransferMoneyMobileVerification() {
        let requestModel = MobileVerifRequestModel(mobileNo: phone)
        button.showLoading()
        WebServiceCalls.transferMoneyMobileVerify(requestModel: requestModel) { (json, status) in
            self.button.hideLoading()
            if status {
                self.isMobileVerified = true
                self.setVisibilityState()
            } else {
                AlertMessage.showMessageForError(json["message"].stringValue)
            }
        }
    }

    func webServiceForTransferMoney() {
        let requestModel = TransferMoneyRequestModel(mobileNo: phone, amount: amount)
        button.showLoading()
        WebServiceCalls.transferMoney(transferMoneyModel: requestModel) { (json, status) in
            self.button.hideLoading()
            if status {
                Singleton.shared.walletBalance = json["wallet_balance"].stringValue
                AlertMessage.showMessageForSuccess(json["message"].stringValue)
                self.onSent()
                self.goBack()
            } else {
                self.isMobileVerified = false
                self.setVisibilityState()
                AlertMessage.showMessageForError(json["message"].stringValue)
            }
        }
    }
}

