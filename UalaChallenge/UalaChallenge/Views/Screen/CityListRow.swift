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
            VStack(alignment: .leading, spacing: 4) {
                Text("\(city.name), \(city.country)")
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("Lon: \(String(format: "%.2f", city.coord.lon)), Lat: \(String(format: "%.2f", city.coord.lat))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: onFavoriteToggle) {
                Image(systemName: city.isFavorite ? "star.fill" : "star")
                    .foregroundColor(city.isFavorite ? .yellow : .gray)
                    .font(.title3)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

#Preview {
    CityRow(city: .init(id: nil, _id: 1, name: "Test City", country: "Test Country", coord: .init(lon: 1.0, lat: 1.0), isFavorite: false), onFavoriteToggle: { })
}
