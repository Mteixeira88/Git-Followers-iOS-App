//
//  Follower.swift
//  GitFollowers
//
//  Created by Miguel Teixeira on 03/01/2020.
//  Copyright © 2020 Miguel Teixeira. All rights reserved.
//

import Foundation

// Because it performs to Codable, the variable names have to be exatly the same as the server response
struct Follower: Codable, Hashable {
    var login: String
    //On the response it comes "avatar_url" but the Swift Code Best Practices
    // says to use camelCase instead of snake_case,
    // JSON decoder will convert automatically the snake_case's to camelCase's
    // but the variable name must have the exact same name
    var avatarUrl: String
    
    // Convert to unique id
    func hash(into hasher: inout Hasher) {
        hasher.combine(login)
    }
}
