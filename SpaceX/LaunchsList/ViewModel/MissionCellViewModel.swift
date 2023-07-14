//
//  MissionCellViewModel.swift
//  SpaceX
//
//  Created by Helia Fathi on 7/14/23.
//

import Foundation

struct MissionCellViewModel {
    let flightNumber: String
    let details: String
    let success: Bool
    let smallImageURL: String?
    let dateUTC: String?
    let isMarked: Bool
    
    init(launch: LaunchRealm) {
        self.flightNumber = String(launch.flightNumber)
        self.details = launch.details ?? ""
        self.success = launch.success
        self.smallImageURL = launch.smallImageURL
        self.dateUTC = launch.dateUTC
        self.isMarked = launch.isMarked
    }
}
