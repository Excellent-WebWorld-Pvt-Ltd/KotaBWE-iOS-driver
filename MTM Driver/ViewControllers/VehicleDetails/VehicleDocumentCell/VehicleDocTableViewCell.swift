//
//  VehicleDocTableViewCell.swift
//  MTM Driver
//
//  Created by Gaurang on 23/11/22.
//  Copyright © 2022 baps. All rights reserved.
//

import UIKit

enum VehicleDoc: String {
    case nationalId = "National Id Card"
    case driverLicense = "Driver's License"
    case drivrPsvLicense = "Driver PSV License"
    case vehiclePsvLicense = "Vehicle PSV License"
    case goodConductCerti = "Good Conduct Certificate / Police Clearance"
    case vehicleLogbook = "Vehicle Logbook"
    case ntsaInspectionCert = "NTSA Inspection Certificate"
    case psvComprehensiveInsurance = "PSV Comprehensive Insurance"
    
    var hasExpiryDate: Bool {
        switch self {
        case .driverLicense,
                .drivrPsvLicense,
                .vehiclePsvLicense,
                .ntsaInspectionCert,
                .psvComprehensiveInsurance:
            return true
        default:
            return false
        }
    }
    
    var textFieldPlaceholder: String? {
        if self == .nationalId {
            return "Enter ID card number"
        } else {
            return nil
        }
    }
}

protocol VehicleDocCellDelegate {
    func vehicleDoc(documentUploadRequestAt indexPath: IndexPath, for type: VehicleDoc)
    func vehicleDoc(viewDocumentOf type: VehicleDoc)
    func vehicleDoc(didTapOnExpiryButtonAt indexPath: IndexPath, title: String, for type: VehicleDoc)
    func vehicleDoc(didChangeTextFieldValueAt indexPath: IndexPath, value: String, for type: VehicleDoc)
}

enum FileUploadStatus {
    case uploaded, notUploaded, uploading
}

class VehicleDocTableViewCell: UITableViewCell {
    
    @IBOutlet weak var datePickerButton: ThemePlainButton!
    @IBOutlet weak var expiredDateLabel: ThemeLabel!
    @IBOutlet weak var expiredDateStack: UIStackView!
    @IBOutlet weak var textField: ThemeUnderLineTextField!
    @IBOutlet weak var attachmentLabel: UILabel!
    @IBOutlet weak var attachFileView: ThemeTouchableView!
    @IBOutlet weak var attachmentStack: UIStackView!
    @IBOutlet weak var uploadingLabel: UILabel!
    @IBOutlet weak var titleLabel: ThemeLabel!
    @IBOutlet weak var editButton: UIButton!
    
    var type: VehicleDoc = .vehicleLogbook
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    var uploadStatus: FileUploadStatus = .notUploaded
    var expiryDate: String = ""
    var textFieldValue: String = ""
    var delegate: VehicleDocCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        attachFileView.setOnClickListener { [unowned self] in
            if uploadStatus == .uploaded {
                self.delegate?.vehicleDoc(viewDocumentOf: type)
            } else {
                self.delegate?.vehicleDoc(documentUploadRequestAt: self.indexPath,
                                          for: self.type)
            }
        }
    }
    
    func configure(type: VehicleDoc,
                   uploadStatus: FileUploadStatus,
                   expiryDate: String,
                   textFieldValue: String,
                   indexPath: IndexPath,
                   delegate: VehicleDocCellDelegate) {
        self.type = type
        self.uploadStatus = uploadStatus
        self.expiryDate = expiryDate
        self.textFieldValue = textFieldValue
        self.indexPath = indexPath
        self.delegate = delegate
        refreshValues()
    }
    
    func refreshValues() {
        titleLabel.text = type.rawValue
        updateAttachUI()
        updateExpiryDateUI()
        updateTextFieldUI()
    }
    
    func updateAttachUI() {
        let title = uploadStatus == .uploaded ? "View document" : "Attach document"
        attachmentLabel.text = title
        let attr: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .font: FontBook.regular.font(ofSize: 15),
            .foregroundColor: uploadStatus == .uploaded ? UIColor.themeFailed: UIColor.black
        ]
        attachmentLabel.attributedText = NSAttributedString(string: title, attributes: attr)
        editButton.isHidden = uploadStatus != .uploaded
        attachmentStack.isHidden = uploadStatus == .uploading
        uploadingLabel.isHidden = uploadStatus != .uploading
    }
    
    func updateExpiryDateUI() {
        expiredDateStack.isHidden = !type.hasExpiryDate
        let title = expiryDate.isEmpty ? "Select expiry date" : "Expiry Date: " + expiryDate
        self.datePickerButton.setTitle(title, for: .normal)
        let color: UIColor = expiryDate.isEmpty ? .systemGray : .black
        self.datePickerButton.setTitleColor(color, for: .normal)
        
        if let date = expiryDate.getDate(format: .digitDate),
           let currentDate = Date().getDateString(format: .digitDate).getDate(format: .digitDate),
            currentDate > date {
            expiredDateLabel.isHidden = false
        } else {
            expiredDateLabel.isHidden = true
        }
    }
    
    func updateTextFieldUI() {
        textField.text = textFieldValue
        textField.isHidden = type.textFieldPlaceholder == nil
        textField.placeholder = type.textFieldPlaceholder
    }
    
    @IBAction func datePickerTapped(_ sender: UIButton) {
        delegate?.vehicleDoc(didTapOnExpiryButtonAt: indexPath, title: expiryDate, for: type)
    }
    
    @IBAction func editTapped() {
        self.delegate?.vehicleDoc(documentUploadRequestAt: self.indexPath,
                                  for: self.type)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension VehicleDocTableViewCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.vehicleDoc(didChangeTextFieldValueAt: indexPath,
                             value: textField.unwrappedText,
                             for: type)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
