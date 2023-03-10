//
//  HelpViewController.swift
//  Peppea
//
//  Created by EWW074 on 22/01/20.
//  Copyright © 2020 Mayur iMac. All rights reserved.
//

import UIKit

class HelpViewController: BaseViewController, UITextViewDelegate {

    // MARK: - Outlets
    
    @IBOutlet weak var txtSubject: CustomViewOutlinedTxtField!
    @IBOutlet weak var btnSubmit: ThemePrimaryButton!
    @IBOutlet weak var txtView: CustomViewOutlinedTxtView!
    @IBOutlet weak var btnViewTicket: ThemePrimaryButton!
    
//    @IBOutlet weak var txtSubject: UITextField!
//    @IBOutlet weak var txtView: UITextView!
//
    // MARK: - Variable Declaration
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation(.normal(title: "Support".localized, leftItem: .back, hasNotification: false))
        self.setLocalization()
    }
    
    func setLocalization(){
        btnSubmit.setTitle("Submit".localized, for: .normal)
        btnViewTicket.setTitle("View Ticket".localized, for: .normal)
        self.txtSubject.textField.placeholder = "Subject".localized
        self.txtSubject.textField.label.text = "Subject".localized
        self.txtView.textArea.placeholder = "Describe your issue".localized
        self.txtView.textArea.label.text = "Describe your issue".localized
    }
    
    // MARK: - Actions
    @IBAction func btnDoneAction(_ sender: UIButton) {
        guard validations() else { return }
        webserviceForGenerateTicket()
    }
    
    @IBAction func btnViewTicketAction(_ sender: UIButton) {
        
        guard let next = self.storyboard?.instantiateViewController(withIdentifier: "TicketsViewController") else {
            return
        }
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    // MARK: - Custom Methods
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Describe your issue".localized
            textView.textColor = UIColor.lightGray
        }
    }
    
    func validation() -> (status: Bool, message: String) {
        
        if txtSubject.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            return (false, "Please enter subject".localized)
        }
        else if txtView.textArea.textView.text.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            return (false, "Please enter description".localized)
        }
        else if txtView.textArea.textView.text == "Description" {
            return (false, "Please enter description".localized)
        }
        
        return (true, "")
    }
    
    func validations() -> (Bool) {
        
        let subjectValidation = InputValidation.nonEmpty.isValid(input: txtSubject.textField.unwrappedText, field: "subject".localized)
        
        let descriptionValidation = InputValidation.nonEmpty.isValid(input: txtView.textArea.textView.unwrappedText, field: "description".localized)
        
        txtSubject.textField.leadingAssistiveLabel.text = subjectValidation.error
        txtSubject.textField.setOutlineColor(subjectValidation.isValid ? .themeTextFieldDefaultBorderColor : .red, for: .normal)
        
        txtView.textArea.leadingAssistiveLabel.text = descriptionValidation.error
        txtView.textArea.setOutlineColor(descriptionValidation.isValid ? .themeTextFieldDefaultBorderColor : .red, for: .normal)
       
        if subjectValidation.isValid && descriptionValidation.isValid {
            return true
        }else{
            return false
        }

        
    }
    
    func webserviceForGenerateTicket() {
        
        let model = GenerateTicketModel()
        model.user_id = Singleton.shared.driverId
        model.ticket_title = txtSubject.textField.text ?? ""
        model.description = txtView.textArea.textView.text ?? ""
        Loader.showHUD(with: view)
        WebServiceCalls.GenerateTicketService(param: model) { (response, status) in
            Loader.hideHUD()
            print(response)
            if status {
                self.txtSubject.textField.text = ""
                self.txtView.textArea.textView.text = ""
                UtilityClass.showAlert(message: response.dictionary?["message"]?.string ?? "Your ticket is generated successfully. We will contact to you soon.".localized)
            } else {
                UtilityClass.showAlert(message: response.dictionary?["message"]?.string ?? "Something went wrong".localized)
            }
        }
    }
}
