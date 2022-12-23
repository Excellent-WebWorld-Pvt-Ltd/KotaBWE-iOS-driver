//
//  BottomSheetViewController.swift
//  DPS
//
//  Created by Gaurang on 29/09/21.
//  Copyright © 2021 Mayur iMac. All rights reserved.
//

import UIKit

enum BottomSheetType {
    case addMoney
}

class BottomSheetViewController: UIViewController {

    @IBOutlet weak var subTitle: ThemeLabel!
    @IBOutlet weak var gradientContentView: UIView!
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: ThemeLabel!
    @IBOutlet weak var mainBottomConstraint: NSLayoutConstraint!
    

    var mainContent: UIView?
    var titleText: String?
    var subtitle : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let roundedView = contentView.superview {
            roundedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            roundedView.layer.cornerRadius = 15
        }
        subTitle.isHidden = subtitle != "" ? false : true
        subTitle.frame.size.height = subTitle.text != "" ? subTitle.frame.size.height : 0
        subTitle.text = subtitle
        titleLabel.text = titleText
        setContent()
        setupSwipeDownGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let height = view.bounds.height + gradientContentView.bounds.height
        self.gradientContentView.transform = .init(translationX: 0, y: height)
        UIView.animate(withDuration: 0.5) {
            self.gradientContentView.transform = .identity
        }
    }

    @IBAction func closeButtonTapped(_ sender: UIButton) {
        hide()
    }

    func hide() {
        let height = view.bounds.height + gradientContentView.bounds.height
        UIView.animate(withDuration: 0.5) {
            self.gradientContentView.transform = .init(translationX: 0, y:  height)
        } completion: { _ in
            self.dismiss(animated: false)
        }
    }

    func setContent() {
        guard let view = mainContent else {
            return
        }
        contentView.addSubview(view)
        view.setAllSideContraints(.zero)
        view.layoutSubviews()

    }
    
    lazy var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
    var originalPosition: CGPoint?
    var currentPositionTouched: CGPoint?
    
    private func setupSwipeDownGesture() {
        gradientContentView.addGestureRecognizer(panGestureRecognizer)
    }


    @objc func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
      let translation = panGesture.translation(in: gradientContentView)
      if panGesture.state == .began {
        originalPosition = gradientContentView.center
        currentPositionTouched = panGesture.location(in: gradientContentView)
      } else if panGesture.state == .changed {
          guard translation.y > 0 else {
              return
          }
          gradientContentView.transform = CGAffineTransform.init(translationX: 0, y: translation.y)
      } else if panGesture.state == .ended {
        let velocity = panGesture.velocity(in: gradientContentView)
          if velocity.y >= 500 || translation.y > gradientContentView.frame.height / 2 {
          UIView.animate(withDuration: 0.2
            , animations: {
              self.gradientContentView.transform = CGAffineTransform.init(translationX: 0, y: self.gradientContentView.frame.height)
            }, completion: { (isCompleted) in
              if isCompleted {
                self.dismiss(animated: true, completion: nil)
              }
          })
        } else {
          UIView.animate(withDuration: 0.2, animations: {
              self.gradientContentView.transform = .identity
          })
        }
      }
    }
}
