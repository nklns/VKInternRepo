//
//  MockNetworkService.swift
//  VKInternRepoTests
//
//  Created by Станислав Никулин on 02.12.2024.
//

import Foundation
@testable import VKInternRepo // Импортируйте ваш основной модуль, если вы используете Mock в тестах

final class MockNetworkService: NetworkServiceProtocol {
    var shouldReturnError: Bool

    init(shouldReturnError: Bool = false) {
        self.shouldReturnError = shouldReturnError
    }

    func fetchData<T>(urlRequest: URLRequest) async throws -> T where T: Decodable {
        if shouldReturnError {
            throw NSError(domain: "TestError", code: 1, userInfo: nil)
        }

        let repository = Repository(id: 1, name: "TestRepo", description: "Description", owner: Owner(avatarUrl: ""))
        let response = GitHubResponse(items: [repository])

        return response as! T
    }
}
