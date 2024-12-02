//
//  RepositoriesInteractorTests.swift
//  VKInternRepoTests
//
//  Created by Станислав Никулин on 02.12.2024.
//

import XCTest
import SwiftData
@testable import VKInternRepo

final class RepositoriesInteractorTests: XCTestCase {
    var interactor: RepositoriesInteractor!
    var modelContainer: ModelContainer!
    
    @MainActor
    override func setUp() {
        super.setUp()

        let schema = Schema([RepositoryEntity.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

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
        interactor.networkService = MockNetworkService(shouldReturnError: true)

        await interactor.fetchData(page: 1)

        XCTAssertFalse(interactor.canLoadMorePages)
        XCTAssertFalse(interactor.isLoading)
    }
}

class MockNetworkService: NetworkServiceProtocol {
    var shouldReturnError: Bool

    init(shouldReturnError: Bool = false) {
        self.shouldReturnError = shouldReturnError
    }

    func fetchData<T>(urlRequest: URLRequest) async throws -> T where T : Decodable {
        if shouldReturnError {
            throw NSError(domain: "TestError", code: 1, userInfo: nil)
        }

        let repository = Repository(id: 1, name: "TestRepo", description: "Description", owner: Owner(avatarUrl: ""))
        let response = GitHubResponse(items: [repository])

        return response as! T
    }
}

