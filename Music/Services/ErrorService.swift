//
//  ErrorService.swift
//  Music
//
//  Created by Fran on 17/10/25.
//

import Foundation

enum ErrorService: Error {
    case invalidCredentials
    case invalidURL
    case authenticationFailed
    case decodingFailed(Error)
    case networkError(Error)
    case unauthorized
}
