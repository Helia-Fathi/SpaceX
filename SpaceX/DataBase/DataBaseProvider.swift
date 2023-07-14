//
//  DataBaseProvider.swift
//  SpaceX
//
//  Created by Helia Fathi on 7/13/23.
//

import Foundation

protocol DataBaseProviderProtocol {
    func saveLaunches(launches: [SpaceXResponse])
    func fetchLaunches() -> [MissionCellViewModel]
//    func fetchLaunchDetails(flightNumber: Int) -> Launch?
    func markLaunch(flightNumber: Int, isMarked: Bool)
}

class DataBaseProvider: DataBaseProviderProtocol {
    
    @Inject private var dataBaseManager: DataBaseManagerProtocol
    
    func saveLaunches(launches: [SpaceXResponse]) {
        do {
            let object = mapToLaunchObjects(launches)
            try self.dataBaseManager.addObject(objects: object)
        } catch let error as NSError {
            print("Couldn't save to db \(error)")
        }
    }
    
    func fetchLaunches() -> [MissionCellViewModel] {
        var launchList = [MissionCellViewModel]()
        do {
            let launch = try dataBaseManager.fetchAll(type: LaunchRealm.self)
            launchList = mapToMissionCellViewModels(launchRealms: Array(launch!))
            return launchList
        } catch let error as NSError {
            print("\(error.description)")
        }
        return launchList
    }
    
//    func fetchLaunchDetails(flightNumber: Int) -> Launch? {
//        do {
//            if let launchRealm = try dataBaseManager.getObject(type: LaunchRealm.self, key: flightNumber) {
//                let launchList = mapToLaunchLists(launchRealm: [launchRealm], includeDetails: true)
//                return launchList.first
//            }
//        } catch let error as NSError {
//            print("\(error.description)")
//        }
//        return nil
//    }
    
    func markLaunch(flightNumber: Int, isMarked: Bool) {
        if let launch = dataBaseManager.getObject(type: LaunchRealm.self, key: flightNumber) {
            do {
                try dataBaseManager.update {
                    launch.isMarked = isMarked
                }
            } catch let error as NSError {
                print("Couldn't mark launch: \(error)")
            }
        }
    }


}
