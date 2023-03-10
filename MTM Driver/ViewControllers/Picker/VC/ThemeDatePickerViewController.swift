//
//  ThemeDatePickerViewController.swift
//  MTM Driver
//
//  Created by Gaurang on 02/11/22.
//  Copyright © 2022 baps. All rights reserved.
//

import UIKit

typealias DatePickerCompletion = (_ date: Date) -> Void

enum ThemeDatePickerType {
    case birthDate
    case expiryDate
}

class ThemeDatePickerViewController: UIViewController {
    
    static func open(from viewController: UIViewController,
                     title: String,
                     type: ThemeDatePickerType,
                     selectedDate: Date?,
                     completion: DatePickerCompletion?) {
        let pickerVC: ThemeDatePickerViewController = .viewControllerInstance(storyBoard: .picker)
        pickerVC.titleText = title
        pickerVC.selectedDate = selectedDate
        pickerVC.completion = completion
        pickerVC.type = type
        viewController.present(pickerVC, animated: true)
    }
    
    @IBOutlet weak var btnCancel: ThemePrimaryButton!
    @IBOutlet weak var btnConfirm: ThemePrimaryButton!
    @IBOutlet weak var blurryView: UIVisualEffectView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleLabel: UILabel!
    
    var titleText: String?
    var type: ThemeDatePickerType = .birthDate
    var selectedDate: Date?
    var completion: DatePickerCompletion?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleText
        datePicker.date = selectedDate ?? Date()
        datePicker.datePickerMode = .date
        if type == .birthDate {
            let date = Calendar.current.date(byAdding: .year, value: -18, to: Date())
            datePicker.maximumDate = date
        } else if type == .expiryDate {
            let date = Calendar.current.date(byAdding: .day, value: 1, to: Date())
            
            datePicker.minimumDate = date
        }
        blurryView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        blurryView.layer.cornerRadius = 16
        blurryView.clipsToBounds = true
        self.localization()
    }
    
    func localization(){
        self.btnCancel.setTitle("Cancel".localized, for: .normal)
        self.btnConfirm.setTitle("Confirm".localized, for: .normal)
    }
    
    @IBAction func dismissAction() {
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelTapped() {
        self.dismissAction()
    }
    
    @IBAction func confirmTapped() {
        self.completion?(datePicker.date)
        dismissAction()
    }
}
