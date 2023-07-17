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
    
    init(launch: LaunchRealm) {
        self.name = launch.name
        self.details = launch.details ?? ""
        self.mainImage = launch.mainImages
        self.dateUTC = launch.dateUTC
        self.isMarked = launch.isMarked
        self.wikiLink = launch.wikipedia
    }
}
