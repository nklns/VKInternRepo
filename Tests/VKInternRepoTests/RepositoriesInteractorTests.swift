//
//  RepositoriesInteractorTests.swift
//  VKInternRepoTests
//
//  Created by Станислав Никулин on 02.12.2024.
//

import XCTest
import SwiftData
import Combine
@testable import VKInternRepo

final class RepositoriesInteractorTests: XCTestCase {
    var interactor: RepositoriesInteractor!
    var modelContainer: ModelContainer!
    var schema: Schema!
    var configuration: ModelConfiguration!
    var cancellables = Set<AnyCancellable>()

    @MainActor
    override func setUp() {
        super.setUp()

        schema = Schema([RepositoryEntity.self])
        configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            modelContainer = try ModelContainer(for: schema, configurations: [configuration])
            interactor = RepositoriesInteractor(networkService: MockNetworkService(), modelContext: modelContainer.mainContext)
        } catch {
            XCTFail("Не удалось создать ModelContainer: \(error)")
        }
    }

    override func tearDown() {
        interactor = nil
        modelContainer = nil
        cancellables.removeAll()
        super.tearDown()
    }

    func testLoadMoreContent() async {
        XCTAssertEqual(interactor.currentPage, 1)
        XCTAssertTrue(interactor.canLoadMorePages)

        interactor.loadMoreContent(currentItem: nil)

        try! await Task.sleep(for: .seconds(1))

        XCTAssertEqual(interactor.currentPage, 2)
        XCTAssertFalse(interactor.isLoading)
    }

    func testFetchDataWithError() async {
        let expectation = XCTestExpectation(description: "Waiting for canLoadMorePages to be false")

        interactor.$canLoadMorePages
            .filter { !$0 }
            .first()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)

        interactor.networkService = MockNetworkService(shouldReturnError: true)

        await interactor.fetchData(page: 1)

        await fulfillment(of: [expectation], timeout: 5.0)

        XCTAssertFalse(interactor.canLoadMorePages)
        XCTAssertFalse(interactor.isLoading)
    }
}
