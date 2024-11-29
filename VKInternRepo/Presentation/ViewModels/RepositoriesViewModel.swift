//
//  RepositoriesViewModel.swift
//  VKInternRepo
//
//  Created by Станислав Никулин on 29.11.2024.
//

import Foundation

final class RepositoriesViewModel: ObservableObject {
    @Published var repositories: [Repository] = []
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
        
        Task {
            await fetchData()
        }
    }
    
    func fetchData() async {
        guard let url = URL(string: "https://api.github.com/search/repositories?q=swift&sort=stars&order=asc&page=1") else { return }
        print("Зашел")
        
        do {
            let response: GitHubResponse = try await networkService.fetchData(url: url)
            DispatchQueue.main.async {
                self.repositories = response.items
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
