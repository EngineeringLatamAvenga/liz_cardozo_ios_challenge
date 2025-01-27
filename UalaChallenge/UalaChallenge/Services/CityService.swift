//
//  CityService.swift
//  UalaChallenge
//
//  Created by Liz Fabiola Isasi Cardozo on 27/01/2025.
//

import Foundation

class CityService {
    func fetchCities(completion: @escaping ([City]) -> Void) {
        let stringUrl = "https://gist.githubusercontent.com/hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json"
        guard let url = URL(string: stringUrl) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let cities = try decoder.decode([City].self, from: data)
                    DispatchQueue.main.async {
                        completion(cities)
                    }
                } catch {
                    print("Error decoding cities: \(error)")
                }
            }
        }.resume()
    }
}

