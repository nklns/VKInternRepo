//
//  RepositoryRow.swift
//  VKInternRepo
//
//  Created by Станислав Никулин on 29.11.2024.
//

import SwiftUI
import UIKit

struct RepositoryRow: View {
    let repository: RepositoryEntity
    let interactor: RepositoriesInteractor
    let deleteAction: () -> Void

    var body: some View {
        HStack {
            image
            textStack
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            Spacer()
            deleteButton
            .padding(.leading, 5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
        .padding(.horizontal)
    }
}

private extension RepositoryRow {
    var deleteButton: some View {
        Button {
            deleteAction()
        } label: {
            Image(systemName: "trash.circle.fill")
                .font(.title)
                .foregroundStyle(.red)
        }
    }
    
    var textStack: some View {
        VStack(alignment: .leading) {
            Text(repository.name)
                .font(.headline)

            if let description = repository.itemDescription {
                Text(description)
                    .font(.body)
            }
        }
    }
    
    @ViewBuilder
    var image: some View {
        if let image = interactor.convertDataToImage(repository.imageData) {
            image
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .padding(.trailing, 10)
        }
    }
}
