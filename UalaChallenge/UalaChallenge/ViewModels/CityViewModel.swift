//
//  CityViewModel.swift
//  UalaChallenge
//
//  Created by Liz Fabiola Isasi Cardozo on 27/01/2025.
//

import Foundation
import Combine

class CityViewModel: ObservableObject {
    var cities: [City] = []
    @Published var searchText: String = ""
    @Published var showFavoritesOnly: Bool = false
    @Published private(set) var filteredCities: [City] = []
    @Published var isLoading: Bool = false
    @Published var selectedCity: City?
    
    var cityService: CityServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private let favoritesKey = "favoriteCities"

    init(cityService: CityServiceProtocol) {
        self.cityService = cityService
        setupBindings()
    }

    private func setupBindings() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateFilterCities()
            }
            .store(in: &cancellables)
    }

    @MainActor
    func fetchCities() {
        isLoading = true
        Task {
            self.cityService.fetchCities { [weak self] result in
                switch result {
                case .success(let cities):
                    print("Successfully fetched \(cities.count) cities.")
                    self?.cities = cities
                    self?.loadFavorites()
                    self?.filteredCities = self?.filterCities() ?? []
                case .failure(let error):
                    print("Failed to fetch cities: \(error)")
                }
                self?.isLoading = false
            }
        }
    }


    func updateFilterCities() {
        filteredCities = filterCities()
    }

    private func filterCities() -> [City] {
        cities.filter {
            $0.name.lowercased().hasPrefix(searchText.lowercased()) &&
            (!showFavoritesOnly || $0.isFavorite)
        }.sorted { $0.name < $1.name }
    }

    func toggleFavorite(for city: City) {
        if let index = cities.firstIndex(where: { $0._id == city._id }) {
            cities[index].isFavorite.toggle()
        }

        if let index = filteredCities.firstIndex(where: { $0._id == city._id }) {
            filteredCities[index].isFavorite.toggle()
        }

        filteredCities = filterCities()
        saveFavorites()
    }

    private func saveFavorites() {
        let favoriteIDs = cities.filter { $0.isFavorite }.map { $0._id }
        UserDefaults.standard.set(favoriteIDs, forKey: favoritesKey)
    }

    private func loadFavorites() {
        let favoriteIDs = UserDefaults.standard.array(forKey: favoritesKey) as? [Int] ?? []
        for id in favoriteIDs {
            if let index = cities.firstIndex(where: { $0._id == id }) {
                cities[index].isFavorite = true
            }
        }
    }

}

