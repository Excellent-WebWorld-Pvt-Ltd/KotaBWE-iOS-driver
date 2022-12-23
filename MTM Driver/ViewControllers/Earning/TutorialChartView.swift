//
//  TutorialChartView.swift
//  DSP Driver
//
//  Created by Admin on 01/12/21.
//  Copyright © 2021 baps. All rights reserved.
//

import Foundation
import UIKit
import EasyTipView
import MKToolTip


class TutorialChartView: UIView {

    
    var viewModel = TutorialChartViewModel()
    var tapRecognizer:UITapGestureRecognizer!
    
    var onTapBar: ((_ bar: UIView , _ SelectedMark:Double) -> Void)?
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
//        preferences.animating.showInitialTransform = CGAffineTransform(translationX: 0, y: -15)
//        preferences.animating.showInitialAlpha = 0
//        preferences.animating.showDuration = 1.5
//        preferences.animating.dismissDuration = 1.5
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleBarTap))
        addGestureRecognizer(tapRecognizer)
    }
    
    deinit {
        removeGestureRecognizer(tapRecognizer)
    }
    
    func configuration(){
              
    }
   
    
    func setData(_ dataPoints: [Double]) {
        backgroundColor = UIColor.clear
        
        viewModel.dataPoints = dataPoints
        clearViews()
        
        // Do not continue if no bar has height > 0
        guard viewModel.maxY > 0.0 else { return } // max bar must be > 0
        createChart()
    }
    
    func clearViews() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }
    
    func createChart() {
        var lastBar:UIView?
        
        for (i, dataPoint) in viewModel.dataPoints.enumerated() {
            let barView = createBarView(barNumber: i, barValue: dataPoint)
            
            if let lastBar = lastBar {
                let gapView = createGapView(lastBar: lastBar)
                barView.leftAnchor.constraint(equalTo: gapView.rightAnchor).isActive = true
            } else {
                barView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            }
            
            if i == viewModel.dataPoints.count - 1 {
                barView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            }
            
            // All bars pinned to bottom of containing view
            barView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            
            // calculate height of bar relative to maxY
            barView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: CGFloat(dataPoint / viewModel.maxY)).isActive = true
            
            lastBar = barView
        }
    }
    
    func createBarView(barNumber: Int, barValue: Double) -> UIView {
        let barView = ThemeBlackGradientBar()
       // barView.applyGradient(colours: [UIColor.black,UIColor.white])
        //barView.applyGradient(colours: [UIColor.hexStringToUIColor(hex: "#006CB5"), UIColor.hexStringToUIColor(hex: "#9CD1F4")])
        addSubview(barView)
        barView.translatesAutoresizingMaskIntoConstraints = false
        barView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: viewModel.barWidthPctOfTotal).isActive = true
        
        barView.tag = barNumber + 1000  // give each bar a known tag to use in finding the view later
        barView.backgroundColor = viewModel.barColor
        barView.layer.cornerRadius = viewModel.barCornerRadius

        return barView
    }
    
    func createGapView(lastBar: UIView) -> UIView {
        let gapView = UIView()
        addSubview(gapView)
        gapView.translatesAutoresizingMaskIntoConstraints = false
        gapView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        gapView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        gapView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: viewModel.barGapPctOfTotal).isActive = true
        gapView.leftAnchor.constraint(equalTo: lastBar.rightAnchor).isActive = true
        return gapView
    }
    
    @objc func handleBarTap() {
        if let hitView = tapRecognizer.view {
            let loc = tapRecognizer.location(in: self)
            if let barViewTapped = hitView.hitTest(loc, with: nil) {
                for barView in subviews where barView.tag >= 1000 {
                    print(barView.tag)
                    if barView.tag == barViewTapped.tag {
                        let strtag = "\(barViewTapped.tag)"
                        let LastTag = "\(strtag.last!)"
                        print(LastTag)
                        let intTag = Int(LastTag) ?? 0
                        //guard let intTag = Int(LastTag) else { return }
                        self.onTapBar?(barView, viewModel.dataPoints[intTag])
                        print(barView.topAnchor)
                        print(barView.tag)
                        barView.alpha = 1
                    }
                    else {
                        barView.alpha = 0.5
                    }
//                    barView.backgroundColor = barView.tag == barViewTapped.tag ?
//
//                        viewModel.barColor.withAlphaComponent(1): viewModel.barColor
                }
                
            }
        }
    }
}
class TutorialChartViewModel {
    var dataPoints = [Double]()
    var barColor = UIColor.blue
    
