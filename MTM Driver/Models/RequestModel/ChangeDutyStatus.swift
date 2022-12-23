//
//  ChangeDutyStatus.swift
//  Pappea Driver
//
//  Created by Apple on 19/07/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation

class ChangeDutyStatus : RequestModel {
    var driver_id: String = ""
    var lat: String = ""
    var lng: String = ""
}


class ReviewRatingReqModel : RequestModel {
    var booking_id:String = ""
    var rating:String = ""
    var comment:String = ""
}
