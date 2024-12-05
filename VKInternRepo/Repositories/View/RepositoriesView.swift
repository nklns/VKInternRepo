//
//  RepositoriesView.swift
//  VKInternRepo
//
//  Created by Станислав Никулин on 29.11.2024.
//

import SwiftUI
import SwiftData

struct RepositoriesView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var interactor = RepositoriesInteractor()
    @State private var showAlert = false

    @Query private var items: [RepositoryEntity]

    var body: some View {
        NavigationStack {
            ScrollView {
                content
                    .onAppear {
                        interactor.modelContext = context
                    }
                    .padding(.top)
            }
            .navigationTitle("Repositories")
            .scrollIndicators(.hidden)
            .onChange(of: interactor.canLoadMorePages) { (_, newValue) in
                if !newValue, !interactor.isLoading {
                    showAlert = true
                }
            }
            .alert("No repositories available.", isPresented: $showAlert) { }
        }
    }
}

private extension RepositoriesView {
    var content: some View {
        LazyVStack {
            repositoryList
            
            if interactor.isLoading {
                ProgressView()
                    .padding()
            }
        }
    }
    
    var repositoryList: some View {
        ForEach(items) { item in
            RepositoryRow(repository: item, interactor: interactor) {
                interactor.deleteRepository(item)
            }
            .onAppear {
                interactor.loadMoreContent(currentItem: item)
            }
        }
    }
}
