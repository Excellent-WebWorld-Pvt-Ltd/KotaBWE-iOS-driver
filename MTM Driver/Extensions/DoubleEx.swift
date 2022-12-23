//
//  DoubleEx.swift
//  Pappea Driver
//
//  Created by Apple on 13/08/19.
//  Copyright © 2019 baps. All rights reserved.
//

import Foundation
import CoreLocation


extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func toString() -> String {
        String(self)
    }
}

extension CLLocationDistance {
    func inMiles() -> CLLocationDistance {
        return self*0.00062137
    }

    func inKilometers() -> CLLocationDistance {
        return self/1000
    }
}
