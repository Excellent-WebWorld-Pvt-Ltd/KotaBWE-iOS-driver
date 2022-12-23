//
//  BaseViewController.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 14/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

enum LeftNavigationItem {
    case menu
    case back
    case none
}

enum NavigationType {
    case auth(title: String, contentView: UIView)
    case normal(title: String?, leftItem: LeftNavigationItem, hasNotification: Bool = false)
}


class BaseViewController: UIViewController {
    
    static var previousType = NavType.opaque

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    func setupNavigation(_ type: NavigationType) {
        switch type {
        case .auth(let title, let contentView):
            setAuthNavigation(title: title, contentView: contentView)
        case .normal(let title, let leftItem, let hasNotification):
            setTextTitle(title)
            setLeftItem(leftItem)
            if hasNotification {
                setNotificationItem()
            }
        }
    }
    
    func setNotificationItem() {
        let icon = AppImages.notification.image
        let barItem = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(notificationTapped))
        navigationItem.rightBarButtonItem = barItem
    }
    
    @objc private func notificationTapped() {
        self.push(NotificationVC())
    }

    func setAuthNavigation(title: String, contentView: UIView) {
        contentView.layoutIfNeeded()
        let backImageView = UIImageView(image: AppImages.authHeader.image)
        contentView.addSubview(backImageView)
        backImageView.setAllSideContraints(.zero)
        backImageView.contentMode = .scaleAspectFill

        let titleLabel = ThemeLabel()
        titleLabel.fontSize = 30
        titleLabel.regular = true
        titleLabel.white = true
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.setViews()
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let topSpace = (contentView.frame.height + Helper.statusBarHeight) / 2
        NSLayoutConstraint.activate(
            [titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
             titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topSpace - 30)])
        // 30 = fonts size / 2 + line

        let underLineView = UIView()
        underLineView.backgroundColor = UIColor.hexStringToUIColor(hex: "#2680EB")
        underLineView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(underLineView)
        underLineView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        underLineView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        underLineView.heightAnchor.constraint(equalToConstant: 3).isActive = true
        underLineView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        underLineView.setCornerRadius(1.5)
        navigationController?.isNavigationBarHidden = true
    }


    func setTextTitle(_ title: String?) {
        navigationItem.title = title
    }

    func setLeftItem(_ type: LeftNavigationItem) {
        switch type {
        case .menu:
            let icon = AppImages.menu.image
            let barItem = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(menuButtonTapped))
            navigationItem.leftBarButtonItem = barItem
        case .back:
            let icon = AppImages.back.image
            let barItem = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(backButtonTapped))
            navigationItem.leftBarButtonItem = barItem
        case .none:
            break
        }
    }

    var navType: NavType = .opaque {
        didSet{
         //   customizeNavBar(type: navType)
            BaseViewController.previousType = navType
            previousNavType = navType
        }
    }
    override var title: String?{
        didSet{
         //   setAttributedTitle()
        }
    }
    var previousNavType = BaseViewController.previousType
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        guard previousNavType != navType else { return }
      //  customizeNavBar(type: previousNavType)
    }


    @objc private func backButtonTapped() {
        if navigationController?.hasMoreThanOneViewControllers ?? false {
            self.goBack()
        } else {
            self.navigationController?.dismiss(animated: true)
        }
    }

    @objc private func menuButtonTapped() {
        sideMenuController?.revealMenu()
    }

}

extension BaseViewController: UIGestureRecognizerDelegate { }
