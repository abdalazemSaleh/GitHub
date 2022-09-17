//
//  NetworkManger.swift
//  GitHub
//
//  Created by Abdalazem Saleh on 2022-09-17.
//

import Foundation

class NetworkManger {
    
    static let share = NetworkManger()
    let baseUrl = "https://api.github.com/users/"
    
    private init() { }
    
    func getFollowers(for username: String, page: Int, completion: @escaping (Result<[Follower], GFErro>) -> Void) {
        let endpoint = baseUrl + "\(username)/followers?per_page=100&page=\(page)"
        /// Chceck url
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidUsername))
            return
        }
        /// Make request
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            /// Check errors
            if let _ = error {
                completion(.failure(.unableToComplete))
            }
            /// Check response
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            /// Check data
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            /// Parsing data from json
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completion(.success(followers))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        task.resume()
    }
}

