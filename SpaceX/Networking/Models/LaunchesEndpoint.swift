//
//  LaunchesEndpoint.swift
//  SpaceX
//
//  Created by Helia Fathi on 7/13/23.
//

import Foundation

enum LaunchesEndpoint: APIEndpoint {
    case fetchLaunches(query: [String: Any])
    
    var path: String {
        switch self {
        case .fetchLaunches:
            return "/launches/query"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchLaunches:
            return .post
        }
    }
    
    var headers: [String : String] {
        return ["Content-Type": "application/json"]
    }
    
    var body: Data? {
        switch self {
        case let .fetchLaunches(query):
            return try? JSONSerialization.data(withJSONObject: query)
        }
    }
}
