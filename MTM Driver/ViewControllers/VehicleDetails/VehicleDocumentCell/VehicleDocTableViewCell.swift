//
//  VehicleDocTableViewCell.swift
//  MTM Driver
//
//  Created by Gaurang on 23/11/22.
//  Copyright © 2022 baps. All rights reserved.
//

import UIKit

enum VehicleDoc: String {
    case driverLicense = "Driving license(front and back)"
    case drivrCriminalRecord = "Criminal record"
    case drivrResidenceCertificate = "Residence certificate"
    case rentalLicense = "Rental license"
    case booklet = "Booklet"
    case civilLiabilityInsurance = "Civil liability insurance"
    case biFrontAndBack = "BI (front and back)"

//    case drivrPsvLicense = "Driver PSV License"
//    case vehiclePsvLicense = "Vehicle PSV License"
//    case goodConductCerti = "Good Conduct Certificate / Police Clearance"
//    case vehicleLogbook = "Vehicle Logbook"
//    case ntsaInspectionCert = "NTSA Inspection Certificate"
//    case psvComprehensiveInsurance = "PSV Comprehensive Insurance"
    
    var hasExpiryDate: Bool {
        switch self {
        case    .driverLicense,
                .rentalLicense,
                .civilLiabilityInsurance,
                .biFrontAndBack:
            return true
        default:
            return false
        }
    }
}

protocol VehicleDocCellDelegate {
    func vehicleDoc(documentUploadRequestAt indexPath: IndexPath, for type: VehicleDoc, side: Bool)
    func vehicleDoc(viewDocumentOf type: VehicleDoc,side:Bool)
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
    
    @IBOutlet weak var lblattachtitleFirst: UILabel!
    
    @IBOutlet weak var lblattachtitleSecond: UILabel!
    
    @IBOutlet weak var editButtonSecond: UIButton!
    
    
    
  //  @IBOutlet weak var textField: ThemeUnderLineTextField!
    
    @IBOutlet weak var textField: CustomViewOutlinedTxtField!
    
    @IBOutlet weak var stackViewSecond: UIStackView!
    
    @IBOutlet weak var attachmentLabel: UILabel!
    @IBOutlet weak var attachFileView: ThemeTouchableView!
    
    @IBOutlet weak var attachFileViewSecond: ThemeTouchableView!
    @IBOutlet weak var attachmentStack: UIStackView!
    @IBOutlet weak var uploadingLabel: UILabel!
    @IBOutlet weak var titleLabel: ThemeLabel!
    @IBOutlet weak var editButton: UIButton!
    
    var type: VehicleDoc = .driverLicense
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    var uploadStatus: FileUploadStatus = .notUploaded
    var expiryDate: String = ""
    var textFieldValue: String = ""
    var delegate: VehicleDocCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        attachFileView.setOnClickListener { [unowned self] in
            if uploadStatus == .uploaded {
                self.delegate?.vehicleDoc(viewDocumentOf: type, side: true)
            } else {
                self.delegate?.vehicleDoc(documentUploadRequestAt: self.indexPath,
                                          for: self.type, side: true)
            }
        }
        attachFileViewSecond.setOnClickListener { [unowned self] in
            var status = true
            if self.type == .driverLicense{
                status = RegistrationParameter.shared.driver_licence_image_back != ""
            }else if self.type == .biFrontAndBack{
                status = RegistrationParameter.shared.bi_image_back != ""
            }
            if status {
                self.delegate?.vehicleDoc(viewDocumentOf: type, side: false)
            } else {
                self.delegate?.vehicleDoc(documentUploadRequestAt: self.indexPath,
                                          for: self.type, side: false)
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
        self.textField.textField.delegate = self
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
        let upload = RegistrationParameter.shared.getDocUrl(self.type, side: true)
        var title = upload != "" ? "View document" : "Attach Document"
        let attr: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .font: FontBook.regular.font(ofSize: 15),
            .foregroundColor: upload != "" ? UIColor.themeFailed: UIColor.black
        ]
        attachmentLabel.attributedText = NSAttributedString(string: title, attributes: attr)
        editButton.isHidden = (upload == "")
        uploadingLabel.isHidden = uploadStatus != .uploading
        editButtonSecond.isHidden = true
        if (type.rawValue == VehicleDoc.driverLicense.rawValue) || (type.rawValue == VehicleDoc.biFrontAndBack.rawValue){
            stackViewSecond.isHidden = false
            let second = (RegistrationParameter.shared.getDocUrl(self.type, side: false) != "")
            editButtonSecond.isHidden = !second
            let att2: [NSAttributedString.Key: Any] = [
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .font: FontBook.regular.font(ofSize: 15),
                .foregroundColor: second ? UIColor.themeFailed: UIColor.black
            ]
            editButtonSecond.isHidden = !second
            let titleSecond = second ? "View document" : "Attach Document(Back)"
            title = upload != "" ? "View document" : "Attach Document(Front)"
            lblattachtitleSecond.attributedText = NSAttributedString(string: titleSecond, attributes: att2)
            attachmentLabel.attributedText = NSAttributedString(string: title, attributes: attr)
        }else {
            stackViewSecond.isHidden = true
        }
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
        textField.textField.text = textFieldValue
    }
    
    @IBAction func datePickerTapped(_ sender: UIButton) {
        delegate?.vehicleDoc(didTapOnExpiryButtonAt: indexPath, title: expiryDate, for: type)
    }
    
    @IBAction func editTapped(_ sender: UIButton) {
        if uploadStatus != .uploading{
            self.delegate?.vehicleDoc(documentUploadRequestAt: self.indexPath,
                                      for: self.type, side: (sender == editButton))
        }
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
