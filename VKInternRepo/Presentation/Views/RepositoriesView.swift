//
//  RepositoriesView.swift
//  VKInternRepo
//
//  Created by Станислав Никулин on 29.11.2024.
//

import SwiftUI

struct RepositoriesView: View {
    @StateObject private var viewModel = RepositoriesViewModel()
    @State private var showAlert = false
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.repositories) { repository in
                    RepositoryRow(repository: repository)
                        .onAppear {
                            viewModel.loadMoreContent(currentItem: repository)
                        }
                }
                
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                }
            }
            .padding(.top)
        }
        .scrollIndicators(.hidden)
        .onChange(of: viewModel.canLoadMorePages) { (_, newValue) in
            if !newValue, !viewModel.isLoading {
                showAlert = true
            }
        }
        .alert("No repositories available.", isPresented: $showAlert) { }
    }
}

struct RepositoryRow: View {
    let repository: RepositoryModel
    
    var body: some View {
        HStack {
            if let image = repository.image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .padding(.trailing, 10)
            }
            VStack(alignment: .leading) {
                Text(repository.name)
                    .font(.headline)
                
                if let description = repository.description {
                    Text(description)
                        .font(.body)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .padding(.horizontal)
    }
}


#Preview {
    RepositoriesView()
}
