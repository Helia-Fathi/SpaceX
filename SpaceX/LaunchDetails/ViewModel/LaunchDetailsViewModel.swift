//
//  LaunchDetailsViewModel.swift
//  SpaceX
//
//  Created by Helia Fathi on 7/15/23.
//

import Foundation

struct LaunchDetailsViewModel {
    let name: String
    let details: String
    let mainImage: String?
    let dateUTC: String?
    let isMarked: Bool
    let wikiLink: String?
}

struct MarkMissionModel {
    let flightNumber: String
}
