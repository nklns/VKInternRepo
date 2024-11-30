//
//  NetworkService.swift
//  VKInternRepo
//
//  Created by Станислав Никулин on 29.11.2024.
//

import Foundation

class NetworkService {
    
    func fetchData<T: Decodable>(
        urlRequest: URLRequest
    ) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("Error: HTTP \(httpResponse.statusCode)")
        }
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let decodedData = try jsonDecoder.decode(T.self, from: data)
        return decodedData
    }
}
