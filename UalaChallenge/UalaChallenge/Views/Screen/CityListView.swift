//
//  CityListView.swift
//  UalaChallenge
//
//  Created by Liz Fabiola Isasi Cardozo on 27/01/2025.
//

import SwiftUI

struct CityListView: View {
    @ObservedObject var viewModel: CityViewModel
    @State var path: [Screen] = []
    
    enum Screen: Hashable {
        case detailView(city: City)
    }
    
    var body: some View {
        GeometryReader { geometry in
            Group {
                if geometry.size.width > geometry.size.height {
                    landscapeView
                } else {
                    portraitView
                }
            }
            .onAppear {
                viewModel.fetchCities()
            }
            
            .onChange(of: viewModel.showFavoritesOnly) { oldValue, newValue in
                viewModel.updateFilterCities()
            }
            .commonOverlay(isLoading: viewModel.isLoading)
        }
    }
    
    private var portraitView: some View {
        NavigationStack(path: $path) {
            VStack {
                commonFilters
                cityList { city in
                    path.append(.detailView(city: city))
                }
            }
            
            .navigationTitle("Cities")
            
            .navigationDestination(for: Screen.self) { screen in
                switch screen {
                case .detailView(city: let city):
                    CityDetailView(viewModel: CityDetailViewModel(city: city))
                }
            }
        }
    }
    
    private var landscapeView: some View {
        HStack {
            VStack {
                commonFilters
                cityList { city in
                    viewModel.selectedCity = city
                }
            }
            .frame(maxWidth: .infinity)
            
            Divider()
            
            if let city = viewModel.selectedCity {
                CityDetailView(viewModel: CityDetailViewModel(city: city))
                    .frame(maxWidth: .infinity)
            } else {
                Text("Select a city to view its location.")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(.gray)
            }
        }
    }
    
    private var commonFilters: some View {
        VStack {
            SearchBarView(text: $viewModel.searchText)
            Toggle("Favorites Only", isOn: $viewModel.showFavoritesOnly)
                .padding()
                .accessibilityIdentifier("FavoritesToggle")
        }
    }
    
    private func cityList(onCitySelected: @escaping (City) -> Void) -> some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(viewModel.filteredCities, id: \.self) { city in
                    CityRow(city: city, onFavoriteToggle: {
                        viewModel.toggleFavorite(for: city)
                    })
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .onTapGesture {
                        onCitySelected(city)
                    }
                }
            }
        }
    }
}

#Preview {
    CityListView(viewModel: CityViewModel(cityService: CityService()))
}
