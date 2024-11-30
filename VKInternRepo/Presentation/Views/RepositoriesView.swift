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
                    VStack(alignment: .leading) {
                        Text(repository.name)
                            .font(.headline)
                            
                        if repository.description != nil {
                            Text(repository.description!)
                                .font(.body)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .onAppear {
                        viewModel.loadMoreContent(currentItem: repository)
                    }
                    .padding(.horizontal)
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

#Preview {
    RepositoriesView()
}
