//
//  ChatVC+Extension.swift
//  DSP Driver
//
//  Created by Admin on 26/11/21.
//  Copyright © 2021 baps. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ChatMessage {
    let id: String
    let message : String
    let receiverId : String
    let senderId : String
    let isSender : Bool
    let date: String
    let time: String
    let senderType: String
    let receiverType: String
}

extension ChatMessage {
    init(from dictionary: JSON) {
       id = dictionary["id"].stringValue
       message = dictionary["message"].stringValue
       receiverId = dictionary["receiver_id"].stringValue
       senderId = dictionary["sender_id"].stringValue
       senderType = dictionary["sender_type"].stringValue
       receiverType = dictionary["receiver_type"].stringValue
       let fullDate = dictionary["created_at"].stringValue
       date = String(fullDate.split(separator: " ")[0])
       time = dictionary["time"].stringValue
       isSender = senderType == "driver" ? true : false
   }
}

extension ChatMessage {
    init(message: String, receiverId: String, senderId: String) {
        id = ""
        self.message = message
        self.receiverId = receiverId
        self.senderId = senderId
        self.isSender = true
        self.senderType = "driver"
        self.receiverType = "customer"
        self.date = DateFormatHelper.digitDate.getDateString(from: Date())
        self.time = DateFormatHelper.twelveHrTime.getDateString(from: Date())
    }
}

extension ChatMessage {
    static func getObjectFrom(info: [String: Any]) -> ChatMessage? {
        guard let senderID = info["sender_id"] as? String,
              let receiverID = info["receiver_id"] as? String,
              let message = info["message"] as? String,
              let senderType = info["sender_type"] as? String,
              let receiverType = info["receiver_type"] as? String,
              let fullDate = info["created_at"] as? String else {
            return nil
        }
        var date = ""
        var time = ""
        if let createdDate = DateFormatHelper.standard.getDate(from: fullDate) {
            date = DateFormatHelper.digitDate.getDateString(from: createdDate)
            time = DateFormatHelper.twelveHrTime.getDateString(from: createdDate)
        }
        let chatMessage = ChatMessage(id: "", message: message, receiverId: receiverID,
                                      senderId: senderID, isSender: false, date: date, time: time , senderType: senderType,receiverType: receiverType)
        return chatMessage
    }
}

class ChatSectionData {
    var day : String!
    var chatData : [ChatMessage] = []
    var date : String!
}
