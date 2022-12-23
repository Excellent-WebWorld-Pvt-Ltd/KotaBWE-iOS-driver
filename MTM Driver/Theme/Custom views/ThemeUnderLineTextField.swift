//
//  ThemeUnderLineTextField.swift
//  DPS
//
//  Created by Gaurang on 01/10/21.
//  Copyright © 2021 Mayur iMac. All rights reserved.
//

import Foundation
import UIKit

enum ThemeTextFieldState {
    case normal
    case error
    case success

    var color: UIColor {
        switch self {
        case .normal:
            return .themeLightGray
        case .error:
            return .red
        case .success:
            return .green
        }
    }
}

class ThemeUnderLineTextField: UITextField {

    @IBInspectable var smallStyle: Bool = false
    let placeholderColor: UIColor = .lightGray
    var disabledColor: UIColor = .themeGray
    var selectedLineColor: UIColor = .themeColor
    var lineColor: UIColor = .themeLightGray
    fileprivate var _renderingInInterfaceBuilder: Bool = false
    var fontSize: CGFloat {
        smallStyle ? 15 : 18
    }

    var themeFont: UIFont {
        FontBook.regular.font(ofSize: fontSize)
    }

    var textFieldState: ThemeTextFieldState = .normal {
        didSet {
            updateLineColor()
        }
    }

    fileprivate var _highlighted: Bool = false

    override open var isHighlighted: Bool {
        get {
            return _highlighted
        }
        set {
            _highlighted = newValue
            updateLineView()
        }
    }

    @IBInspectable dynamic open var lineHeight: CGFloat = 2.0 {
        didSet {
            updateLineView()
            setNeedsDisplay()
        }
    }

    /// A CGFloat value that determines the height for the bottom line when the control is in a selected state
    @IBInspectable dynamic open var selectedLineHeight: CGFloat = 2.0 {
        didSet {
            updateLineView()
            setNeedsDisplay()
        }
    }

    var lineView: UIView!

    fileprivate func updatePlaceholder() {
        guard let placeholder = placeholder else {
            return
        }
        if placeholder.contains("(Optional)") {
            let smallString = "(Optional)"
            let fullRange = placeholder.nsRange
            let smallStringRange = placeholder.nsRange(of: smallString)
            let mutableAttrStr = NSMutableAttributedString(string: placeholder)
            mutableAttrStr.addAttributes([.font: themeFont,
                                          .foregroundColor: placeholderColor], range: fullRange)
            mutableAttrStr.addAttribute(.font, value: FontBook.regular.font(ofSize: 12), range: smallStringRange)
            attributedPlaceholder = mutableAttrStr
        } else {
            attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [
                    NSAttributedString.Key.foregroundColor: placeholderColor, NSAttributedString.Key.font: themeFont
                ]
            )
        }

    }

    override var placeholder: String? {
        didSet {
            setNeedsDisplay()
            updatePlaceholder()
        }
    }

    open var editingOrSelected: Bool {
        return super.isEditing || isSelected
    }

    fileprivate func updateLineView() {
        guard let lineView = lineView else {
            return
        }

        lineView.frame = lineViewRectForBounds(bounds, editing: editingOrSelected)
        updateLineColor()
    }

    fileprivate func updateLineColor() {
        guard let lineView = lineView else {
            return
        }

        if !isEnabled {
            lineView.backgroundColor = disabledColor
        } else {
            if textFieldState == .normal {
                lineView.backgroundColor = editingOrSelected ? selectedLineColor : lineColor
            } else {
                lineView.backgroundColor = textFieldState.color
            }
        }
    }

    open func lineViewRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {
        let height = editing ? selectedLineHeight : lineHeight
        return CGRect(x: 0, y: bounds.size.height - height, width: bounds.size.width, height: height)
    }

    open override var isSelected: Bool {
        didSet {
            updateControl(true)
        }
    }

    fileprivate func updateControl(_ animated: Bool = false) {
        updateLineColor()
        updateLineView()
    }


    init(smallStyle: Bool) {
        self.smallStyle = smallStyle
        super.init(frame: .zero)
        init_SkyFloatingLabelTextField()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        init_SkyFloatingLabelTextField()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        init_SkyFloatingLabelTextField()
    }

    fileprivate final func init_SkyFloatingLabelTextField() {
        borderStyle = .none
        tintColor = .themeGray
        textColor = .themeBlack
        font = themeFont

        createLineView()
        updateLineColor()
        addEditingChangedObserver()
        updatePlaceholder()
    }

    fileprivate func addEditingChangedObserver() {
        self.addTarget(self, action: #selector(ThemeUnderLineTextField.editingChanged), for: .editingChanged)
    }

    @objc open func editingChanged() {
        updateControl(true)

    }

    fileprivate func createLineView() {

        if lineView == nil {
            let lineView = UIView()
            lineView.isUserInteractionEnabled = false
            self.lineView = lineView
           // configureDefaultLineHeight()
        }

        lineView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        addSubview(lineView)
    }

    fileprivate func configureDefaultLineHeight() {
        let onePixel: CGFloat = 1.0 / UIScreen.main.scale
        lineHeight = 2.0 * onePixel
        selectedLineHeight = 2.0 * onePixel
    }

    @discardableResult
    override open func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        updateControl(true)
        return result
    }

    /**
     Attempt the control to resign being the first responder
     - returns: True when successfull resigning being the first responder
     */
    @discardableResult
    override open func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        updateControl(true)
        return result
    }

    /// update colors when is enabled changed
    override open var isEnabled: Bool {
        didSet {
            updateControl()
            updatePlaceholder()
        }
    }

    override open func prepareForInterfaceBuilder() {

        super.prepareForInterfaceBuilder()
        borderStyle = .none

        isSelected = true
        _renderingInInterfaceBuilder = true
        updateControl(false)
        invalidateIntrinsicContentSize()
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        lineView.frame = lineViewRectForBounds(bounds, editing: editingOrSelected || _renderingInInterfaceBuilder)
    }

    override open var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.size.width, height: smallStyle ? 27 : 37)
    }


}
