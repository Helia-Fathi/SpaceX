//
//  LaunchListViewModel.swift
//  SpaceX
//
//  Created by Helia Fathi on 7/14/23.
//

import Foundation
import Combine

//class LaunchViewModel: ObservableObject {
//    @Published var launchData: [MissionCellViewModel] = []
//    @Published var isLoading = false
//
//    var cancellables: Set<AnyCancellable> = []
//    @Inject private var launchRepository: LaunchRepositoryProtocol
//
//
//    func fetchAndSaveLaunches(pageNumber: Int) {
//        launchRepository.fetchAndSaveLaunches(pageNumber: pageNumber)
//            .receive(on: DispatchQueue.main)
//            .sink { completion in
//                switch completion {
//                case .failure(let error):
//                    print("An error occurred: \(error)")
//                case .finished:
//                    print("Operation completed successfully.")
//                    self.isLoading = false
////                    self.fetchLaunchesFromDB()
//                }
//            } receiveValue: { _ in }
//            .store(in: &cancellables)
//    }
//
//    func fetchLaunchesFromDB() {
//        self.launchData = launchRepository.fetchLaunchesFromDB()!
//    }
//}

class LaunchViewModel: ObservableObject {
    @Published var launchData: [MissionCellViewModel] = []
    @Published var isLoading = false

    var cancellables: Set<AnyCancellable> = []
    @Inject private var launchRepository: LaunchRepositoryProtocol

    init() {
        fetchLaunches()
    }
        
    func fetchLaunches() {
        isLoading = true
        launchRepository.fetchLaunchesFromDbOrServer()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    print("An error occurred: \(error)")
                case .finished:
                    print("Operation completed successfully.")
                }
            } receiveValue: { [weak self] data in
                self?.launchData = data
            }
            .store(in: &cancellables)
    }
}

