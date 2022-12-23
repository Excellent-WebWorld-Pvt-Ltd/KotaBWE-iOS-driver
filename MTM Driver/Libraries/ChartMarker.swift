//
//  ChartMarker.swift
//  DSP Driver
//
//  Created by Admin on 30/11/21.
//  Copyright © 2021 baps. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit


//class ChartMarker: MarkerView {
//    private var text = String()
//
//    private let drawAttributes: [NSAttributedString.Key: Any] = [
//        .font: UIFont.bold(ofSize: 14.0),
//        .foregroundColor: UIColor.white,
//        .backgroundColor: UIColor.black
//    ]
//
//    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
//        text = String(entry.y)
//    }
//
//    override func draw(context: CGContext, point: CGPoint) {
//        super.draw(context: context, point: point)
//
//        let sizeForDrawing = text.size(withAttributes: drawAttributes)
//        bounds.size = sizeForDrawing
//        offset = CGPoint(x: -sizeForDrawing.width / 2, y: -sizeForDrawing.height - 4)
//
//        let offset = offsetForDrawing(atPoint: point)
//        let originPoint = CGPoint(x: point.x + offset.x, y: point.y + offset.y)
//        let rectForText = CGRect(origin: originPoint, size: sizeForDrawing)
//        drawText(text: text, rect: rectForText, withAttributes: drawAttributes)
//    }
//
//    private func drawText(text: String, rect: CGRect, withAttributes attributes: [NSAttributedString.Key: Any]? = nil) {
//        let size = bounds.size
//        let centeredRect = CGRect(
//            x: rect.origin.x + (rect.size.width - size.width) / 2,
//            y: rect.origin.y + (rect.size.height - size.height) / 2,
//            width: size.width,
//            height: size.height
//        )
//        text.draw(in: centeredRect, withAttributes: attributes)
//    }
//}
//class CustomMarkerView: MarkerView {
//
//    @IBOutlet var contentView: UIView!
//    @IBOutlet weak var markerBoard: UIView!
//    @IBOutlet weak var lbRate: UILabel!
//    @IBOutlet weak var lbCountry: UILabel!
//    @IBOutlet weak var markerStick: UIView!
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        initUI()
//    }
//
//    override open func awakeFromNib() {
//            self.offset.x = -self.frame.size.width / 2.0
//            self.offset.y = -self.frame.size.height - 7.0
//        }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        initUI()
//    }
//
//    private func initUI() {
//        Bundle.main.loadNibNamed("CustomMarkerView", owner: self, options: nil)
//        addSubview(contentView)
////        markerStick.backgroundColor = .chartHightlightColour
////        markerBoard.backgroundColor = .chartHightlightColour
//       // markerBoard.layer.cornerRadius = 5
//
//        self.frame = CGRect(x: 0, y: 100, width: 79, height: 73)
//        self.offset = CGPoint(x: -(self.frame.width/2), y: -self.frame.height)
//    }
//}
