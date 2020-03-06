//
//  NetworkManager.swift
//  GitFollowers
//
//  Created by Miguel Teixeira on 06/01/2020.
//  Copyright © 2020 Miguel Teixeira. All rights reserved.
//

import UIKit

enum GFError: String, Error {
    case invalidUsername = "This username created an invalid request. Please try again"
    case unableToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidResponse = "Invalid response from the server. Please try again"
    case dataInvalid = "Data received invalid. Please try again"
    case unableToFavorite = "There was an error favoriting this user. Try again."
    case alreadyFavorite = "Already in favorites. You must really like them."
}

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://api.github.com/users/"
    let cache = NSCache<NSString, UIImage>()
    
    func genericGet<T: Codable>(for: T.Type = T.self, url: String, completed: @escaping(Result<T, GFError>) -> Void) {
        let endpoint = baseURL + url
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUsername))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.dataInvalid))
                return
            }
            
            let decoder = JSONDecoder()
            // Convert data from snake case to camel case
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601
            guard let result = try? decoder.decode(T.self, from: data) else {
                fatalError("Something went wrong")
            }
            
            completed(.success(result))
        }
        
        task.resume()
    }
    
    func dowloadImage(from urlString: String, completed: @escaping(UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
            guard let self = self,
                error == nil,
                let response = response as? HTTPURLResponse, response.statusCode == 200,
                let data = data,
                let image = UIImage(data: data) else {
                    completed(nil)
                    return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        })
        
        task.resume()
    }
    
}
