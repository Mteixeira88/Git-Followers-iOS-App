//
//  NetworkManager.swift
//  GitFollowers
//
//  Created by Miguel Teixeira on 06/01/2020.
//  Copyright © 2020 Miguel Teixeira. All rights reserved.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://api.github.com/users/"
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func getFollowers(for username: String, page: Int, completed: @escaping(Result<[Follower], GFError>) -> Void) {
        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"
        
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
            
            let followers: [Follower] = self.genericDecodable(data: data)
            completed(.success(followers))
        }
        
        task.resume()
    }
    
    func getUserInfo(for username: String, completed: @escaping(Result<User, GFError>) -> Void) {
        let endpoint = baseURL + "\(username)"
        
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
            
            let user: User = self.genericDecodable(data: data)
            completed(.success(user))
        }
        
        task.resume()
    }
    
    func genericDecodable<T: Codable>(data: Data) -> T {
        let decoder = JSONDecoder()
        // Convert data from snake case to camel case
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        guard let result = try? decoder.decode(T.self, from: data) else {
            fatalError("Something went wrong")
        }
        return result
        
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
