//
//  CityDetailViewModel.swift
//  UalaChallenge
//
//  Created by Liz Fabiola Isasi Cardozo on 27/01/2025.
//

import Foundation

class CityDetailViewModel: ObservableObject {
    var city: City
    
    init(city: City) {
        self.city = city
    }
}
