//
//  CityModel.swift
//  UalaChallenge
//
//  Created by Liz Fabiola Isasi Cardozo on 27/01/2025.
//

import Foundation

struct City: Identifiable, Codable, Hashable {
    var id: UUID? = UUID()
    let _id: Int
    let name: String
    let country: String
    let coord: Coordinates
    var isFavorite: Bool? = false

    struct Coordinates: Codable, Hashable {
        let lon: Double
        let lat: Double
    }
}
