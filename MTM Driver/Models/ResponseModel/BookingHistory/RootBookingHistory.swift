//
//  RootBookingHistory.swift
//  DSP Driver
//
//  Created by Admin on 19/11/21.
//  Copyright © 2021 baps. All rights reserved.
//

import Foundation
import SwiftyJSON


class RootBookingHistory : NSObject{

    var data : [BookingHistoryResponse]!
    var message : String!
    var status : Bool!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        data = [BookingHistoryResponse]()
        let dataArray = json["data"].arrayValue
        for dataJson in dataArray{
            let value = BookingHistoryResponse(fromJson: dataJson)
            data.append(value)
        }
        message = json["message"].stringValue
        status = json["status"].boolValue
    }

    

}
