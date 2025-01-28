//
//  CityListRow.swift
//  UalaChallenge
//
//  Created by Liz Fabiola Isasi Cardozo on 28/01/2025.
//

import SwiftUI

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
    CityRow(city: .init(id: nil, _id: 1, name: "Test City", country: "Test Country", coord: .init(lon: 1.0, lat: 1.0), isFavorite: false), onFavoriteToggle: { })
}
