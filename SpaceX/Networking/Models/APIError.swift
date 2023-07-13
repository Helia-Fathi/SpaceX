//
//  APIError.swift
//  SpaceX
//
//  Created by Helia Fathi on 7/13/23.
//

import Foundation

enum APIError: Error, CustomStringConvertible {
    case badRequest
    case unauthorized
    case notFound
    case internalServerError
    case serverDown
    case noResponse
    case unknown
    
    var description: String {
        switch self {
        case .badRequest: return "Bad request."
        case .unauthorized: return "Unauthorized."
        case .notFound: return "Not found."
        case .internalServerError: return "Internal server error."
        case .serverDown: return "Server is down."
        case .noResponse: return "No response from the server."
        case .unknown: return "Unknown error occurred."
        }
    }
}
