//
//  UalaChallengeTests.swift
//  UalaChallengeTests
//
//  Created by Liz Fabiola Isasi Cardozo on 27/01/2025.
//

import XCTest
@testable import UalaChallenge

final class CityViewModelTests: XCTestCase {
    var viewModel: CityViewModel!
    var mockCityService: MockCityService!
    
    override func setUp() {
        super.setUp()
        mockCityService = MockCityService()
        viewModel = CityViewModel(cityService: mockCityService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockCityService = nil
        super.tearDown()
    }
    
    @MainActor
    func testFetchCities() {
        // Arrange
        let expectation = XCTestExpectation(description: "Fetch cities successfully")
        
        // Act
        viewModel.fetchCities()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Assert
            XCTAssertEqual(self.viewModel.cities.count, 3)
            XCTAssertEqual(self.viewModel.filteredCities.count, 3)
            XCTAssertEqual(self.viewModel.cities[0].name, "Mockville")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    @MainActor
    func testFilterCitiesBySearchText() {
        // Arrange
        viewModel.fetchCities()
        let expectation = XCTestExpectation(description: "Filter cities by search text")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Act
            self.viewModel.searchText = "Mock"
            self.viewModel.updateFilterCities()
            
            // Assert
            XCTAssertEqual(self.viewModel.filteredCities.count, 1)
            XCTAssertEqual(self.viewModel.filteredCities[0].name, "Mockville")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    @MainActor
    func testFilterCitiesByFavoritesOnly() {
        // Arrange
        viewModel.fetchCities()
        let expectation = XCTestExpectation(description: "Filter cities by favorites")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Act
            self.viewModel.showFavoritesOnly = true
            self.viewModel.updateFilterCities()
            
            // Assert
            XCTAssertEqual(self.viewModel.filteredCities.count, 1)
            XCTAssertTrue(self.viewModel.filteredCities[0].isFavorite)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
}


class MockCityService: CityServiceProtocol {
    func fetchCities(completion: @escaping (Result<[City], CityServiceError>) -> Void) {
        let mockCities = [
            City(_id: 1, name: "Mockville", country: "MV", coord: City.Coordinates(lon: 10, lat: 20), isFavorite: false),
            City(_id: 2, name: "Example City", country: "EX", coord: City.Coordinates(lon: 30, lat: 40), isFavorite: false),
            City(_id: 3, name: "Testopolis", country: "TP", coord: City.Coordinates(lon: 50, lat: 60), isFavorite: true)
        ]
        completion(.success(mockCities))
    }
}
