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
    
    private var currentPage = 1
    private var canLoadMorePages = true
    
    private let networkService: NetworkService
    
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
        
        loadMoreContent(currentItem: nil)
    }
    
    func loadMoreContent(currentItem: Repository?) {
        guard !isLoading, canLoadMorePages else {
            return
        }
        
        if let currentItem = currentItem, let last = repositories.last, last.id != currentItem.id {
            return
        }
        
        isLoading = true
        
        Task {
            await fetchData(page: currentPage)
        }
        
        
    }
    
    func fetchData(page: Int) async {
        guard let url = URL(string: "https://api.github.com/search/repositories?q=swift&sort=stars&order=asc&page=\(page)") else { return }
        
        do {
            let response: GitHubResponse = try await networkService.fetchData(url: url)
            DispatchQueue.main.async {
                self.repositories.append(contentsOf: response.items)
                self.currentPage += 1
                self.isLoading = false
            }
        } catch {
            print(error.localizedDescription)
            self.isLoading = false
        }
    }
}
