//
//  NetworkService.swift
//  SpaceX
//
//  Created by Helia Fathi on 7/13/23.
//


import Foundation
import Combine

protocol NetworkServiceProtocol {
    func request(endpoint: APIEndpoint, completion: @escaping (Result<Data, APIError>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    private let urlSession: URLSession
    private let baseURL: URL
    
    private var myDispatcher = DispatchQueue.global(qos: .background)
    init(baseURL: URL = URL(string: APIConfiguration.baseURL)!, urlSession: URLSession = .shared) {
        self.baseURL = baseURL
        self.urlSession = urlSession
    }
    
    func request(endpoint: APIEndpoint, completion: @escaping (Result<Data, APIError>) -> Void) {
        myDispatcher.async {
            
            let url = self.baseURL.appendingPathComponent(endpoint.path)
            
            var request = URLRequest(url: url)
            request.httpMethod = endpoint.method.rawValue
            request.allHTTPHeaderFields = endpoint.headers
            request.httpBody = endpoint.body
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    if let urlError = error as? URLError {
                        completion(.failure(APIError.unauthorized))
                    } else {
                        completion(.failure(APIError.unknown))
                    }
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(APIError.noResponse))
                    return
                }
                guard (200...299).contains(httpResponse.statusCode) else {
                    switch httpResponse.statusCode {
                    case 400: completion(.failure(APIError.badRequest))
                    case 401: completion(.failure(APIError.unauthorized))
                    case 404: completion(.failure(APIError.notFound))
                    case 500: completion(.failure(APIError.internalServerError))
                    case 503: completion(.failure(APIError.serverDown))
                    default: completion(.failure(APIError.unknown))
                    }
                    return
                }
                
                guard let d = data else {
                    completion(.failure(APIError.unknown))
                    return
                }
                
                completion(.success(d))
            }.resume()
        }
    }
    
}
