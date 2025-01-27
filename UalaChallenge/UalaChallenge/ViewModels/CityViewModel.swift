//
//  CityViewModel.swift
//  UalaChallenge
//
//  Created by Liz Fabiola Isasi Cardozo on 27/01/2025.
//

import Foundation
import Combine

class CityViewModel: ObservableObject {
    @Published var cities: [City] = []
    @Published var searchText: String = ""
    @Published var showFavoritesOnly: Bool = false
    
    let cityService: CityService
    
    init(cityService: CityService = CityService()) {
        self.cityService = cityService
    }
    
    @MainActor
    func fetchCities() {
        Task {
            self.cityService.fetchCities { cities in
                self.cities = cities
            }
        }
    }

    var filteredCities: [City] {
        cities.filter {
            $0.name.lowercased().hasPrefix(searchText.lowercased())
            && (!($0.isFavorite ?? false) || showFavoritesOnly)
        }.sorted { $0.name < $1.name }
    }

    func toggleFavorite(for city: City) {
        if let index = cities.firstIndex(where: { $0.id == city.id }) {
            cities[index].isFavorite?.toggle()
        }
    }
}
