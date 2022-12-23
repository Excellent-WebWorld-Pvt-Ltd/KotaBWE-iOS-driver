//
//  NotificationModel.swift
//  DSP Driver
//
//  Created by Admin on 23/11/21.
//  Copyright © 2021 baps. All rights reserved.
//

import Foundation

struct NotificationInfo : Codable {

    let createdDate : String?
    let descriptionField : String?
    let id : String
    let readStatusUser : String?
    let title : String?
    let userId : String?
    let userType : String?

    enum CodingKeys: String, CodingKey {
        case createdDate = "created_date"
        case descriptionField = "description"
        case id
        case readStatusUser = "read_status_user"
        case title
        case userId = "user_id"
        case userType = "user_type"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        createdDate = try? values.decode(String.self, forKey: .createdDate)
        descriptionField = try? values.decode(String.self, forKey: .descriptionField)
        id = try values.decode(String.self, forKey: .id)
        readStatusUser = try? values.decode(String.self, forKey: .readStatusUser)
        title = try? values.decode(String.self, forKey: .title)
        userId = try? values.decode(String.self, forKey: .userId)
        userType = try? values.decode(String.self, forKey: .userType)
    }

}
