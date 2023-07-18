//
//  LaunchListViewModel.swift
//  SpaceX
//
//  Created by Helia Fathi on 7/14/23.
//

import Foundation
import Combine

class LaunchViewModel: ObservableObject {
    @Published var launchData: [MissionCellViewModel] = []
    @Published var isLoading = false
    var currentPageNumber = 1
    
    var cancellables: Set<AnyCancellable> = []
    
    @Inject var network: NetworkServiceProtocol
    private var myDispatcher = DispatchQueue.global(qos: .background)
    
    func fetchAndSaveLaunches(completion: @escaping (Result<SpaceXResponse, Error>) -> Void) {
        let query = [
            "query": ["upcoming": false],
            "options": ["limit": 50, "page": currentPageNumber, "sort": ["flight_number": "desc"]]
        ]
        if currentPageNumber <= 4 {
            network.request(endpoint: LaunchesEndpoint.fetchLaunches(query: query)) { [self] result in
                switch result {
                case .success(let data):
                    if let responseString = String(data: data, encoding: .utf8) {
                        guard let responseDictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                            return
                        }
                        if let docs = responseDictionary["docs"] as? [[String: Any]] {
                            for doc in docs {
                                if let missionViewModel = MissionCellViewModel(response: doc){
                                    self.launchData.append(missionViewModel)
                                }
                            }
                        }
                        currentPageNumber += 1
                    } else {
                        print("Response data is not a valid UTF-8 string")
                    }
                case .failure(let error):
                    print("Network request error: \(error)")
                }
            }
        }
    }
}
