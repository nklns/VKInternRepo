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
    @StateObject private var viewModel = RepositoriesViewModel()
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
                        viewModel.loadMoreContent(currentItem: item)
                    }
                }
                
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                }
            }
            .onAppear {
                viewModel.modelContext = context
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
    
    func deleteRepository(_ repository: RepositoryEntity) {
        context.delete(repository)
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct RepositoryRow: View {
    let repository: RepositoryEntity
    let deleteAction: () -> Void
    
    var body: some View {
        HStack {
            if let image = convertDataToImage(repository.imageData) {
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
                
                if let description = repository.itemDescription {
                    Text(description)
                        .font(.body)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            Spacer()
            Button {
                deleteAction()
            } label: {
                Image(systemName: "trash.circle.fill")
                    .font(.title)
                    .foregroundStyle(.red)
                    
            }
            .padding(.leading, 5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
        .padding(.horizontal)
    }
    
    func convertDataToImage(_ data: Data?) -> Image? {
        guard let data = data, let uiImage = UIImage(data: data) else {
            return nil
        }
        return Image(uiImage: uiImage)
    }
}


#Preview {
    RepositoriesView()
}
