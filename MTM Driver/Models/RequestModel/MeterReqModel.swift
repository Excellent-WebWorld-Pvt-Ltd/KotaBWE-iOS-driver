//
//  MeterReqModel.swift
//  DSP Driver
//
//  Created by Admin on 03/12/21.
//  Copyright © 2021 baps. All rights reserved.
//

import Foundation

class MeterRequestModel: RequestModel {
    var driver_id : String = ""
    var mobile_no : String = ""
    var pickup_lat : String = ""
    var pickup_lng : String = ""
}


class EndMeterRequestModel : RequestModel {
    var meter_id : String = ""
    var duration : String = ""
    var distance : String = ""
    var waiting_time : String = ""
    var fare : String = ""
    var dropoff_lat : String = ""
    var dropoff_lng : String = ""
}
