//
//  Register.swift
//  Peppea
//
//  Created by Mayur iMac on 29/06/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import Foundation
import UIKit

class RegistrationModel : RequestModel {
    
    var driver_role:String = ""
    var car_type:String = ""
    var owner_name:String = ""
    var owner_email:String = ""
    var owner_mobile_no:String = ""
    var first_name:String = ""
    var last_name:String = ""
    var email:String = ""
    var mobile_no:String = ""
    var dob:String = ""
    var gender:String = ""
    var payment_method:String = ""
    var account_holder_name:String = ""
    var bank_name:String = ""
    var bank_branch:String = ""
    var account_number:String = ""
    var lat:String = ""
    var lng:String = ""
    var device_type:String = ""
    var device_token:String = ""
    var address:String = ""
    var plate_number:String = ""
    var vehicle_color: String = ""
    var year_of_manufacture:String = ""
    var vehicle_type_model_name:String = ""
    var vehicle_type_model_id: String = ""
    var vehicle_type_manufacturer_name: String = ""
    var vehicle_type_manufacturer_id: String = ""
    var no_of_passenger:String = ""
    var vehicle_type:String = ""
    var invite_code: String = ""
    var work_with_other_company:String = ""
    var other_company_name:String = ""
    var company_id: String = ""
    var car_left:String = ""
    var car_right:UIImage = UIImage()
    var car_front:UIImage = UIImage()
    var car_back:UIImage = UIImage()
    var ntsa_inspection_image: UIImage = UIImage()
    var ntsa_exp_date:String = ""
    var vehicle_insurance_certi:UIImage = UIImage()
    var vehicle_insurance_exp_date:String = ""
    var vehicle_log_book_image:UIImage = UIImage()
    var driver_licence_image:UIImage = UIImage()
    var driver_licence_exp_date:String = ""
    var national_id_image:UIImage = UIImage()
    var police_clearance_certi:UIImage = UIImage()
    var police_clearance_exp_date:String = ""
    var psv_badge_image:UIImage = UIImage()
    var psv_badge_exp_date:String = ""
    var national_id_number:String = ""
}


class OTPModel : RequestModel {
    var mobile_no : String = ""
    var email : String = ""

}


class ResendOTPModel : RequestModel {
    var mobile_no : String = ""
    var email :String = ""
}


class RegisterUser : RequestModel {
    var FirstName : String = ""
    var LastName : String = ""
    var DateOfBirth : String = ""
    var RafarralCode : String = ""
    var Female : String = ""
    var ProfileImage : UIImage = UIImage()
    var Token : String = ""
    var DeviceType : String = ""
}
