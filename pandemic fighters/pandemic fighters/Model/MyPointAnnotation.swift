//
//  MyPointAnnotation.swift
//  pandemic fighters
//
//  Created by Magdalena  Pękacka on 13/06/2020.
//  Copyright © 2020 Magdalena  Pękacka. All rights reserved.
//

import MapKit

// MARK: - It helps make each point annotation outstanding
class MyPointAnnotation : MKPointAnnotation {
    
    var identifier: String?
    var address: String?
    var symptoms: String?
    var tested: String?
    var date: Int?
    var virusDescription: String?
}
