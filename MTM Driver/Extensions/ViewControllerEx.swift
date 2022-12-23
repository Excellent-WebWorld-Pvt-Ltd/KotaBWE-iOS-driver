//
//  ViewControllerEx.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 14/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit
import SafariServices

extension UIViewController {
    
    
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboards))

        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboards()
    {
        view.endEditing(true)
    }

    

    func isModal() -> Bool {
        if (presentingViewController != nil) {
            return true
        }
        if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        }
        if (tabBarController?.presentingViewController is UITabBarController) {
            return true
        }
        return false
    }
    
    //-------------------------------------
    // MARK:- identifier Var for VC
    //-------------------------------------
    
    static var identifier: String {
        return String(describing: self)
    }
    
    //-------------------------------------
    // MARK:- Instantiate VC by Storyboard Type
    //-------------------------------------
    
    class func viewControllerInstance<T: UIViewController>(storyBoard type : AppStoryboards) -> T {
        return UIStoryboard(name: type.rawValue, bundle: nil).instantiateViewController(withIdentifier: T.identifier) as! T
    }
    
    func hideShowViews(hide : Bool, views: UIView...){
        for view in views{
            if view.isHidden != hide{
                view.isHidden = hide
            }
        }
    }

    func setCardIcon(str: String) -> String {
        //        visa , mastercard , amex , diners , discover , jcb , other
        var CardIcon = String()

        switch str {
        case "visa":
            CardIcon = "Visa"
            return CardIcon
        case "mastercard":
            CardIcon = "MasterCard"
            return CardIcon
        case "amex":
            CardIcon = "Amex"
            return CardIcon
        case "diners":
            CardIcon = "Diners Club"
            return CardIcon
        case "discover":
            CardIcon = "Discover"
            return CardIcon
        case "jcb":
            CardIcon = "JCB"
            return CardIcon
        case "iconCashBlack":
            CardIcon = "iconCashBlack"
            return CardIcon
        case "iconWalletBlack":
            CardIcon = "iconWalletBlack"
            return CardIcon
        case "iconPlusBlack":
            CardIcon = "iconPlusBlack"
            return CardIcon
        case "other":
            CardIcon = "iconDummyCard"
            return CardIcon
        default:
            return ""
        }
    }
   
    func setAttributedTitle(title: String){
        self.navigationController?.isNavigationBarHidden = false
        let attributes = [ NSAttributedString.Key.foregroundColor: UIColor(custom: .textWhite) as Any ,
                           .font: UIFont.semiBold(ofSize: 18) as Any ]
        let navLabel = UILabel()
        let navTitle = NSMutableAttributedString(string: title, attributes: attributes)
        
        navLabel.attributedText = navTitle
        self.navigationItem.titleView = nil
        self.navigationItem.titleView = navLabel

        setupNavigationBarColor(self.navigationController)
    }
    
    func setTitleImage(){
        self.navigationController?.isNavigationBarHidden = false
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 74, height: 33))
        let titleImageView = UIImageView(image: UIImage(named: HomeIcons.title))
        titleImageView.frame = titleView.frame
        titleView.addSubview(titleImageView)
        navigationItem.titleView = titleView
        
    }
    func setMenuIcon() {
        self.navigationController?.isNavigationBarHidden = false

        let leftNavBarButton = UIBarButtonItem(image: UIImage(named: HomeIcons.menu), style: .plain, target: self, action: #selector(self.menuButtonDidClicked))
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        self.navigationController?.navigationBar.tintColor = UIColor(custom: .textWhite)
    }
     
    @objc func menuButtonDidClicked(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
    
    func setBackIcon(){
        self.navigationController?.isNavigationBarHidden = false

        let backImage = UIImage(named: "iconBack")
        self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationController?.navigationBar.backItem?.title = " "
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -200, vertical: 0), for:UIBarMetrics.default)
        self.navigationController?.navigationItem.backBarButtonItem?.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -200, vertical: 0), for:UIBarMetrics.default)
    }

    func addRightNavButton(image name: String, selector: Selector){
        self.navigationController?.isNavigationBarHidden = false
        let rightNavBarButton = UIBarButtonItem(image: UIImage(named: name), style: .plain, target: self, action: selector)
        if self.navigationItem.rightBarButtonItems != nil{
            self.navigationItem.rightBarButtonItems!.insert(rightNavBarButton, at: 0)
        }else{
            self.navigationItem.rightBarButtonItems = [rightNavBarButton]
        }
    }
    
    func setTransparentNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    func showNavigation() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func setupNavigationBarColor(_ navigationController: UINavigationController?) {
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 3.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.5
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    /// Remove all data from **UserDefaults**
    func resetUserDefaults() {
        
        let userDefaults = UserDefaults.standard
        let dict = userDefaults.dictionaryRepresentation() as NSDictionary
        
        for key in dict.allKeys {
            
            if (key as! String) != "Token" {
                userDefaults.removeObject(forKey: key as! String)
                print("The keys are \(key)")
            }
        }
        userDefaults.synchronize()
    }
    
    func openWebURL(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        let controller = SFSafariViewController(url: url)
        self.present(controller, animated: true, completion: nil)
    }
    
}


extension UIResponder {
    public var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}


func changeFormat(strDate: String, isBirthDate: Bool) -> String {
    
    let apiFormat = "yyyy-MM-dd"
    
    var dateFormat = ""
    if isBirthDate {
        dateFormat = "dd-MM-yyyy"
    } else {
        dateFormat = "dd/MM/yy"
    }
   
    
    
    let datePickerView = UIDatePicker()
    datePickerView.datePickerMode = .date
    datePickerView.locale = .current
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = apiFormat
    let givenDate = dateFormatter.date(from: strDate)
    
    let dateFormatter2 = DateFormatter()
    dateFormatter2.dateFormat = dateFormat
    let givenDateString = dateFormatter2.string(from: givenDate ?? Date())
    
    return givenDateString
}

extension UIViewController {
    
    func navigationViewController(contains vc: UIViewController.Type) -> Bool {
        let viewCtrs = navigationController?.viewControllers ?? []
        return viewCtrs.contains(where: {$0.isKind(of: vc)})
    }
    
}
