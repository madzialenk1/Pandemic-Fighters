//
//  VirusManager.swift
//  pandemic fighters
//
//  Created by Magdalena  Pękacka on 28/05/2020.
//  Copyright © 2020 Magdalena  Pękacka. All rights reserved.
//


import Foundation
import CoreLocation

protocol VirusManagerDelegete {
    func updateMapView(virusLocation: [VirusModel])
}

struct VirusManager {
    
    let dataURL = "https://firestore.googleapis.com/v1/projects/pandemicfighters/databases/(default)/documents/VirusLocations?pageSize=50"
    let dataToSaveURL = "https://firestore.googleapis.com/v1/projects/pandemicfighters/databases/(default)/documents/VirusLocations"
    
    var delegete: VirusManagerDelegete?
 
    
    func performRequest() {
        
        if let url = URL(string: dataURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if let e = error {
                    print(e.localizedDescription)
                    return
                }
                if let safeData = data {
                    let virusLocation = self.parseJSONForMap(virusData: safeData)
                    self.delegete?.updateMapView(virusLocation: virusLocation)
                }
            }
            task.resume()
        }
        
        
    }
    
    func parseJSONForMap(virusData: Data) -> [VirusModel]{
        var virusModelArray = [VirusModel]()
        let decoder  = JSONDecoder()
        do {
            let decodedData = try decoder.decode(DataManager.self, from: virusData)
            for document in decodedData.documents {
  
                let lat = document.fields.latitude.doubleValue
                let long = document.fields.longitude.doubleValue
                let tested = document.fields.tested.stringValue
                let date = document.fields.timeStamp.stringValue
                let description = document.fields.fieldsDescription.stringValue
                let symptoms = document.fields.symptoms?.arrayValue?.values
                virusModelArray.append(VirusModel(latitude: lat, longtitude: long, tested: tested, data: date, description: description,symptoms: symptoms ))
            }
        } catch {
            print(error)
        }
        return virusModelArray
    }
    
   
 
    func save (_ documentToSend: Document, completion: @escaping(Result<Document,APIError>) -> Void ) {
        
        if let url = URL(string: dataToSaveURL) {
            do {
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = "POST"
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.httpBody = try JSONEncoder().encode(documentToSend)
                let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse,
                        httpResponse.statusCode == 200
                        else {
                            print(response.debugDescription)
                            completion(.failure(.responseProblem))
                            return
                    }
                }
                dataTask.resume()
            }
                
            catch {
                completion(.failure(.encodingProblem))
            }
        }
        
    }
    
}


enum APIError: Error {
    
    case responseProblem
    case decodingProblem
    case encodingProblem
}
