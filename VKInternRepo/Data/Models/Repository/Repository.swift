//
//  Repository.swift
//  VKInternRepo
//
//  Created by Станислав Никулин on 30.11.2024.
//

import Foundation
import SwiftUICore

struct RepositoryModel: Identifiable {
    let id: Int
    let name: String
    let description: String?
    let image: Image?
}
