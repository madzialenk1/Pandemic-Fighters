//
//  TableManager.swift
//  pandemic fighters
//
//  Created by Magdalena  Pękacka on 07/06/2020.
//  Copyright © 2020 Magdalena  Pękacka. All rights reserved.
//

import Foundation
import CoreLocation
struct TableManager {
    
    let location: CLLocation
    let data: String
    let description: String
    var address: String?
    
   
    mutating func change (value: String){
        address = value
    }
    
      // MARK: - Format date from timeInterval
    var dataFormatted: String{
        if let time = Double(data) {
                let date = Date(timeIntervalSince1970: time)
                let f = DateFormatter()
                f.dateFormat = "dd MMM yyy"
                let dateFormated = f.string(from: date)
                return dateFormated
            }
        return ""
    }
        
}

