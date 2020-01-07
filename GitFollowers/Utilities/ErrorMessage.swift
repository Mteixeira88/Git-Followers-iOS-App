//
//  ErrorMessage.swift
//  GitFollowers
//
//  Created by Miguel Teixeira on 06/01/2020.
//  Copyright © 2020 Miguel Teixeira. All rights reserved.
//

import Foundation

enum GFError: String, Error {
    case invalidUsername = "This username created an invalid request. Please try again"
    case unableToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidResponse = "Invalid response from the server. Please try again"
    case dataInvalid = "Data received invalid. Please try again"
}
