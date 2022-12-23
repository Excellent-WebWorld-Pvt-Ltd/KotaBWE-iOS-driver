//
//  AddCardView.swift
//  DPS
//
//  Created by Gaurang on 01/10/21.
//  Copyright © 2021 Mayur iMac. All rights reserved.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift
import FormTextField

class AddCardView: UIView {

    let numberTextField = ThemeUnderLineTextField(smallStyle: true)
    let expTextField = ThemeUnderLineTextField(smallStyle: true)
    let cvvTextField = ThemeUnderLineTextField(smallStyle: true)
    let holderNameTextField = ThemeUnderLineTextField(smallStyle: true)
    
    let button = ThemePrimaryButton()

    private let creditCardValidator = CreditCardValidator()
    var validation = Validation()
    var inputValidator = InputValidator()


    var completion: () -> Void

    init(completion: @escaping () -> Void) {
        self.completion = completion
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

    private func configTextFields() {
        numberTextField.keyboardType = .decimalPad
        expTextField.keyboardType = .decimalPad
        cvvTextField.keyboardType = .decimalPad
        holderNameTextField.textContentType = .name

        numberTextField.placeholder = "Card Number"
        expTextField.placeholder = "Exp. Date"
        cvvTextField.placeholder = "CVV"
        holderNameTextField.placeholder = "Card Holder Name"

        numberTextField.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
        expTextField.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
        cvvTextField.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
        holderNameTextField.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)

        numberTextField.delegate = self
        expTextField.delegate = self
        cvvTextField.delegate = self
        holderNameTextField.delegate = self

        let imageView = UIImageView(frame: .init(x: 0, y: 0, width: 30, height: 30))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        numberTextField.rightView = imageView
        numberTextField.rightViewMode = .always
        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

    func setViews() {
        configTextFields()
        button.isEnabled = false
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 60
        addSubview(stackView)
        stackView.setAllSideContraints(.zero)

        let detailStack = UIStackView()
        detailStack.axis = .vertical
        detailStack.spacing = 20

        detailStack.addArrangedSubview(numberTextField)
        let expCvvStack = UIStackView()
        expCvvStack.axis = .horizontal
        expCvvStack.distribution = .fillEqually
        expCvvStack.spacing = 26
        expCvvStack.addArrangedSubview(expTextField)
        expCvvStack.addArrangedSubview(cvvTextField)
        detailStack.addArrangedSubview(expCvvStack)

        detailStack.addArrangedSubview(holderNameTextField)

        button.setTitle("Add Card", for: .normal)

        stackView.addArrangedSubview(detailStack)
        stackView.addArrangedSubview(button)
        button.addTarget(self, action: #selector(addCardTapped), for: .touchUpInside)


    }

    @objc func addCardTapped() {
        addCardRequest()
    }

    func hide() {
        if let viewCtr = self.parentContainerViewController() as? BottomSheetViewController {
            viewCtr.hide()
        }
    }

    @objc func textFieldValueChanged(_ sender: ThemeUnderLineTextField) {
        let value = sender.unwrappedText
        switch sender {
        case numberTextField:
            numberTextField.text = CCValidator.modifyCreditCardString(creditCardString: value)
        case expTextField:
            break
        case cvvTextField:
            let isValid = CCValidator.validate(cvv: value)
            sender.textFieldState = isValid ? .success : .error
        default:
            break
        }
        let isValid = numberTextField.textFieldState == .success &&
            expTextField.textFieldState == .success &&
            cvvTextField.textFieldState == .success &&
            holderNameTextField.textFieldState == .success
        button.isEnabled = isValid
    }

}

extension AddCardView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text as NSString? else {
            return true
        }
        var resultString = text.replacingCharacters(in: range, with: string)
        if resultString.isEmpty {
            (textField as? ThemeUnderLineTextField)?.textFieldState = .normal
            if textField == numberTextField, let imageView = numberTextField.rightView as? UIImageView {
                imageView.image = nil
            }
            return true
        }
        //Allow Only digits
        if textField == holderNameTextField {
            holderNameTextField.textFieldState = resultString.isEmpty ? .normal : .success
            return true
        } else {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            if  !allowedCharacters.isSuperset(of: characterSet) {
                return false
            }
        }

        if textField == numberTextField {
            resultString = CCValidator.modifyCreditCardString(creditCardString: resultString)
            if resultString.count > 19 {
                return false
            }
            let type = CCValidator.typeCheckingPrefixOnly(creditCardNumber: resultString)
            if let imageView = numberTextField.rightView as? UIImageView {
                imageView.image = UIImage(named: type.cardImageString)
            }
            if type == .notRecognized {
                numberTextField.textFieldState = .error
                return true
            } else {
                if CCValidator.validate(creditCardNumber: resultString) {
                    numberTextField.textFieldState = .success
                } else {
                    numberTextField.textFieldState = .normal
                }
            }
        }

        if textField == expTextField {
            if range.length > 0 {
                expTextField.textFieldState = .normal
                return true
            }
            if string == "" {
                return false
            }
            if resultString.count > 5 {
                return false
            }
            var originalText = textField.text!

            //Put / after 2 digit
            if range.location == 2 {
                originalText.append("/")
                textField.text = originalText
            }
            let isValid = CCValidator.validate(expireDate: resultString)
            expTextField.textFieldState = isValid ? .success : .error
            return true

        }

        return true
    }
}

// MARK: Add Card web service

extension AddCardView {

    private func addCardRequest() {

        let addCardReqModel = AddCardRequestModel()

        addCardReqModel.driver_id = "\(Singleton.shared.driverId)"
        addCardReqModel.card_no = numberTextField.unwrappedText
        addCardReqModel.card_holder_name = holderNameTextField.unwrappedText
        let expMonthYearArray = expTextField.unwrappedText.components(separatedBy: "/")
        addCardReqModel.exp_date_month = expMonthYearArray.first ?? ""
        addCardReqModel.exp_date_year = expMonthYearArray.last ?? ""
        addCardReqModel.cvv = cvvTextField.unwrappedText

        button.showLoading()
        self.isUserInteractionEnabled = false
        WebServiceCalls.addCardInList(addCardModel: addCardReqModel) { (json, status) in
            self.isUserInteractionEnabled = true
            self.button.hideLoading()
            if status {
                self.isUserInteractionEnabled = true
                let message = json.dictionary?["message"]?.string ?? ""
                self.button.hideLoading()
                AlertMessage.showMessageForSuccess(message)
                self.completion()
                self.hide()

            } else {
                AlertMessage.showMessageForError(json.dictionary?["message"]?.string ?? "")
            }
        }
    }

}
