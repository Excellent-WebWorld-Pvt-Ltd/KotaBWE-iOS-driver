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
    @IBOutlet weak var txtSubject: UITextField!
    @IBOutlet weak var txtView: UITextView!
    
    // MARK: - Variable Declaration
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation(.normal(title: "Help", leftItem: .back, hasNotification: false))
    
        txtView.delegate = self
        txtView.text = "Description"
        txtView.textColor = UIColor.lightGray
    }
    
    // MARK: - Actions
    @IBAction func btnDoneAction(_ sender: UIButton) {
        if validation().status {
            webserviceForGenerateTicket()
        } else {
            UtilityClass.showAlert(message: validation().message)
        }
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
            textView.text = "Description"
            textView.textColor = UIColor.lightGray
        }
    }
    
//    func textViewDidChange(_ textView: UITextView){
//        let fixedWidth = textView.frame.size.width
//        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
//        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
//        var newFrame = textView.frame
//        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
//        textView.frame = newFrame;
//    }
    
    func validation() -> (status: Bool, message: String) {
        
        if txtSubject.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            return (false, "Please enter subject")
        }
        else if txtView.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            return (false, "Please enter description")
        }
        else if txtView.text == "Description" {
            return (false, "Please enter description")
        }
        
        return (true, "")
    }
    
    func webserviceForGenerateTicket() {
        
        let model = GenerateTicketModel()
        model.user_id = Singleton.shared.driverId
        model.ticket_title = txtSubject.text ?? ""
        model.description = txtView.text ?? ""
        Loader.showHUD(with: view)
        WebServiceCalls.GenerateTicketService(param: model) { (response, status) in
            Loader.hideHUD()
            print(response)
            if status {
                
                self.txtSubject.text = ""
                self.txtView.text = "Description"
                self.txtView.textColor = UIColor.lightGray
                
                UtilityClass.showAlert(message: response.dictionary?["message"]?.string ?? "Your ticket is generated successfully. We will contact to you soon.")
            } else {
                UtilityClass.showAlert(message: response.dictionary?["message"]?.string ?? "Something went wrong.")
            }
        }
    }
}
