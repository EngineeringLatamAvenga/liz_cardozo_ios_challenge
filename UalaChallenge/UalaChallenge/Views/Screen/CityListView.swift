//
//  CityListView.swift
//  UalaChallenge
//
//  Created by Liz Fabiola Isasi Cardozo on 27/01/2025.
//

import SwiftUI

struct CityListView: View {
    @ObservedObject var viewModel: CityViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                SearchBarView(text: $viewModel.searchText)
                Toggle("Favorites Only", isOn: $viewModel.showFavoritesOnly)
                    .padding()
                
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(viewModel.filteredCities, id: \.id) { city in
                            CityRow(city: city, onFavoriteToggle: {
                                viewModel.toggleFavorite(for: city)
                            })
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                        }
                    }
                }
            }
            .overlay(content: {
                if viewModel.isLoading {
                    ZStack {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                        ProgressView("Loading cities...")
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                    }
                    .transition(.opacity) // Transición animada
                }
            })
            .navigationTitle("Cities")
            .onAppear {
                viewModel.fetchCities()
            }
            .onChange(of: viewModel.showFavoritesOnly) { oldValue, newValue in
                viewModel.updateFilterCities()
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

#Preview {
    CityListView(viewModel: CityViewModel())
}
