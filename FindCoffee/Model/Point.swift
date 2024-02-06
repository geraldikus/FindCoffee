//
//  Point.swift
//  FindCoffee
//
//  Created by Anton on 05.02.24.
//

import Foundation

struct Point: Decodable {
    let latitude: Double
    let longitude: Double
    
    private enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let latitudeString = try container.decode(String.self, forKey: .latitude)
        let longitudeString = try container.decode(String.self, forKey: .longitude)
        
        if let latitude = Double(latitudeString), let longitude = Double(longitudeString) {
            self.latitude = latitude
            self.longitude = longitude
        } else {
            throw DecodingError.dataCorruptedError(
                forKey: .latitude,
                in: container,
                debugDescription: "Invalid latitude or longitude format"
            )
        }
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

struct BigDecimal: Codable {

}
