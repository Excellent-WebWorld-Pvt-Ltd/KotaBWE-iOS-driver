//
//  UserDefaults.swift
//  CabRideDriver
//
//  Created by EWW-iMac Old on 14/05/19.
//  Copyright © 2019 baps. All rights reserved.
//

import UIKit

public extension UserDefaults {
    
    
    //-------------------------------------------------------------
    // Set Codable object into UserDefaults
    //-------------------------------------------------------------
    
    func set<T: Codable>(object: T, forKey: String) throws {
        
        let jsonData = try JSONEncoder().encode(object)
        
        set(jsonData, forKey: forKey)
    }
    
    
    func get<T: Codable>(objectType: T.Type, forKey: String) throws -> T? {
        
        guard let result = value(forKey: forKey) as? Data else {
            return nil
        }
        return try JSONDecoder().decode(objectType, from: result)
    }
}

