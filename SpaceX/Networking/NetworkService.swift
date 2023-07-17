//
//  NetworkService.swift
//  SpaceX
//
//  Created by Helia Fathi on 7/13/23.
//


import Foundation
import Combine

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ endpoint: APIEndpoint) -> AnyPublisher<T, APIError>
//    func request<T: Decodable>(_ endpoint: APIEndpoint, completion: @escaping (Result<T, APIError>) -> Void)
    
}

class NetworkService: NetworkServiceProtocol {
    private let urlSession: URLSession
    private let baseURL: URL
    
    init(baseURL: URL = URL(string: APIConfiguration.baseURL)!, urlSession: URLSession = .shared) {
        self.baseURL = baseURL
        self.urlSession = urlSession
    }
    
    func request<T: Decodable>(_ endpoint: APIEndpoint) -> AnyPublisher<T, APIError> {
        let url = baseURL.appendingPathComponent(endpoint.path)

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        request.httpBody = endpoint.body
        request.timeoutInterval = TimeInterval(120)

        return urlSession.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse else {
                    throw APIError.noResponse
                }

                guard (200...299).contains(response.statusCode) else {
                    switch response.statusCode {
                    case 400: throw APIError.badRequest
                    case 401: throw APIError.unauthorized
                    case 404: throw APIError.notFound
                    case 500: throw APIError.internalServerError
                    case 503: throw APIError.serverDown
                    default: throw APIError.unknown
                    }
                }
                print("khoda : \(output.data)")
                let json = try JSONSerialization.jsonObject(with: output.data, options: [])
                print("ey babababa", json)

                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { $0 as? APIError ?? APIError.unknown }
            .eraseToAnyPublisher()
    }
}
