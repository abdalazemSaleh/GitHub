//
//  NetworkManger.swift
//  GitHub
//
//  Created by Abdalazem Saleh on 2022-09-17.
//

import UIKit

class NetworkManger {
    
    static let share = NetworkManger()
    private let baseUrl = "https://api.github.com/users/"
    let cach = NSCache<NSString, UIImage>()
    
    
    private init() { }
    
    func getFollowers(for username: String, page: Int, completion: @escaping (Result<[Follower], GFErro>) -> Void) {
        let endpoint = baseUrl + "\(username)/followers?per_page=100&page=\(page)"
        /// Chceck url
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidUsername))
            return
        }
        /// Make request
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
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
    
    
    func getUserInfo(for username: String, completion: @escaping (Result<User, GFErro>) -> Void) {
        let endpoint = baseUrl + "\(username)"
        /// Chceck url
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidUsername))
            return
        }
        /// Make request
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
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
                let decoder                     = JSONDecoder()
                decoder.keyDecodingStrategy     = .convertFromSnakeCase
                /// I don't need to convert from string to date
                decoder.dateDecodingStrategy    =  .iso8601
                let user                        = try decoder.decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        
        let cashKey = NSString(string: urlString)
        
        if let image = cach.object(forKey: cashKey) {
            completion(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self ] data, response, error in
            
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data  else {
                completion(nil)
                return
            }
            
            guard let image = UIImage(data: data) else { return }
            self.cach.setObject(image, forKey: cashKey)
            completion(image)
        }
        task.resume()
    }
    
}

