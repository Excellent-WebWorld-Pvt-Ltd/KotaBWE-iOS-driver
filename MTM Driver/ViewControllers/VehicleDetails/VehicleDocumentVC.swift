//
//  VehicleDocumentVC.swift
//  MTM Driver
//
//  Created by Gaurang on 23/11/22.
//  Copyright © 2022 baps. All rights reserved.
//

import UIKit
import SafariServices

class VehicleDocumentVC: BaseViewController, UIViewControllerTransitioningDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitButton: ThemePrimaryButton!
    
    // MARK: - Variables
    var isFromSettings = false
    private let sections = DocSection.all
    private lazy var registerParameters = RegistrationParameter.shared
    private lazy var sessionParameter = VehicleDocRequestModel()
    private var uploadingDoc: VehicleDoc?

    // MARK: - UI methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFromSettings {
            if let model = SessionManager.shared.userProfile?.responseObject.driverDocs  {
                sessionParameter.set(driverDoc: model)
            } else {
                self.goBack()
                return
            }
        }
        setupUI()
    }
    
    private func setupUI() {
        self.setupNavigation(.normal(title: "Vehicle Document".localized, leftItem: .back))
        tableView.contentInset.top = 24
        tableView.registerNibCell(type: .vehicleDoc)
        let buttonTitle = isFromSettings ? "Save".localized : "Submit".localized
        submitButton.setTitle(buttonTitle, for: .normal)
    }
    
    // MARK: - Actions
    @IBAction func submitTapped() {
        guard uploadingDoc == nil else {
            UtilityClass.showAlert(message: "Document getting uploaded, please wait till finish the process".localized)
            return
        }
        guard validateInputs() else {
            return
        }
        if isFromSettings {
            sendUpdateRequest()
        } else {
            sendRegistrationRequest()
        }
    }
    
    // MARK: - Other methods
    private func getIndexPath(for type: VehicleDoc) -> IndexPath? {
        for (section, value) in self.sections.enumerated() {
            if let index = value.types.firstIndex(where: { $0 == type }) {
                let indexPath = IndexPath(row: index, section: section)
                return indexPath
            }
        }
        return nil
    }
    
    private func refreshDocument(for type: VehicleDoc) {
        guard let indexPath = getIndexPath(for: type) else {
            return
        }
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    private func setValueForRegistration(cell: VehicleDocTableViewCell,
                                         type: VehicleDoc,
                                         indexPath: IndexPath) {
        let info = self.registerParameters
        let isUploaded = info.getDocUrl(type, side: true).isNotEmpty
        let expiryDate = info.getDocExpiryDate(type)
        let textFieldValue = ""
        var uploadStatus: FileUploadStatus = isUploaded ? .uploaded : .notUploaded
        if self.uploadingDoc == type {
            uploadStatus = .uploading
        }
        cell.configure(type: type,
                       uploadStatus: uploadStatus,
                       expiryDate: expiryDate,
                       textFieldValue: textFieldValue,
                       indexPath: indexPath,
                       delegate: self)
    }
    
    private func setValueForSettings(cell: VehicleDocTableViewCell,
                                     type: VehicleDoc,
                                     indexPath: IndexPath) {
        let info = self.sessionParameter
        let isUploaded = info.getDocUrl(type, side: true).isNotEmpty
        let expiryDate = info.getDocExpiryDate(type)
        let textFieldValue = ""
        var uploadStatus: FileUploadStatus = isUploaded ? .uploaded : .notUploaded
        if self.uploadingDoc == type {
            uploadStatus = .uploading
        }
        cell.configure(type: type,
                       uploadStatus: uploadStatus,
                       expiryDate: expiryDate,
                       textFieldValue: textFieldValue,
                       indexPath: indexPath,
                       delegate: self)
    }
    
    private var documentPicker: DocumentPickerController?
    
    private func openDocumentPicker(for type: VehicleDoc, side:Bool) {
        documentPicker = DocumentPickerController(from: self,
                                 allowEditing: false,
                                 fileType: DocumentPickerFileType.allCases) { [unowned self] data in
            self.uploadDocument(data, type: type,side:side)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.documentPicker = nil
            })
        }
        documentPicker?.present(from: self.view)
    }
    
    private func uploadDocument(_ data: Any, type: VehicleDoc,side: Bool) {
        self.uploadingDoc = type
        self.refreshDocument(for: type)
        WebService.shared.uploadDocument(data) { url in
            self.uploadingDoc = nil
            if let url = url {
                if self.isFromSettings {
                    self.sessionParameter.setDocURL(url: url, for: type, side: side)
                } else {
                    self.registerParameters.setDocURL(url: url, for: type, side: side)
                    self.saveRegistrationProcess()
                }
            }
            self.refreshDocument(for: type)
        }
    }
    
    private func openDatePicker(for type: VehicleDoc) {
        if isFromSettings {
            let dateString = self.sessionParameter.getDocExpiryDate(type)
            let date = dateString.getDate(format: .digitDate)
            ThemeDatePickerViewController.open(from: self, title: type.rawValue, type: .expiryDate, selectedDate: date) { [unowned self] date in
                self.sessionParameter.setExpiry(date: date.getDateString(format: .digitDate), for: type)
                self.refreshDocument(for: type)
            }
        } else {
            let dateString = self.registerParameters.getDocExpiryDate(type)
            let date = dateString.getDate(format: .digitDate)
            ThemeDatePickerViewController.open(from: self, title: type.rawValue, type: .expiryDate, selectedDate: date) { [unowned self] date in
                self.registerParameters.setExpiry(date: date.getDateString(format: .digitDate), for: type)
                self.refreshDocument(for: type)
                self.saveRegistrationProcess()
            }
        }
    }
    
    private func openDocumentPreview(for type: VehicleDoc,side:Bool) {
        var urlString: String = ""
        if isFromSettings {
            urlString = sessionParameter.getDocUrl(type, side: side)
        } else {
            urlString = registerParameters.getDocUrl(type, side: side)
        }
        guard let url = URL(serverPath: urlString),
        UIApplication.shared.canOpenURL(url) else {
            return
        }
        let controller = SFSafariViewController(url: url)
        controller.modalPresentationStyle = .formSheet
        self.present(controller, animated: true, completion: nil)
    }
    
    private func saveRegistrationProcess() {
        guard isFromSettings == false else {
            return
        }
        SessionManager.shared.registrationParameter = registerParameters
    }
    
    private func validateInputs() -> Bool {
        if isFromSettings {
            return sessionParameter.isValidDocuments()
        } else {
            return registerParameters.isValidDocuments()
        }
    }
}

