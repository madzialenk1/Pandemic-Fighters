//
//  DataManager.swift
//  pandemic fighters
//
//  Created by Magdalena  Pękacka on 28/05/2020.
//  Copyright © 2020 Magdalena  Pękacka. All rights reserved.
//

import Foundation

struct DataManager: Codable {
    let documents: [Document]
}

// MARK: - Document
struct Document: Codable {
    let fields: Fields

}

// MARK: - Fields
struct Fields: Codable {
    let longitude: Itude
    let timeStamp: Description
    let selfReported: SelfReported
    let fieldsDescription: Description
    let latitude: Itude
    let tested: Description
    let symptoms: Symptoms?

    enum CodingKeys: String, CodingKey {
        case longitude, timeStamp, selfReported
        case fieldsDescription = "description"
        case latitude, tested, symptoms 
    }
}

// MARK: - Description
struct Description: Codable {
    let stringValue: String
}

// MARK: - Itude
struct Itude: Codable {
    let doubleValue: Double
}

// MARK: - SelfReported
struct SelfReported: Codable {
    let booleanValue: Bool
}

// MARK: - Symptoms
struct Symptoms: Codable {
    let arrayValue: ArrayValue?
}

// MARK: - ArrayValue
struct ArrayValue: Codable {
    let values: [Description]?
}
