//
//  AddMoneyView.swift
//  DPS
//
//  Created by Gaurang on 29/09/21.
//  Copyright © 2021 Mayur iMac. All rights reserved.
//

import UIKit
class AddMoneyView: UIView , UITextFieldDelegate{

    let textField = ThemeUnderLineTextField(smallStyle: true)
    let button = ThemePrimaryButton()
    var completion: (String) -> Void
    var isFromMeter: Bool
    var isfromWithDraw:Bool
    

    init(isfromWithDraw: Bool = false,
         isFromMeter: Bool = false,
         completion: @escaping (String) -> Void) {
        
        self.completion = completion
        self.isFromMeter = isFromMeter
        self.isfromWithDraw = isfromWithDraw
        super.init(frame: .zero)
        self.setViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var amount: String {
        textField.text ?? ""
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
        setViews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

    }

    func setViews() {
        button.isEnabled = false
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 60
        addSubview(stackView)
        stackView.setAllSideContraints(.zero)
        textField.placeholder = isFromMeter ? "Enter Passenger's Phone Number" : "Enter Amount"
        textField.smallStyle = true
        textField.keyboardType = isFromMeter ? .numberPad : .decimalPad
        textField.delegate = self
        stackView.addArrangedSubview(textField)
        if isfromWithDraw == true {
            button.setTitle("Withdraw", for: .normal)
        }
        else{
            button.setTitle(isFromMeter == true ? "Continue" : "Add Money", for: .normal)

        }
        stackView.addArrangedSubview(button)
        button.addTarget(self, action: #selector(addMoneyTapped), for: .touchUpInside)

        textField.addTarget(self, action: #selector(checkField), for: .editingChanged)
        
        if isFromMeter, UtilityClass.isSimulator {
            textField.text = "9727528777"
            button.isEnabled = true
        }
    }

    
    @objc func addMoneyTapped() {
       
        guard let parentVC = self.parentContainerViewController() as? BottomSheetViewController else {
            return
        }
        let amount = self.amount
        parentVC.dismiss(animated: false) {
            self.completion(amount)
            
        }
    }

    @objc func checkField() {
        if textField.unwrappedText.isEmpty  {
            button.isEnabled = false
        } else {
            button.isEnabled = true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if isFromMeter {
           return InputValidation.mobile.textField(textField,
                                                   shouldChangeCharactersIn: range,
                                                   replacementString: string)
        }
        return true
        
    }
    
}


class MeterPermissionView: UIView {

    let label = UILabel()
    let button = ThemePrimaryButton()
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

    func setViews() {
        label.textColor = UIColor.black.withAlphaComponent(0.6)
        label.font = FontBook.regular.font(ofSize: 14.0)
        label.text = "Allow your Rider to Access the meter"
        label.textAlignment = .center
        button.isEnabled = true
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 60
        addSubview(stackView)
        stackView.setAllSideContraints(.zero)
        stackView.addArrangedSubview(label)
        button.setTitle("Allow", for: .normal)
        stackView.addArrangedSubview(button)
        button.addTarget(self, action: #selector(addMoneyTapped), for: .touchUpInside)
    }

    @objc func addMoneyTapped() {
        completion()
        if let viewCtr = self.parentContainerViewController() as? BottomSheetViewController {
            viewCtr.hide()
        }
    }

    
}
