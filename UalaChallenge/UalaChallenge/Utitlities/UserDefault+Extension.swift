//
//  UserDefault+Extension.swift
//  UalaChallenge
//
//  Created by Liz Fabiola Isasi Cardozo on 27/01/2025.
//

import Foundation

extension UserDefaults {
    func saveFavorites(_ favorites: [City]) {
        if let data = try? JSONEncoder().encode(favorites) {
            set(data, forKey: "FavoriteCities")
        }
    }

    func loadFavorites() -> [City] {
        if let data = data(forKey: "FavoriteCities"),
           let favorites = try? JSONDecoder().decode([City].self, from: data) {
            return favorites
        }
        return []
    }
}
