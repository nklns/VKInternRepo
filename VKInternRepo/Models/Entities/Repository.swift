//
//  Repository.swift
//  VKInternRepo
//
//  Created by Станислав Никулин on 29.11.2024.
//

import Foundation

struct GitHubResponse: Decodable {
    let items: [Repository]
}

struct Repository: Identifiable, Decodable {
    let id: Int
    let name: String
    let description: String?
    let owner: Owner
}


struct Owner: Decodable {
    let avatarUrl: String
}
