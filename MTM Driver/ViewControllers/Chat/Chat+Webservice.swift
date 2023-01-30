//
//  Chat+Webservice.swift
//  DSP Driver
//
//  Created by Admin on 26/11/21.
//  Copyright © 2021 baps. All rights reserved.
//

import Foundation
import UIKit

extension ChatVC {

    func webServiceToSendMessage(chatType: String)  {
        let requestModel = ChatMessageRequestModel()
        requestModel.booking_id = self.strBookingId
        requestModel.sender_type = "driver"
        requestModel.receiver_type = "customer"
        requestModel.sender_id = Singleton.shared.driverId
        requestModel.receiver_id = self.receiverId
        requestModel.chat_type = chatType
        requestModel.message = self.textViewSendMsg.text
        WebServiceCalls.chatWithDriver(SendChat: requestModel,image: selectedImage,imageParamName: "chat_image") { (response, status) in
            if !status {
                self.webServiceForGetChatHistory()
            }else{
                guard let data = response["data"].array else {
                    self.tblChatHistory.reloadData()
                    return
                }
                data.map({ChatMessage(from: $0)}).forEach({
                    self.addNewMessage($0, animated: true)
                })
                self.tblChatHistory.reloadData()
                self.scrollToBottom()
            }
        }
    }

    @objc func webServiceForGetChatHistory() {
        WebServiceCalls.chatHistoryWithDriver(strURL: strBookingId) { (json, status) in
            self.arrSection = []
            if status {
                guard let data = json["data"].array else {
                    self.tblChatHistory.reloadData()
                    return
                }
                data.map({ChatMessage(from: $0)}).forEach({
                    self.addNewMessage($0, animated: false)
                })
                self.tblChatHistory.reloadData()
                self.scrollToBottom()
            } else {
                AlertMessage.showMessageForError(json["message"].stringValue)
            }
        }
    }
}
