//
//  RepositoriesInteractor.swift
//  VKInternRepo
//
//  Created by Станислав Никулин on 02.12.2024.
//

import Foundation
import SwiftUICore
import UIKit
import SwiftData

final class RepositoriesInteractor: ObservableObject {
    @Published var isLoading = false
    @Published var canLoadMorePages = true

    private let apiKey = "YOUR_API_KEY"
    private var currentPage = 1

    private let networkService: NetworkService
    var modelContext: ModelContext?

    init(networkService: NetworkService = NetworkService(), modelContext: ModelContext? = nil) {
        self.networkService = networkService
        self.modelContext = modelContext
        loadMoreContent(currentItem: nil)
    }

    func loadMoreContent(currentItem: RepositoryEntity?) {
        guard !isLoading, canLoadMorePages else { return }
        isLoading = true
        Task {
            await fetchData(page: currentPage)
        }
    }

    @MainActor
    func saveToDatabase(repositories: [RepositoryEntity]) async {
        guard let context = modelContext else { return }
        for repository in repositories {
            context.insert(repository)
        }
        do {
            try context.save()
        } catch {
            print("Error saving to database: \(error.localizedDescription)")
        }
    }

    func downloadImage(from url: URL?) async -> Data? {
        guard let url = url else { return nil }
        guard let (data, _) = try? await URLSession.shared.data(from: url) else { return nil }
        return data
    }

    func fetchData(page: Int) async {
        guard let url = URL(string: "https://api.github.com/search/repositories?q=swift&sort=stars&order=asc&page=\(page)") else { return }
        var request = URLRequest(url: url)
        request.setValue("token \(apiKey)", forHTTPHeaderField: "Authorization")

        do {
            let response: GitHubResponse = try await networkService.fetchData(urlRequest: request)
            let responseConverted = try await withThrowingTaskGroup(of: RepositoryEntity?.self) { group in
                for item in response.items {
                    group.addTask {
                        let imageData = await self.downloadImage(from: URL(string: item.owner.avatarUrl))
                        return RepositoryEntity(id: Int64(item.id), name: item.name, itemDescription: item.description, imageData: imageData)
                    }
                }

                var results = [RepositoryEntity]()
                for try await result in group {
                    if let result = result {
                        results.append(result)
                    }
                }
                return results
            }

            await saveToDatabase(repositories: responseConverted)
            DispatchQueue.main.async {
                self.currentPage += 1
                self.isLoading = false
            }
        } catch {
            print("Error: \(error.localizedDescription)")
            print("Current page: \(currentPage)")
            DispatchQueue.main.async {
                self.canLoadMorePages = false
                self.isLoading = false
            }
        }
    }
}
