//
//  HTTPMethods.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 20/04/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation


enum Method: String{
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}
