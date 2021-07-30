//
//  VirusModel.swift
//  pandemic fighters
//
//  Created by Magdalena  Pękacka on 28/05/2020.
//  Copyright © 2020 Magdalena  Pękacka. All rights reserved.
//

import Foundation
import CoreLocation

struct VirusModel: Codable {
    
    let latitude : CLLocationDegrees
    let longtitude : CLLocationDegrees
    let tested: String
    let data: String
    let description: String
    let symptoms: [String]
  
}

