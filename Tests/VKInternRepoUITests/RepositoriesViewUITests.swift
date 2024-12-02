//
//  RepositoriesViewUITests.swift
//  VKInternRepoUITests
//
//  Created by Станислав Никулин on 02.12.2024.
//

import XCTest

final class RepositoriesViewUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testRepositoriesViewLoads() throws {
        let app = XCUIApplication()
        app.launch()

        let repositoriesList = app.scrollViews.firstMatch
        XCTAssertTrue(repositoriesList.waitForExistence(timeout: 5), "Список репозиториев не загрузился вовремя")
    }
}