// MARK: - TableView methods
extension VehicleDocumentVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].types.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = sections[indexPath.section].types[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellType.vehicleDoc.cellId, for: indexPath) as! VehicleDocTableViewCell
        if isFromSettings {
            cell.isFromRegister = false
            cell.docData = self.sessionParameter
            setValueForSettings(cell: cell, type: type, indexPath: indexPath)
        } else {
            cell.isFromRegister = true
            setValueForRegistration(cell: cell, type: type, indexPath: indexPath)
        }
        return cell
    }
}

// MARK: - Vehicle doc delegate
extension VehicleDocumentVC: VehicleDocCellDelegate {   
    func vehicleDoc(viewDocumentOf type: VehicleDoc,side: Bool) {
        self.openDocumentPreview(for: type, side: side)
    }
    
    func vehicleDoc(documentUploadRequestAt indexPath: IndexPath, for type: VehicleDoc,side: Bool) {
        self.openDocumentPicker(for: type, side:side)
    }
    
    func vehicleDoc(didTapOnExpiryButtonAt indexPath: IndexPath, title: String, for type: VehicleDoc) {
        self.openDatePicker(for: type)
    }
    
    func vehicleDoc(didChangeTextFieldValueAt indexPath: IndexPath, value: String, for type: VehicleDoc) {
//        guard type == .nationalId else {
//            return
//        }
//        if isFromSettings {
//            self.sessionParameter.national_id_number = value
//        } else {
//            self.registerParameters.national_id_number = value
//            self.saveRegistrationProcess()
//        }
    }
}

// MARK: - Webservices
extension VehicleDocumentVC {
 
    private func sendRegistrationRequest(){
        registerParameters.driver_role = "Driver"
        registerParameters.lat = LocationManager.shared.latitude?.toString() ?? ""
        registerParameters.lng = LocationManager.shared.longitude?.toString() ?? ""
        registerParameters.device_token = SessionManager.shared.fcmToken ?? ""
        let parameter = try! registerParameters.asDictionary()
        print(parameter)
        let image = RegistrationImageParameter.shared.profileImage
        Loader.showHUD(with: view)
        WebService.shared.postDataWithImage(api: .register, parameter: parameter as [String : AnyObject], image: image, imageParamName: "profile_image"){ json,status in
            Loader.hideHUD()
            if status{
                AlertMessage.showMessageForSuccess(json["message"].arrayValue.first?.stringValue ?? json["message"].stringValue)
                SessionManager.shared.saveSession(json: json)
            }else{
                AlertMessage.showMessageForError(json["message"].array?.first?.stringValue ?? json["message"].stringValue)
            }
        }
    }
    
    private func sendUpdateRequest() {
        Loader.showHUD(with: view)
        WebServiceCalls.updateDocuments(requestModel: sessionParameter) { response, status in
            Loader.hideHUD()
            if status {
                print(response)
                let loginModelDetails = LoginModel.init(fromJson: response)
                SessionManager.shared.userProfile = loginModelDetails
                AlertMessage.showMessageForSuccess(loginModelDetails.message)
                NotificationCenter.postCustom(.updateOnlineStatus(false))
                self.navigationController?.popViewController(animated: true)
            } else {
                AlertMessage.showMessageForError(response["message"].arrayValue.first?.stringValue ?? response["message"].stringValue)
            }
        }
    }
}

// MARK: - Vehicle doc section
extension VehicleDocumentVC {
    struct DocSection {
        let title: String
        let types: [VehicleDoc]
        
        static var all: [DocSection] = [
            .init(title: "Driver Details", types: [
//                .nationalId,
                .driverLicense,
                //.drivrPsvLicense,
                .drivrCriminalRecord,
                .drivrResidenceCertificate,
               // .goodConductCerti
            ]),
            .init(title: "Vehicle Details", types: [
                //.vehiclePsvLicense,
                //.vehicleLogbook,
                //.ntsaInspectionCert,
                //.psvComprehensiveInsurance
                .rentalLicense,
                .booklet,
                .civilLiabilityInsurance,
                .biFrontAndBack
            ])
        ]
    }
}
