//
//  ThemeBlackGradientView.swift
//  DPS
//
//  Created by Gaurang on 29/09/21.
//  Copyright © 2021 Mayur iMac. All rights reserved.
//

import UIKit


class ThemeBlackGradientView: UIView {

    private let color1 = UIColor.themeColor
    private let color2 = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    private var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configureGradient()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureGradient()
    }

    private func configureGradient() {
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5) // Left side.
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5) // Right side.
        gradientLayer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        gradientLayer.cornerRadius = 15
        updateColors()
    }

    private func updateColors() {
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
    }

}

class ThemeBlackGradientBar: UIView {

    private let color1 = UIColor.themeColor
    private let color2 = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    private var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configureGradient()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureGradient()
    }

    private func configureGradient() {
        gradientLayer.startPoint = CGPoint(x: 0, y: 0) // Left side.
        gradientLayer.endPoint = CGPoint(x: 0, y: 0.5) // Right side.
        gradientLayer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        gradientLayer.cornerRadius = 15
        updateColors()
    }

    private func updateColors() {
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
    }

}

class ThemeRoundCorenrView : UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layoutIfNeeded()
        self.roundCorners([.topRight], radius: 15.0)
    }
}

class DottedLineView : UIView {
    @IBInspectable public var IsHorizontal: Bool = false
    override func awakeFromNib() {
        if IsHorizontal {
            self.addDashedBorderHorizontal()
        } else {
            self.addDashedBorderVertical()
        }
        
    }

//Border
    func addDashedBorderVertical() {
        //Create a CAShapeLayer
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = #colorLiteral(red: 0.611544311, green: 0.2912456691, blue: 0.8909440637, alpha: 1)
        shapeLayer.lineWidth = 1
        // passing an array with the values [2,3] sets a dash pattern that alternates between a 2-user-space-unit-long painted segment and a 3-user-space-unit-long unpainted segment
        shapeLayer.lineDashPattern = [2,3]
        
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0),
                                CGPoint(x: 0, y: self.frame.height)])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
    
    func addDashedBorderHorizontal() {
        //Create a CAShapeLayer
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.hexStringToUIColor(hex: "#006CB5").cgColor
        shapeLayer.lineWidth = 1
        // passing an array with the values [2,3] sets a dash pattern that alternates between a 2-user-space-unit-long painted segment and a 3-user-space-unit-long unpainted segment
        shapeLayer.lineDashPattern = [2,3]
        
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0),
                                CGPoint(x: self.frame.width, y: 0)])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
}
