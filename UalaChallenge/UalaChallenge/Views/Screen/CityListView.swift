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
    @State private var selectedCity: City?
    
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
                    selectedCity = city
                }
            }
            .frame(maxWidth: .infinity)
            
            Divider()
            
            if let city = selectedCity {
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

struct CityRow: View {
    let city: City
    var onFavoriteToggle: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(city.name), \(city.country)")
                    .font(.headline)
                Text("Lon: \(city.coord.lon), Lat: \(city.coord.lat)")
                    .font(.subheadline)
            }
            Spacer()
            Button(action: onFavoriteToggle) {
                Image(systemName: city.isFavorite == true ? "star.fill" : "star")
                    .foregroundColor(city.isFavorite == true ? .yellow : .gray)
            }
        }
        .padding(.vertical, 4)
    }
}

extension View {
    func commonOverlay(isLoading: Bool) -> some View {
        self.overlay(
            Group {
                if isLoading {
                    ZStack {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                        ProgressView("Loading cities...")
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                    }
                    .transition(.opacity)
                }
            }
        )
    }
}

#Preview {
    CityListView(viewModel: CityViewModel(cityService: CityService()))
}
