//
//  Decoder.swift
//  pandemic fighters
//
//  Created by Magdalena  Pękacka on 20/06/2020.
//  Copyright © 2020 Magdalena  Pękacka. All rights reserved.
//

import Foundation
import CoreLocation

class Decoder {
    
    static func getAdress(location: CLLocation, completion: @escaping(_ addres: Result<String,Error>) -> () ){
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let placemark = placemarks?.first else {
                completion(.failure(error as! Error))
                return
            }
            
            let number = placemark.subThoroughfare ?? ""
            let street = placemark.thoroughfare ?? ""
            let city = placemark.locality ?? ""
            let addres = "\(street) \(number) \(city)"
            
            completion(.success(addres))
            
        }
        
    }
}
