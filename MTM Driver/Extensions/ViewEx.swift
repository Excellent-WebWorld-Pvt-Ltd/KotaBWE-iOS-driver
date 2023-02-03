//
//  ViewEx.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 14/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import SDWebImage

extension UIView {
    //-------------------------------------
    // MARK:- Instantiate View
    //-------------------------------------
    
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    //-------------------------------------------
    // MARK:- identifier Variable for View, Cells
    //-------------------------------------------
    
    static var identifier: String{
        return String(describing: self)
    }
    
    //-------------------------------------
    // MARK:- Remove All Subviews
    //-------------------------------------
    
    func removeAllSubviews(){
        self.subviews.forEach({
            $0.removeFromSuperview()
        })
    }
    
    //-------------------------------------
    // MARK:- Add Subview with animation
    //-------------------------------------
    func customAddSubview(_ view: UIView){
        self.isHidden = false
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.autoresizingMask = [.flexibleHeight]
        self.bounds.size = view.frame.size
        view.frame = self.bounds
        
        UIView.transition(with: self,
                          duration: 0,
                          options: .curveEaseInOut,
                          animations: {
                            self.removeAllSubviews()
                            self.addSubview(view)
        }, completion: nil)
    }
    func addSubviewWithTransition(_ view: UIView, mainView: UIView){
       
        self.isHidden = false
        let xOffset: CGFloat = self.frame.minX
        
        self.autoresizingMask = [.flexibleLeftMargin,.flexibleRightMargin,.flexibleWidth, .flexibleHeight]
        view.autoresizingMask = [.flexibleLeftMargin,.flexibleRightMargin,.flexibleWidth, .flexibleHeight]
        view.bounds.size.width = self.bounds.width
        self.bounds.size.height = max(self.bounds.height, view.bounds.height)

        let tempView = UIView(frame: CGRect(x: xOffset + self.bounds.width, y: 62,
                                            width: self.bounds.width, height: view.frame.height))
        
        view.frame.origin.x = 0
        tempView.frame.origin.x = xOffset
        self.frame.origin.x = -xOffset - self.bounds.width
        tempView.addSubview(view)
        mainView.addSubview(tempView)
      
        UIView.animate(withDuration: 0.7, animations: {
          self.layoutIfNeeded()
        }) { (_) in
            tempView.removeFromSuperview()
            self.removeAllSubviews()
            self.bounds.size.height = view.bounds.height
            self.frame.origin.x = xOffset
            self.addSubview(view)
        }
        
    }
    
    func addVisualFormatConstraints(format: String, views: UIView...){
        var viewsDictionary = [String: UIView]()
        
        for (index, view) in views.enumerated(){
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        let constraint = NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary)
        addConstraints(constraint)
    }
    
    @objc func validation() -> Bool{
        /// Override this to validate View
        return true
    }
    @objc func validationWithCompletion(_ completion: @escaping ((Bool) -> ())){
        /// Override this to validate View
        completion(true)
    }
    @objc func setupTextField(){
        /// Override this to Setup TextField
    }
     public func viewContainingController()->UIViewController? {
        
        var nextResponder: UIResponder? = self
        
        repeat {
            nextResponder = nextResponder?.next
            
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            
        } while nextResponder != nil
        
        return nil
    }
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
      func parentContainerViewController()->UIViewController? {
        
        var matchController = viewContainingController()
        var parentContainerViewController : UIViewController?
        
        if var navController = matchController?.navigationController {
            
            while let parentNav = navController.navigationController {
                navController = parentNav
            }
            
            var parentController : UIViewController = navController
            
            while let parent = parentController.parent,
                (parent.isKind(of: UINavigationController.self) == false &&
                    parent.isKind(of: UITabBarController.self) == false &&
                    parent.isKind(of: UISplitViewController.self) == false) {
                        
                        parentController = parent
            }
            
            if navController == parentController {
                parentContainerViewController = navController.topViewController
            } else {
                parentContainerViewController = parentController
            }
        }
        else if let tabController = matchController?.tabBarController {
            
            if let navController = tabController.selectedViewController as? UINavigationController {
                parentContainerViewController = navController.topViewController
            } else {
                parentContainerViewController = tabController.selectedViewController
            }
        } else {
            while let parentController = matchController?.parent,
                (parentController.isKind(of: UINavigationController.self) == false &&
                    parentController.isKind(of: UITabBarController.self) == false &&
                    parentController.isKind(of: UISplitViewController.self) == false) {
                        
                        matchController = parentController
            }
            
            parentContainerViewController = matchController
        }
        
        let finalController = parentContainerViewController ?? parentContainerViewController
        
        return finalController
        
    }
    
