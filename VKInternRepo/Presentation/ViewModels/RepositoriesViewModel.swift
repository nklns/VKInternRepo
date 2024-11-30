//
//  RepositoriesViewModel.swift
//  VKInternRepo
//
//  Created by Станислав Никулин on 29.11.2024.
//

import Foundation
import SwiftUICore
import UIKit

final class RepositoriesViewModel: ObservableObject {
    @Published var repositories: [RepositoryModel] = []
    @Published var isLoading = false
    @Published var canLoadMorePages = true
    
    private let apiKey = "YOUR_API_KEY"
    private var currentPage = 1
    
    private let networkService: NetworkService
    
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
        
        loadMoreContent(currentItem: nil)
    }
    
    func loadMoreContent(currentItem: RepositoryModel?) {
        guard !isLoading, canLoadMorePages else {
            return
        }
        
        if let currentItem = currentItem, let last = repositories.last, currentItem.id == last.id  {
            return
        }
        
        isLoading = true
        
        Task {
            await fetchData(page: currentPage)
        }
    }
    
    func downloadImage(from url: URL?) async -> Image? {
        guard let url = url else { return nil }
        guard let (data, _) = try? await URLSession.shared.data(from: url) else { return nil }
        if let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        } else {
            return nil
        }
    }
    
    func fetchData(page: Int) async {
        guard let url = URL(string: "https://api.github.com/search/repositories?q=swift&sort=stars&order=asc&page=\(page)") else { return }
        var request = URLRequest(url: url)
        request.setValue("token \(apiKey)", forHTTPHeaderField: "Authorization")
        
        do {
            let response: GitHubResponse = try await networkService.fetchData(urlRequest: request)
            let responseConverted = try await withThrowingTaskGroup(of: RepositoryModel?.self) { group in
                for item in response.items {
                    group.addTask {
                        let image = await self.downloadImage(from: URL(string: item.owner.avatarUrl))
                        return RepositoryModel(id: item.id, name: item.name, description: item.description, image: image)
                    }
                }
                
                var results = [RepositoryModel]()
                for try await result in group {
                    if let result = result {
                        results.append(result)
                    }
                }
                return results
            }
            
            DispatchQueue.main.async {
                self.repositories.append(contentsOf: responseConverted)
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
