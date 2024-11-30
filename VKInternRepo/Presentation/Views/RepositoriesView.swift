//
//  RepositoriesView.swift
//  VKInternRepo
//
//  Created by Станислав Никулин on 29.11.2024.
//

import SwiftUI

struct RepositoriesView: View {
    @StateObject private var viewModel = RepositoriesViewModel()
    
    var body: some View {
        Text("Hello world")
        List {
            ForEach (viewModel.repositories) { repository in
                Text(repository.name)
                    .onAppear(perform: {
                        viewModel.loadMoreContent(currentItem: repository)
                    })
                .frame(maxWidth: .infinity)
                
            }
            .onDelete { indexes in
                
            }
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            }
        }
    }
}

#Preview {
    RepositoriesView()
}
