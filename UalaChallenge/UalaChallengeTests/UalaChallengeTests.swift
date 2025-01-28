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
        let expectation = XCTestExpectation(description: "Fetch cities from mock service")
        
        // Act
        viewModel.fetchCities()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Assert
            XCTAssertEqual(self.viewModel.cities.count, 3)
            XCTAssertEqual(self.viewModel.cities[0].name, "Mockville")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }

    
    @MainActor
    func testFilterCitiesBySearchText() {
        // Arrange
        let expectation = XCTestExpectation(description: "Fetch cities and filter by search text")
        viewModel.fetchCities()

        // Act
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
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
        let expectation = XCTestExpectation(description: "Fetch cities and filter by favorites only")
        viewModel.fetchCities()
        
        // Act
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewModel.cities[0].isFavorite = true
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
    func fetchCities(completion: @escaping ([City]) -> Void) {
        print("Using MockCityService") // Log para confirmar el mock
        let mockCities = [
            City(_id: 1, name: "Mockville", country: "MV", coord: City.Coordinates(lon: 10, lat: 20)),
            City(_id: 2, name: "Example City", country: "EX", coord: City.Coordinates(lon: 30, lat: 40)),
            City(_id: 3, name: "Testopolis", country: "TP", coord: City.Coordinates(lon: 50, lat: 60))
        ]
        completion(mockCities)
    }

}
