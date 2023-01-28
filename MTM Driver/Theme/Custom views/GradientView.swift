//
//  GradientView.swift
//  DSP Driver
//
//  Created by Admin on 18/10/21.
//  Copyright © 2021 baps. All rights reserved.
//

import Foundation
import UIKit

public class Gradient: UIView {
    var startColor: UIColor = .themeBlue {
        didSet { updateColors() }
    }
    var endColor: UIColor = .themeBlue {
        didSet { updateColors() }
    }
    @IBInspectable var startLocation: Double = 0.05 {
        didSet { updateLocations() }
    }
    @IBInspectable var endLocation: Double = 0.95 {
        didSet { updateLocations() }
    }
    @IBInspectable var horizontalMode: Bool = true {
        didSet { updatePoints() }
    }
    @IBInspectable var diagonalMode: Bool = false {
        didSet { updatePoints() }
    }
    
    override public class var layerClass: AnyClass {
        CAGradientLayer.self
    }

    var gradientLayer: CAGradientLayer {
        layer as! CAGradientLayer
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        refreshUI()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        refreshUI()
    }

    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? .init(x: 1, y: 0) : .init(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 0, y: 1) : .init(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        refreshUI()
    }
    
    private func refreshUI() {
        updatePoints()
        updateLocations()
        updateColors()
    }

}