    func startRotating(duration: Double = 2) {
        let kAnimationKey = "rotation"
        
        if self.layer.animation(forKey: kAnimationKey) == nil {
            let animate = CABasicAnimation(keyPath: "transform.rotation")
            animate.duration = duration
            animate.repeatCount = Float.infinity
            animate.fromValue = 0.0
            animate.toValue = Double.pi * 2
            self.layer.add(animate, forKey: kAnimationKey)
        }
    }
    func stopRotating() {
        let kAnimationKey = "rotation"
        
        if self.layer.animation(forKey: kAnimationKey) != nil {
            self.layer.removeAnimation(forKey: kAnimationKey)
        }
    }
    
    func hideShowViews(hide : Bool, views: [UIView]){
        for view in views{
            if view.isHidden != hide{
                view.isHidden = hide
            }
        }
    }
    

    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }

    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }

    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }

    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }

    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

extension UIView {
    
//    public var parentViewController: UIViewController? {
//        // Starts from next (As we know self is not a UIViewController).
//        var parentResponder: UIResponder? = self.next
//        while parentResponder != nil {
//            if let viewController = parentResponder as? UIViewController {
//                return viewController
//            }
//            parentResponder = parentResponder?.next
//        }
//        return nil
//    }

    func clipToCircle() {
        clipsToBounds = true
        layer.cornerRadius = bounds.width / 2
    }

    func clipToCapsule() {
        clipsToBounds = true
        self.layer.cornerRadius = self.frame.height / 2
    }

    func setAllSideContraints(_ insets: UIEdgeInsets) {
        guard let view = superview else {
            return
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top).isActive = true
        leftAnchor.constraint(equalTo: view.leftAnchor, constant: insets.left).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor, constant: insets.right).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom).isActive = true
    }

    func setAllSideContraintsFromSafeArea(_ insets: UIEdgeInsets) {
        guard let view = superview else {
            return
        }
        topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: insets.top).isActive = true
        leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: insets.left).isActive = true
        rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: insets.right).isActive = true
        bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: insets.bottom).isActive = true
    }

    func setCenterToViewContraints() {
        guard let view = superview else {
            return
        }
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

extension UIStackView {
    func removeAllArrangedSubviews() {
        for view in arrangedSubviews {
            view.removeFromSuperview()
        }
    }
}

extension UIView {

    func clipToCapsuleWithBorder(color: UIColor, width: CGFloat) {
        clipsToBounds = true
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }

    func setCornerRadius(_ radius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = radius
    }

    func setCornerRadius(to corners: CACornerMask, radius: CGFloat  ) {
        self.layer.maskedCorners = corners
        self.layer.cornerRadius = radius
    }

   
    
    func updateConstraint(attribute: NSLayoutConstraint.Attribute, constant: CGFloat) -> Void {
        if let constraint = (self.constraints.filter{$0.firstAttribute == attribute}.first) {
            constraint.constant = constant
            self.layoutIfNeeded()
        }
    }

    func getConstraint(attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        return self.constraints.first(where: {$0.firstAttribute == attribute})
    }
    
    func
    addShadow(to edges: [UIRectEdge], radius: CGFloat = 3.0, opacity: Float = 0.6, color: CGColor = UIColor.black.cgColor) {

            let fromColor = color
            let toColor = UIColor.clear.cgColor
            let viewFrame = self.frame
            for edge in edges {
                let gradientLayer = CAGradientLayer()
                gradientLayer.colors = [fromColor, toColor]
                gradientLayer.opacity = opacity

                switch edge {
                case .top:
                    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
                    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
                    gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: viewFrame.width + 40, height: radius)
                case .bottom:
                    gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
                    gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
                    gradientLayer.frame = CGRect(x: 0.0, y: viewFrame.height - radius, width: viewFrame.width, height: radius)
                case .left:
                    gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                    gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
                    gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: radius, height: viewFrame.height)
                case .right:
                    gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                    gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
                    gradientLayer.frame = CGRect(x: viewFrame.width - radius, y: 0.0, width: radius, height: viewFrame.height)
                default:
                    break
                }
                self.layer.addSublayer(gradientLayer)
            }
        }

        func removeAllShadows() {
            if let sublayers = self.layer.sublayers, !sublayers.isEmpty {
                for sublayer in sublayers {
                    sublayer.removeFromSuperlayer()
                }
            }
        }
}


