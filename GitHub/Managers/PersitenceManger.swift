//
//  PersitenceManger.swift
//  GitHub
//
//  Created by Abdalazem Saleh on 2022-09-30.
//

import Foundation

enum Key {
    static let favorites = "favorites"
}

enum PresitenceActionType {
    case add, remove
}

enum PersitenceManger {
    
    /// Variables
    static private let defaults = UserDefaults.standard
    
    /// Update favorite list
    static func updateWith(favorite: Follower, actionType: PresitenceActionType, completion: @escaping (GFErro?) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(let favorites):
                var retrievedFavorites = favorites
                print(retrievedFavorites)
                switch actionType {
                case .add:
                    guard !retrievedFavorites.contains(favorite) else {
                        completion(.alreadyInFavorites)
                        return
                    }
                    retrievedFavorites.append(favorite)
                    
                case.remove:
                    retrievedFavorites.removeAll { $0.login == favorite.login }
                }
                
                completion(save(favorites: retrievedFavorites))
                
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    /// Get favorites list
    static func retrieveFavorites(completion: @escaping (Result<[Follower], GFErro>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Key.favorites) as? Data else {
            completion(.success([]))
            return
        }
        
        do {
            let decoder     = JSONDecoder()
            let favorites   = try decoder.decode([Follower].self, from: favoritesData)
            completion(.success(favorites))
        } catch {
            completion(.failure(.unableToFavorite))
        }
    }
    
    /// Set user favorite
    static func save(favorites: [Follower]) -> GFErro? {
        do {
            let encoder = JSONEncoder()
            let encoderFavorites = try encoder.encode(favorites)
            defaults.set(encoderFavorites, forKey: Key.favorites)
            return nil
        } catch {
            return GFErro.unableToFavorite
        }
    }
}
