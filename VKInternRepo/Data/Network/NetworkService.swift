//
//  NetworkService.swift
//  VKInternRepo
//
//  Created by Станислав Никулин on 29.11.2024.
//

import Foundation

class NetworkService {
    
    func fetchData<T: Decodable>(
        url: URL
    ) async throws -> T {
        let (data, _) = try await URLSession.shared.data(from: url)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let decodedData = try jsonDecoder.decode(T.self, from: data)
        return decodedData
    }
}
