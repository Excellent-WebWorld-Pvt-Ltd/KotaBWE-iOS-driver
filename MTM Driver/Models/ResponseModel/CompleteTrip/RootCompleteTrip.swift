//
//  RootCompleteTrip.swift
//  DSP Driver
//
//  Created by Admin on 19/11/21.
//  Copyright © 2021 baps. All rights reserved.
//

import Foundation
import SwiftyJSON

class RootCompleteTrip {
    var data : CompeteTripData!
    var message : String!
    var paymentType : String!
    var status : Bool!
    var totalDriverEarning: String!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let dataJson = json["data"]
        if !dataJson.isEmpty{
            data = CompeteTripData(fromJson: dataJson)
        }
        message = json.getApiMessage()
        data.message = json.getApiMessage()
        paymentType = json["payment_type"].stringValue
        status = json["status"].boolValue
        totalDriverEarning = json["total_driver_earning"].stringValue
    }
}
