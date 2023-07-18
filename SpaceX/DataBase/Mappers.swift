//
//  Mappers.swift
//  SpaceX
//
//  Created by Helia Fathi on 7/14/23.
//

import Foundation

extension DataBaseProvider {
    
    func mapToMissionObjects(_ launchList: [MarkMissionModel]) -> [LaunchRealm] {
        return launchList.compactMap { launch in
            let realmLaunch = LaunchRealm()
            realmLaunch.flightNumber = launch.flightNumber
            return realmLaunch
        }
    }
    
    func mapToMissionModels(launchRealms: [LaunchRealm]) -> [MarkMissionModel] {
        return launchRealms.map { MarkMissionModel(flightNumber: $0.flightNumber) }
    }
}
