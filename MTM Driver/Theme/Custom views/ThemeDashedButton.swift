//
//  ThemeDashedButton.swift
//  DPS
//
//  Created by Gaurang on 01/10/21.
//  Copyright © 2021 Mayur iMac. All rights reserved.
//

import Foundation
import UIKit

class ThemeDashedButton: UIButton {

    private lazy var borderLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.themeColor.cgColor
        layer.lineDashPattern = [4, 4]
        layer.frame = bounds
        layer.fillColor = nil
        layer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 12, height: 12)).cgPath
        self.layer.insertSublayer(layer, at: 0)
        return layer
    }()


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setViews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
    }

    override open var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width, height: 50)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setViews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        borderLayer.frame = bounds
        titleLabel?.font = FontBook.regular.font(ofSize: 14)
    }

    func setViews() {
        self.setTitleColor(.themeColor, for: .normal)
    }

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.2) {
                self.transform = self.isHighlighted ? .init(scaleX: 0.9, y: 0.9) : .identity
            }
        }
    }
}
