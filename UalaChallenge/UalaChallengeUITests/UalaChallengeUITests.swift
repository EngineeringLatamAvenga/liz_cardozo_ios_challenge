//
//  UalaChallengeUITests.swift
//  UalaChallengeUITests
//
//  Created by Liz Fabiola Isasi Cardozo on 27/01/2025.
//

import XCTest

final class CityListUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testToggleFavoritesOnly() throws {
        // Act
        let toggle = app.switches["FavoritesToggle"]
        XCTAssertTrue(toggle.exists, "Favorites toggle should exist")
        
        toggle.tap()
        
        // Assert
        let nonFavoriteCityCell = app.staticTexts["CityRow_2"] 
        XCTAssertFalse(nonFavoriteCityCell.exists, "Non-favorite city should not be visible when toggle is active")
    }
    
}
