//
//  CityDetailView.swift
//  UalaChallenge
//
//  Created by Liz Fabiola Isasi Cardozo on 27/01/2025.
//

import SwiftUI
import MapKit

struct CityDetailView: View {
    @ObservedObject var viewModel: CityDetailViewModel
    
    @State private var region: MKCoordinateRegion

    init(viewModel: CityDetailViewModel) {
        self.viewModel = viewModel
        self._region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: viewModel.city.coord.lat, longitude: viewModel.city.coord.lon),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        ))
    }
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: [viewModel.city]) { city in
            MapAnnotation(
                coordinate: CLLocationCoordinate2D(latitude: city.coord.lat, longitude: city.coord.lon)
            ) {
                VStack {
                    Text(city.name)
                        .font(.caption)
                        .bold()
                        .padding(5)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 3)
                    Image(systemName: "mappin.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.blue)
                }
            }
        }
        .navigationTitle(viewModel.city.name)
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: viewModel.city, { oldValue, newValue in
            updateRegion(for: newValue)
        })
    }
    
    private func updateRegion(for city: City) {
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: city.coord.lat, longitude: city.coord.lon),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    }
}

#Preview {
    let coord = City.Coordinates(lon: 1, lat: 1)
    
    let mockCity = City(
        id: UUID(),
        _id: 12345,
        name: "Mock City",
        country: "MC",
        coord: City.Coordinates(lon: -58.456, lat: -34.678),
        isFavorite: true
    )

    CityDetailView(viewModel: CityDetailViewModel(city: mockCity))
}
