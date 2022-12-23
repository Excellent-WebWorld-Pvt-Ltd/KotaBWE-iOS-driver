//
//  ThemeBorderedButton.swift
//  DPS
//
//  Created by Gaurang on 08/10/21.
//  Copyright © 2021 Mayur iMac. All rights reserved.
//

import Foundation
import UIKit

class ThemeBorderedButton: UIButton {

    private var activityIndicator: UIActivityIndicatorView!
    private var originalButtonText: String?

    @IBInspectable var grayStyle: Bool = false
    @IBInspectable var redStyle: Bool = false

    private var themeColor: UIColor {
        if grayStyle {
            return .themeGray
        } else if redStyle {
            return .red
        } else {
            return .themeColor
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setViews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
       setViews()
    }

    override open var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width, height: grayStyle ? 30 : 40)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setViews()
    }

    func setViews() {
        self.setTitleColor(themeColor, for: .normal)
        tintColor = .themeColor
        backgroundColor = .white
        self.contentEdgeInsets = .init(top: 0, left: 8, bottom: 0, right: 8)
        clipsToBounds = true
        self.layer.cornerRadius = (grayStyle ? 30 : 40) / 2
        self.layer.borderWidth = 1
        self.layer.borderColor = themeColor.cgColor
        titleLabel?.font = FontBook.bold.font(ofSize: 12)
    }

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.2) {
                self.transform = self.isHighlighted ? .init(scaleX: 0.9, y: 0.9) : .identity
            }
        }
    }

    override var isEnabled: Bool {
        didSet{
            self.alpha = self.isEnabled ? 1.0 : 0.6
        }
    }
}

// MARK: - Loader
extension ThemeBorderedButton {

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

        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .black
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
