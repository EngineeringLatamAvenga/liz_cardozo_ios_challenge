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
                        ForEach(viewModel.cities, id: \.self) { city in
                            CityRow(city: city)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                        }
                    }
                }
            }
            .navigationTitle("Cities")
            .onAppear {
                viewModel.fetchCities()
            }
        }
    }
}

struct CityRow: View {
    let city: City
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(city.name), \(city.country)")
                .font(.headline)
            Text("Lon: \(city.coord.lon), Lat: \(city.coord.lat)")
                .font(.subheadline)
        }
    }
}

#Preview {
    CityListView(viewModel: CityViewModel())
}
