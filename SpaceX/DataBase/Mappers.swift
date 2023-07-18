//
//  Mappers.swift
//  SpaceX
//
//  Created by Helia Fathi on 7/14/23.
//

import Foundation

//extension DataBaseProvider {
//
//    func mapToLaunchObjects(_ launchList: [SpaceXResponse]) -> [LaunchRealm] {
//        return launchList.flatMap { launch in
//            return launch.docs.map { doc in
//                let realmLaunch = LaunchRealm()
//                realmLaunch.name = doc.name
////                realmLaunch.flightNumber = doc.flight_number
//                realmLaunch.success = doc.success ?? false
//                realmLaunch.smallImageURL = doc.links.patch.small
////                realmLaunch.dateUTC = doc.date_utc
////                realmLaunch.details = doc.details
//                realmLaunch.wikipedia = doc.links.wikipedia
////                realmLaunch.mainImages = doc.links.flickr.original.first
//                return realmLaunch
//            }
//        }
//    }
//
//
//    func mapToMissionCellViewModels(launchRealms: [LaunchRealm]) -> [MissionCellViewModel] {
//        return launchRealms.map { MissionCellViewModel(launch: $0) }
//    }
//
//}
