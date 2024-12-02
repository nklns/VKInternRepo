//
//  NetworkServiceTests.swift
//  VKInternRepoTests
//
//  Created by Станислав Никулин on 02.12.2024.
//

import XCTest
@testable import VKInternRepo

final class NetworkServiceTests: XCTestCase {
    var networkService: NetworkService!

    override func setUp() {
        super.setUp()
        networkService = NetworkService()
    }

    override func tearDown() {
        networkService = nil
        super.tearDown()
    }

    func testFetchDataSuccess() async throws {
        let url = URL(string: "https://api.github.com/search/repositories?q=swift&sort=stars&order=asc&page=1")!
        var request = URLRequest(url: url)
        print(Constants.apiKey)
        request.setValue("token \(Constants.apiKey)", forHTTPHeaderField: "Authorization")

        do {
            let response: GitHubResponse = try await networkService.fetchData(urlRequest: request)
            XCTAssertFalse(response.items.isEmpty, "Ожидались элементы, но массив пуст")
        } catch {
            XCTFail("Ожидался успех, но получена ошибка: \(error)")
        }
    }

    func testFetchDataInvalidURL() async {
        let url = URL(string: "invalid_url")!
        let request = URLRequest(url: url)

        do {
            let _: GitHubResponse = try await networkService.fetchData(urlRequest: request)
            XCTFail("Ожидалась ошибка, но получен успех")
        } catch {
            XCTAssert(true)
        }
    }
}
