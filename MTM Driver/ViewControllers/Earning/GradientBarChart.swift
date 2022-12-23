////
////  GradientBarChart.swift
////  DSP Driver
////
////  Created by Admin on 30/11/21.
////  Copyright © 2021 baps. All rights reserved.
////
//
//import Foundation
//import UIKit
//import Charts
//
//enum GradientDirection {
//    case leftToRight
//    case rightToLeft
//    case topToBottom
//    case bottomToTop
//}
//
//class GradientBarChartRenderer: BarChartRenderer {
//    var gradientColors: [NSUIColor] = []
//    var gradientDirection: GradientDirection = .topToBottom
//
//    typealias Buffer = [CGRect]
//    fileprivate var _buffers = [Buffer]()
//
//    override func initBuffers() {
//        super.initBuffers()
//        guard let barData = dataProvider?.barData else { return _buffers.removeAll() }
//
//        if _buffers.count != barData.count {
//            while _buffers.count < barData.count {
//                _buffers.append(Buffer())
//            }
//            while _buffers.count > barData.count {
//                _buffers.removeLast()
//            }
//        }
//
//        _buffers = zip(_buffers, barData).map { buffer, set -> Buffer in
//            let set = set as! BarChartDataSetProtocol
//            let size = set.entryCount * (set.isStacked ? set.stackSize : 1)
//            return buffer.count == size
//                ? buffer
//                : Buffer(repeating: .zero, count: size)
//        }
//    }
//
//    private func prepareBuffer(dataSet: BarChartDataSetProtocol, index: Int) {
//        guard
//            let dataProvider = dataProvider,
//            let barData = dataProvider.barData
//        else { return }
//
//        let barWidthHalf = CGFloat(barData.barWidth / 2.0)
//
//        var bufferIndex = 0
//        let containsStacks = dataSet.isStacked
//
//        let isInverted = dataProvider.isInverted(axis: dataSet.axisDependency)
//        let phaseY = CGFloat(animator.phaseY)
//
//        for i in (0 ..< dataSet.entryCount).clamped(to: 0 ..< Int(ceil(Double(dataSet.entryCount) * animator.phaseX))) {
//            guard let e = dataSet.entryForIndex(i) as? BarChartDataEntry else { continue }
//
//            let x = CGFloat(e.x)
//            let left = x - barWidthHalf
//            let right = x + barWidthHalf
//
//            var y = e.y
//
//            if containsStacks, let vals = e.yValues {
//                var posY = 0.0
//                var negY = -e.negativeSum
//                var yStart = 0.0
//
//                // fill the stack
//                for value in vals {
//                    if value == 0.0 && (posY == 0.0 || negY == 0.0) {
//                        // Take care of the situation of a 0.0 value, which overlaps a non-zero bar
//                        y = value
//                        yStart = y
//                    } else if value >= 0.0 {
//                        y = posY
//                        yStart = posY + value
//                        posY = yStart
//                    } else {
//                        y = negY
//                        yStart = negY + abs(value)
//                        negY += abs(value)
//                    }
//
//                    var top = isInverted
//                        ? (y <= yStart ? CGFloat(y) : CGFloat(yStart))
//                        : (y >= yStart ? CGFloat(y) : CGFloat(yStart))
//                    var bottom = isInverted
//                        ? (y >= yStart ? CGFloat(y) : CGFloat(yStart))
//                        : (y <= yStart ? CGFloat(y) : CGFloat(yStart))
//
//                    // multiply the height of the rect with the phase
//                    top *= phaseY
//                    bottom *= phaseY
//
//                    let barRect = CGRect(x: left, y: top,
//                                         width: right - left,
//                                         height: bottom - top)
//                    _buffers[index][bufferIndex] = barRect
//                    bufferIndex += 1
//                }
//            } else {
//                var top = isInverted
//                    ? (y <= 0.0 ? CGFloat(y) : 0)
//                    : (y >= 0.0 ? CGFloat(y) : 0)
//                var bottom = isInverted
//                    ? (y >= 0.0 ? CGFloat(y) : 0)
//                    : (y <= 0.0 ? CGFloat(y) : 0)
//
//                var topOffset: CGFloat = 0.0
//                var bottomOffset: CGFloat = 0.0
//                if let offsetView = dataProvider as? BarChartView {
//                    let offsetAxis = offsetView.getAxis(dataSet.axisDependency)
//                    if y >= 0 {
//                        // situation 1
//                        if offsetAxis.axisMaximum < y {
//                            topOffset = CGFloat(y - offsetAxis.axisMaximum)
//                        }
//                        if offsetAxis.axisMinimum > 0 {
//                            bottomOffset = CGFloat(offsetAxis.axisMinimum)
//                        }
//                    }
//                    else // y < 0
//                    {
//                        // situation 2
//                        if offsetAxis.axisMaximum < 0 {
//                            topOffset = CGFloat(offsetAxis.axisMaximum * -1)
//                        }
//                        if offsetAxis.axisMinimum > y {
//                            bottomOffset = CGFloat(offsetAxis.axisMinimum - y)
//                        }
//                    }
//                    if isInverted {
//                        // situation 3 and 4
//                        // exchange topOffset/bottomOffset based on 1 and 2
//                        // see diagram above
//                        (topOffset, bottomOffset) = (bottomOffset, topOffset)
//                    }
//                }
//                // apply offset
//                top = isInverted ? top + topOffset : top - topOffset
//                bottom = isInverted ? bottom - bottomOffset : bottom + bottomOffset
//
//                // multiply the height of the rect with the phase
//                // explicitly add 0 + topOffset to indicate this is changed after adding accessibility support (#3650, #3520)
//                if top > 0 + topOffset {
//                    top *= phaseY
//                } else {
//                    bottom *= phaseY
//                }
//
//                let barRect = CGRect(x: left, y: top,
//                                     width: right - left,
//                                     height: bottom - top)
//                _buffers[index][bufferIndex] = barRect
//                bufferIndex += 1
//            }
//        }
//    }
//
//    override func drawDataSet(context: CGContext, dataSet: BarChartDataSetProtocol, index: Int) {
//        super.drawDataSet(context: context, dataSet: dataSet, index: index)
//
//        guard let dataProvider = dataProvider else { return }
//        let trans = dataProvider.getTransformer(forAxis: dataSet.axisDependency)
//
//        prepareBuffer(dataSet: dataSet, index: index)
//        trans.rectValuesToPixel(&_buffers[index])
//
//        let buffer = _buffers[index]
//        for j in buffer.indices {
//            let barRect = buffer[j]
//            drawRadianColor(context: context, rect: barRect)
//        }
//    }
//
//    func drawRadianColor(context: CGContext, rect: CGRect) {
//        if !gradientColors.isEmpty {
//            let view = NSUIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
//            gradientBackground(view: view, colors: gradientColors, direction: gradientDirection)
//            if let image = self.image(with: view)?.cgImage {
//                context.draw(image, in: rect)
//            }
//        }
//    }
//
//    func gradientBackground(view: NSUIView, colors: [NSUIColor], direction: GradientDirection) {
//        let gradient = CAGradientLayer()
//        gradient.frame = view.bounds
//        gradient.colors = colors
//
//        switch direction {
//        case .leftToRight:
//            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
//            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
//        case .rightToLeft:
//            gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
//            gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
//        case .topToBottom:
//            gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
//            gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
//        default:
//            break
//        }
//        view.layer.insertSublayer(gradient, at: 0)
//    }
//
//    func image(with view: NSUIView) -> NSUIImage? {
//        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
//        defer { UIGraphicsEndImageContext() }
//        if let context = UIGraphicsGetCurrentContext() {
//            view.layer.render(in: context)
//            let image = UIGraphicsGetImageFromCurrentImageContext()
//            return image
//        }
//        return nil
//    }
//}
