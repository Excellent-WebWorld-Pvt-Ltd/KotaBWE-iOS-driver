//
//  ChatReqModel.swift
//  DSP Driver
//
//  Created by Admin on 26/11/21.
//  Copyright © 2021 baps. All rights reserved.
//

import Foundation

class ChatMessageRequestModel: RequestModel {
    var booking_id:String = ""
    var sender_type:String = ""
    var sender_id:String = ""
    var receiver_type:String = ""
    var receiver_id:String = ""
    var message:String = ""
    var chat_type: String = ""
}
