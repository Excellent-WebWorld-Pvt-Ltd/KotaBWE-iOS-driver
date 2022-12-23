//
//  ThemeTouchableView.swift
//  DPS
//
//  Created by Gaurang on 27/09/21.
//  Copyright © 2021 Mayur iMac. All rights reserved.
//

import Foundation
import UIKit

class ThemeTouchableView: UIControl {

    private var didTapped: (() -> Void)?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setViews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setViews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

    }

    func setViews() {
        isUserInteractionEnabled = true
    }
    
    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        subview.isUserInteractionEnabled = false
    }

    func setOnClickListener(_ action: @escaping () -> Void) {
        self.didTapped = action
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        self.alpha = 0.5
        UISelectionFeedbackGenerator().selectionChanged()
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        self.alpha = 1
        UISelectionFeedbackGenerator().selectionChanged()
        self.didTapped?()
    }

    override func cancelTracking(with event: UIEvent?) {
        super.cancelTracking(with: event)
        self.alpha = 1
        UISelectionFeedbackGenerator().selectionChanged()
    }
}

class ClosureSleeve {
    let closure: () -> Void

    init (_ closure: @escaping () -> Void) {
        self.closure = closure
    }

    @objc func viewTapped(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            gesture.view?.alpha = 0.5
        case .ended:
            gesture.view?.alpha = 1
            self.closure()
        default:
            break
        }
    }
}


extension UIView {

    func addTouchGesture(_ closure: @escaping () -> Void) {
        self.isUserInteractionEnabled = true
        let sleeve = ClosureSleeve(closure)
        let tapGesture = UILongPressGestureRecognizer(target: sleeve, action: #selector(ClosureSleeve.viewTapped(_:)))
        tapGesture.minimumPressDuration = 0
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
        objc_setAssociatedObject(self, String(ObjectIdentifier(self).hashValue) + "Gesture", sleeve,
                             objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}
