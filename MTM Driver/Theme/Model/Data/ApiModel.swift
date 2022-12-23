//
//  ApiModel.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 17/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation

struct CustomAPI: Codable{
    var googleMap: String!
    var googlePlaces: String!
    var baseURL: String!
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(CustomAPI.self, from: data)
    }
}
