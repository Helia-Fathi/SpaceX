//
//  APIEndpoint.swift
//  SpaceX
//
//  Created by Helia Fathi on 7/13/23.
//

import Foundation

protocol APIEndpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var body: Data? { get }
}
