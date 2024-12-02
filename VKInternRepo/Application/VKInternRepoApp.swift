//
//  VKInternRepoApp.swift
//  VKInternRepo
//
//  Created by Станислав Никулин on 29.11.2024.
//

import SwiftUI
import SwiftData

@main
struct VKInternRepoApp: App {
    private var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            RepositoryEntity.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RepositoriesView()
        }
        .modelContainer(sharedModelContainer)
    }
}
