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
    @Published var isLoading = false
    
    let cityService: CityService
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var filteredCities: [City] = []
    
    init(cityService: CityService = CityService()) {
        self.cityService = cityService
        setupBindings()
    }
    
    private func setupBindings() {
        // For using the debounce capability
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateFilterCities()
            }
            .store(in: &cancellables)
        
    }
    
    @MainActor
    func fetchCities() {
        Task {
            isLoading = true
            self.cityService.fetchCities { [weak self] cities in
                self?.isLoading = false
                self?.cities = cities
                self?.filteredCities = self?.filterCities() ?? []
            }
        }
    }
    
    func updateFilterCities() {
        filteredCities = filterCities()
    }
    
    private func filterCities() -> [City] {
        cities.filter {
            $0.name.lowercased().hasPrefix(searchText.lowercased()) &&
            (!showFavoritesOnly || ($0.isFavorite))
        }.sorted { $0.name < $1.name }
    }
    
    func toggleFavorite(for city: City) {
        if let index = cities.firstIndex(where: { $0.id == city.id }) {
            cities[index].isFavorite.toggle()
        }
        
        if let index = filteredCities.firstIndex(where: { $0.id == city.id }) {
            filteredCities[index].isFavorite.toggle()
        }
        
        filteredCities = filterCities()
    }
}
