//
//  Item.swift
//  VKInternRepo
//
//  Created by Станислав Никулин on 29.11.2024.
//

import Foundation
import SwiftData
import SwiftUICore

@Model
final class RepositoryEntity {
    @Attribute(.unique)
    var id: Int64
    var name: String
    var itemDescription: String?
    var imageData: Data?
    
    init(id: Int64, name: String, itemDescription: String? = nil, imageData: Data? = nil) {
        self.id = id
        self.name = name
        self.itemDescription = itemDescription
        self.imageData = imageData
    }
}
