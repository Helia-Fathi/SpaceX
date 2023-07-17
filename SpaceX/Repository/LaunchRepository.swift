//
//  LaunchRepository.swift
//  SpaceX
//
//  Created by Helia Fathi on 7/14/23.
//

import Foundation
import Combine

protocol LaunchRepositoryProtocol {
//    func fetchAndSaveLaunches(pageNumber: Int) -> AnyPublisher<Void, APIError>
    func fetchLaunchesFromDbOrServer() -> AnyPublisher<[MissionCellViewModel], APIError>
//    func fetchLaunchesFromDB() -> AnyPublisher<[MissionCellViewModel], Never>
//    func fetchLaunchesFromDB() -> [MissionCellViewModel]?
//    func fetchAndSaveLaunches(pageNumber: Int)
}

class LaunchRepository: LaunchRepositoryProtocol {
    
    
    @Inject var databaseManager: DataBaseProviderProtocol
    @Inject var networkService: NetworkServiceProtocol

    private var currentDbPage: Int = 0
    private var currentPage: Int = 1
    private var apiCallsCount: Int = 0
    private let maxApiCalls: Int = 4
    
    private func fetchAndSaveLaunches(pageNumber: Int) -> AnyPublisher<Void, APIError> {
        let query = [
            "query": ["upcoming": false],
            "options": ["limit": 50, "page": pageNumber, "sort": ["flight_number": "desc"]]
        ]
        
        return networkService.request(LaunchesEndpoint.fetchLaunches(query: query))
            .flatMap { (launches: SpaceXResponse) -> Future<Void, APIError> in
                return Future { promise in
                    do {
                        self.databaseManager.saveLaunches(launches: [launches])
                        promise(.success(()))
                    } catch {
                        print("Database saving error: \(error)")
                        promise(.failure(.notFound))
                    }
                }
            }
            .eraseToAnyPublisher()
    }

    
    func fetchLaunchesFromDbOrServer() -> AnyPublisher<[MissionCellViewModel], APIError> {
            return Future { [weak self] promise in
                let launches = self?.databaseManager.fetchLaunches(offset: self?.currentDbPage ?? 0, limit: 20)
                if launches?.count == 20 {
                    self?.currentDbPage += 20
                    promise(.success(launches!))
                } else {
                    if self?.apiCallsCount ?? 0 < self?.maxApiCalls ?? 0 {
                        self?.fetchAndSaveLaunches(pageNumber: self?.currentPage ?? 1)
                            .sink { completion in
                                switch completion {
                                case .failure(let error):
                                    promise(.failure(error))
                                case .finished:
                                    self?.currentPage += 1
                                    self?.apiCallsCount += 1
                                    self?.fetchLaunchesFromDbOrServer()
                                }
                            } receiveValue: { _ in }
                    } else {
                        promise(.failure(.unknown))
                    }
                }
            }
            .eraseToAnyPublisher()
        }

//    func fetchLaunchesFromDB() -> AnyPublisher<[MissionCellViewModel], Never> {
//        return Future { [weak self] promise in
//                do {
//                    guard let self = self else { return }
//                    let launchRealms = try self.databaseManager.fetchLaunches()
//                    promise(.success(launchRealms))
//                } catch {
//                    print("Database fetching error: \(error)")
//                }
//            }
//        .eraseToAnyPublisher()
//    }

//    func fetchLaunchesFromDB() -> [MissionCellViewModel]? {
//        do {
//            let launchRealms = try self.databaseManager.fetchLaunches()
//            return launchRealms
//        } catch {
//            print("Database fetching error: \(error)")
//        }
    

}

