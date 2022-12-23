//
//  ThemePrimaryButton.swift
//  DPS
//
//  Created by Gaurang on 28/09/21.
//  Copyright © 2021 Mayur iMac. All rights reserved.
//

import Foundation
import UIKit

class BouncingButton: ThemeButton {
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.2) {
                self.transform = self.isHighlighted ? .init(scaleX: 0.85, y: 0.85) : .identity
            }
        }
    }
}

class ThemePrimaryButton: BouncingButton {

    private var activityIndicator: UIActivityIndicatorView!
    private var originalButtonText: String?
    @IBInspectable var smallStyle: Bool = false
    @IBInspectable var whitStyle: Bool = false
    
    var height: CGFloat {
        smallStyle || whitStyle ? 30 : 40
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setViews()
    }

    init(smallStyle: Bool) {
        self.smallStyle = smallStyle
        super.init(frame: .zero)
        setViews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
       setViews()
    }

    override open var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width, height: height)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setViews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    func setViews() {
        self.setTitleColor(whitStyle ? .themeColor : .white, for: .normal)
        self.contentEdgeInsets = .init(top: 0, left: 14, bottom: 0, right: 14)
        backgroundColor = whitStyle ? .white : .themeColor
        titleLabel?.font = FontBook.bold.font(ofSize: smallStyle || whitStyle ? 13 : 14)
        setNeedsDisplay()
        clipsToBounds = true
        self.layer.cornerRadius = height / 2
    }

    override var isEnabled: Bool {
        didSet{
            self.backgroundColor = self.isEnabled ? (whitStyle ? .white : .themeColor) : .themeGray
        }
    }
}

// MARK: - Loader
extension ThemePrimaryButton {

    func showLoading() {
        isEnabled = false
        originalButtonText = self.titleLabel?.text

        self.setTitle("", for: .normal)
        if (activityIndicator == nil) {
            activityIndicator = createActivityIndicator()
        }

        showSpinning()
    }

    func hideLoading() {
        isEnabled = true
        self.setTitle(originalButtonText, for: .normal)
        activityIndicator.stopAnimating()
    }

    private func createActivityIndicator() -> UIActivityIndicatorView {

        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        return activityIndicator
    }

    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }

    private func centerActivityIndicatorInButton() {
        activityIndicator.setCenterToViewContraints()
    }
}
