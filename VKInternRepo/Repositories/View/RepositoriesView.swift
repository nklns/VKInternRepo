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
        ScrollView {
            LazyVStack {
                ForEach(items) { item in
                    RepositoryRow(repository: item) {
                        deleteRepository(item)
                    }
                    .onAppear {
                        interactor.loadMoreContent(currentItem: item)
                    }
                }

                if interactor.isLoading {
                    ProgressView()
                        .padding()
                }
            }
            .onAppear {
                interactor.modelContext = context
            }
            .padding(.top)
        }
        .scrollIndicators(.hidden)
        .onChange(of: interactor.canLoadMorePages) { (_, newValue) in
            if !newValue, !interactor.isLoading {
                showAlert = true
            }
        }
        .alert("No repositories available.", isPresented: $showAlert) { }
    }

    func deleteRepository(_ repository: RepositoryEntity) {
        context.delete(repository)
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