    var maxY : Double {
        return dataPoints.sorted(by: >).first ?? 0
    }
    
    var barGapPctOfTotal : CGFloat {
        return CGFloat(0.2) / CGFloat(dataPoints.count - 1)
    }
    
    var barWidthPctOfTotal : CGFloat {
        return CGFloat(0.8) / CGFloat(dataPoints.count)
    }
    
    var barCornerRadius : CGFloat {
        return CGFloat(50 / dataPoints.count)
    }
}


extension UIView {
    @discardableResult
    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }

    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
}
//
class ChatBarView : UIView{
let labelFont = UIFont(name:"Raleway-Thin", size:8.0)
var padding = CGFloat(0)
var barWidth = CGFloat(27)
var dataLabel = UILabel()
var legendLabel = UILabel()
var legendLabelWidth = CGFloat(50)
var labelHeight = CGFloat(27)

    
 convenience init() {
    self.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
}


override init(frame: CGRect) {
    super.init(frame: frame)

    self.backgroundColor = UIColor.hexStringToUIColor(hex: "#8E8E8E")

    // setting up data Label
    dataLabel.frame = CGRect(x: 0, y: 0, width: barWidth, height: labelHeight)
        //CGRectMake(0, 0, barWidth, labelHeight)
    dataLabel.textAlignment = NSTextAlignment.center
    dataLabel.textColor = UIColor.white
    dataLabel.font = labelFont
    self.addSubview(dataLabel)

    // setting up legend Label
    legendLabel.frame = CGRect(x: 0, y: self.bounds.height, width: legendLabelWidth, height: labelHeight)
        //CGRectMake(0, self.bounds.height, legendLabelWidth, labelHeight)
    legendLabel.textAlignment = NSTextAlignment.center
    legendLabel.textColor = UIColor.black
    legendLabel.font = labelFont
    self.addSubview(legendLabel)
}

required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}

override func layoutSubviews() {
    let xOffset = (self.barWidth - self.legendLabelWidth) / 2
    let yOffset:CGFloat = self.bounds.height
    let width = self.legendLabelWidth
    let height = self.labelHeight

    self.legendLabel.frame = CGRect(x: xOffset, y: yOffset, width: width, height: height)
       // CGRectMake(xOffset, yOffset, width, height)
}
}



class ToolTip: UILabel {
    var roundRect:CGRect!
    override func drawText(in rect: CGRect) {
        super.drawText(in: roundRect)
    }
    override func draw(_ rect: CGRect) {
        roundRect = CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height * 4 / 5)
        let roundRectBez = UIBezierPath(roundedRect: roundRect, cornerRadius: 10.0)
        let triangleBez = UIBezierPath()
        triangleBez.move(to: CGPoint(x: roundRect.minX + roundRect.width / 2.5, y:roundRect.maxY))
        triangleBez.addLine(to: CGPoint(x:rect.midX,y:rect.maxY))
        triangleBez.addLine(to: CGPoint(x: roundRect.maxX - roundRect.width / 2.5, y:roundRect.maxY))
        triangleBez.close()
        roundRectBez.append(triangleBez)
        let bez = roundRectBez
        UIColor.lightGray.setFill()
        bez.fill()
        super.draw(rect)
    }
}


