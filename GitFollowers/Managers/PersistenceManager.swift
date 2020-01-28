//
//  PersistenceManager.swift
//  GitFollowers
//
//  Created by Miguel Teixeira on 28/01/2020.
//  Copyright © 2020 Miguel Teixeira. All rights reserved.
//

import Foundation

enum PersistanceActionType {
    case add, remove
}

enum PersinstanceManager {
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favorites = "favorites"
    }
    
    static func updateWith(favorite: Follower, actionType: PersistanceActionType, completed: @escaping(GFError?) -> Void) {
        retrieveFavorites { (result) in
            switch result {
            case .success(let favorites):
                var retirevedFavorites = favorites
                switch actionType {
                case .add:
                    guard !retirevedFavorites.contains(favorite) else {
                        completed(.alreadyFavorite)
                        return
                    }
                    retirevedFavorites.append(favorite)
                case .remove:
                    retirevedFavorites.removeAll(where: { $0.login == favorite.login})
                }
                completed(saveFavorites(favorites: retirevedFavorites))
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    static func retrieveFavorites(completed: @escaping(Result<[Follower], GFError>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            completed(.failure(.unableToFavorite))
        }
    }
    
    static func saveFavorites(favorites: [Follower]) -> GFError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToFavorite
        }
    }
}
