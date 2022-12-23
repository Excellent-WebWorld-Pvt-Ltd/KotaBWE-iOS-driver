//
//  JSONPascable.swift
//  MTM Driver
//
//  Created by Gaurang on 28/09/22.
//  Copyright © 2022 baps. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol JSonParsable {
    init?(json: JSON)
}

extension JSON {
    func getApiMessage() -> String {
        if let messageStr = self["message"].string {
            return messageStr
        } else if let array = self["message"].array {
            return array.compactMap({$0.string}).joined(separator: "\n")
        } else {
            return ""
        }
    }
}

class CommonApiResponse: JSonParsable {
    let status: Bool
    let message: String?
    
    required init(json: JSON) {
        status = json["status"].boolValue
        message = json.getApiMessage()
    }
}

class BaseResponseModel<T: JSonParsable>: CommonApiResponse {
    let data: T?
    required init(json: JSON) {
        data = T(json: json["data"])
        super.init(json: json)
    }
}

class BaseResponseArrayModel<T: JSonParsable>: CommonApiResponse {
    let data: [T]
    required init(json: JSON) {
        data = json["data"].arrayValue.compactMap({T(json: $0)})
        super.init(json: json)
    }
}
