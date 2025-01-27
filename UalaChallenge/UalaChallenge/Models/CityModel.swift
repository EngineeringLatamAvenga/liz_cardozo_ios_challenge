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
    var isFavorite: Bool = false

    struct Coordinates: Codable, Hashable {
        let lon: Double
        let lat: Double
    }

    enum CodingKeys: String, CodingKey {
        case _id, name, country, coord, isFavorite
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._id = try container.decode(Int.self, forKey: ._id)
        self.name = try container.decode(String.self, forKey: .name)
        self.country = try container.decode(String.self, forKey: .country)
        self.coord = try container.decode(Coordinates.self, forKey: .coord)
        self.isFavorite = try container.decodeIfPresent(Bool.self, forKey: .isFavorite) ?? false
    }

    init(id: UUID? = UUID(), _id: Int, name: String, country: String, coord: Coordinates, isFavorite: Bool = false) {
        self.id = id
        self._id = _id
        self.name = name
        self.country = country
        self.coord = coord
        self.isFavorite = isFavorite
    }
}
