//
//  RepositoriesViewModel.swift
//  VKInternRepo
//
//  Created by Станислав Никулин on 29.11.2024.
//

import Foundation

final class RepositoriesViewModel: ObservableObject {
    @Published var repositories: [Repository] = []
    @Published var isLoading = false
    @Published var canLoadMorePages = true
    
    private let apiKey = "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"
    private var currentPage = 1
    
    private let networkService: NetworkService
    
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
        
        loadMoreContent(currentItem: nil)
    }
    
    func loadMoreContent(currentItem: Repository?) {
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
    
    func fetchData(page: Int) async {
        guard let url = URL(string: "https://api.github.com/search/repositories?q=swift&sort=stars&order=asc&page=\(page)") else { return }
        var request = URLRequest(url: url)
        request.setValue("token \(apiKey)", forHTTPHeaderField: "Authorization")
        
        do {
            let response: GitHubResponse = try await networkService.fetchData(urlRequest: request)
            DispatchQueue.main.async {
                self.repositories.append(contentsOf: response.items)
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
