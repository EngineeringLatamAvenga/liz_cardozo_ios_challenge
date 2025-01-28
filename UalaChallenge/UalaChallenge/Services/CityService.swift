//
//  CityService.swift
//  UalaChallenge
//
//  Created by Liz Fabiola Isasi Cardozo on 27/01/2025.
//

import Foundation

enum CityServiceError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case unknownError
}

protocol CityServiceProtocol {
    func fetchCities(completion: @escaping (Result<[City], CityServiceError>) -> Void)
}

class CityService: CityServiceProtocol {
    func fetchCities(completion: @escaping (Result<[City], CityServiceError>) -> Void) {
        let stringUrl = "https://gist.githubusercontent.com/hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json"
        guard let url = URL(string: stringUrl) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.networkError(error)))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.unknownError))
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let cities = try decoder.decode([City].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(cities))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.decodingError(error)))
                }
            }
        }.resume()
    }
}
