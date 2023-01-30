//
//  ChatVC.swift
//  DSP Driver
//
//  Created by Admin on 25/10/21.
//  Copyright © 2021 baps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class Chathistory : Codable{
    
    var day : String!
    var fullName : String!
    var msg : String!
    var profilePic : String!
    var receiverId : String!
    var senderId : String!
    var senderName : String!
    var time : String!
    var type : String!
    var isSender : String!
    var date : String!

    init(FullName:String , Msg : String , ProfilePic : String , ReceivedID : String , SernderID : String , SenderName : String , IsSender : String , Time : String , Date : String , Day : String) {
        self.fullName = FullName
        self.msg = Msg
        self.profilePic = ProfilePic
        self.receiverId = ReceivedID
        self.senderId = SernderID
        self.isSender = IsSender
        self.time = Time
        self.day = Day
        self.date = Date
    }
    
}

class ChatVC: BaseViewController {
    
    //MARK:- ===== Outlets ======
    @IBOutlet weak var tblChatHistory: UITableView!
    @IBOutlet weak var textViewSendMsg: IQTextView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var conBottomChatBox: NSLayoutConstraint!
    @IBOutlet weak var inputContrainerView: UIView!
    @IBOutlet weak var viewPastChat: UIView!
    @IBOutlet weak var bottomConPastView: NSLayoutConstraint!
    
    var strBookingId = ""
    var receiverId = ""
    var receiverName: String = ""
    var senderId: String = ""
    var isComingFromPast: Bool = false
    var receiverImage = String()
    var selectedImage: UIImage?
    //MARK:- ===== Variables =====
    var arrSection = [ChatSectionData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        senderId = Singleton.shared.driverId
        UISetup()
        tblChatHistory.reloadData()
        webServiceForGetChatHistory()
        setSendButtonAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupKeyboard(false)
        self.hideKeyboardGesture()
        self.registerForKeyboardNotifications()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissKeyboard()
        setupKeyboard(true)
        self.deregisterFromKeyboardNotifications()
    }

    //MARK:- =====UI Setup ========
    func UISetup(){
        //hideKeyboardWhenTappedAround()
        if isComingFromPast {
            viewPastChat.isHidden = false
            inputContrainerView.isHidden = true
        }else{
            viewPastChat.isHidden = true
            inputContrainerView.isHidden = false
        }
        bottomConPastView.constant = Helper.bottomSafeAreaHeight > 0 ? Helper.bottomSafeAreaHeight + 5 : 5
        registerForKeyboardNotifications()
        var titleStr = ""
        if receiverName.isEmpty {
            let fullname = (Singleton.shared.bookingInfo?.customerInfo.firstName ?? "") + " " + (Singleton.shared.bookingInfo?.customerInfo.lastName ?? "")
             receiverName = fullname
        } else {
            titleStr = receiverName
        }
        setupNavigation(.normal(title: titleStr, leftItem: .back, hasNotification: false))
        textViewSendMsg.delegate = self
        self.textViewSendMsg.textColor = UIColor.black
        self.textViewSendMsg.font = FontBook.regular.font(ofSize: 14.0)
        
    }

    func hideKeyboardGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboards))
        view.addGestureRecognizer(tap)
    }

    func addNewMessage(_ message:  ChatMessage, animated: Bool) {
        if let section = arrSection.first(where: {$0.date == message.date}) {
            section.chatData.append(message)
            if animated {
                insertRowWithAnimation(section: section)
            }
        } else {
            let section = ChatSectionData()
            section.date = message.date
            section.day = DateFormatHelper.digitDate.getDate(from: message.date)?.getDayDifferentText()
            section.chatData.append(message)
            arrSection.append(section)
            if animated {
                insertNewSectionWithAnimation(section: section)
            }
        }
    }

    private func insertNewSectionWithAnimation(section: ChatSectionData) {
        if let index = arrSection.firstIndex(where: {$0.date == section.date}) {
            self.tblChatHistory.insertSections([index], with: .bottom)
            self.scrollToBottom()
        }
    }

    private func insertRowWithAnimation(section: ChatSectionData) {
        if let index = arrSection.firstIndex(where: {$0.date == section.date}) {
            let indexPath = IndexPath(row: section.chatData.count - 1, section: index)
            self.tblChatHistory.insertRows(at: [indexPath], with: .bottom)
            self.tblChatHistory.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

    func scrollToBottom() {
        guard self.arrSection.isNotEmpty else {
            return
        }
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.arrSection[self.arrSection.count - 1].chatData.count - 1, section: self.arrSection.count - 1)
                self.tblChatHistory.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
    }
    
    @IBAction func btnSendImage(_ sender: UIButton) {
        ImagePickerViewController.open(from: self, allowEditing: true) { [unowned self] image in
            self.selectedImage = image
            self.webServiceToSendMessage(chatType: "image")
        }
    }
    
    @IBAction func btnActionMessage(_ sender: UIButton) {
//        let message = ChatMessage(message: self.textViewSendMsg.getText(), receiverId: receiverId, senderId: senderId, chatType: "text", chatImage: "")
//        addNewMessage(message, animated: true)
        webServiceToSendMessage(chatType: "text")
        self.textViewSendMsg.text = ""
        setSendButtonAppearance()
    }
    
    func setSendButtonAppearance() {
        btnSend.isEnabled = textViewSendMsg.isEmpty == false
    }
}
