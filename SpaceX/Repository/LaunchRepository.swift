//
//  LaunchRepository.swift
//  SpaceX
//
//  Created by Helia Fathi on 7/14/23.
//

import Foundation
import Combine

protocol LaunchRepositoryProtocol {
    func fetchAndSaveLaunches(pageNumber: Int) -> AnyPublisher<Void, APIError>
//    func fetchLaunchesFromDB() -> AnyPublisher<[MissionCellViewModel], Never>
    func fetchLaunchesFromDB() -> [MissionCellViewModel]?
//    func fetchAndSaveLaunches(pageNumber: Int)
}

class LaunchRepository: LaunchRepositoryProtocol {
    
    @Inject var databaseManager: DataBaseProviderProtocol
    @Inject var networkService: NetworkServiceProtocol

    func fetchAndSaveLaunches(pageNumber: Int) -> AnyPublisher<Void, APIError> {
        let query = [
            "query": ["upcoming": false],
            "options": ["limit": 10, "page": pageNumber, "sort": ["flight_number": "desc"]]
        ]

        return networkService.request(LaunchesEndpoint.fetchLaunches(query: query))
            .flatMap { (launches: SpaceXResponse) -> Future<Void, APIError> in
                return Future { promise in
                    do {
                        try self.databaseManager.saveLaunches(launches: [launches])
                        promise(.success(()))
                    } catch {
                        print("Database saving error: \(error)")
                        promise(.failure(.notFound)) // Assuming you have a .databaseError in APIError
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
//
    func fetchLaunchesFromDB() -> [MissionCellViewModel]? {
        do {
            let launchRealms = try self.databaseManager.fetchLaunches()
            return launchRealms
        } catch {
            print("Database fetching error: \(error)")
        }
    }

}

