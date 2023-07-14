//
//  Mappers.swift
//  SpaceX
//
//  Created by Helia Fathi on 7/14/23.
//

import Foundation

extension DataBaseProvider {
    
    func mapToLaunchObjects(_ launchList: [Launch]) -> [LaunchRealm] {
        return launchList.map { luanch in
            let realmLaunch = LaunchRealm()
            realmLaunch.name = luanch.name
            realmLaunch.flightNumber = realmLaunch.flightNumber
            realmLaunch.success = luanch.success
            realmLaunch.smallImageURL = luanch.links.patch.small
            realmLaunch.dateUTC = luanch.date_utc
            realmLaunch.details = luanch.details
            realmLaunch.wikipedia = luanch.links.wikipedia
            realmLaunch.mainImages = luanch.links.flickr.original
            return realmLaunch
        }
    }
    
    func mapToLaunchLists(launchRealm: [LaunchRealm], includeDetails: Bool = false) -> [Launch] {
        return launchRealm.map { realm in
            let flickr = Flickr(small: [], original: includeDetails ? realm.mainImages ?? [] : [])
            let patch = Patch(small: includeDetails ? realm.smallImageURL ?? "" : "", large: "")
            let links = Links(wikipedia: includeDetails ? realm.wikipedia : nil, patch: patch, flickr: flickr)

            return Launch(
                name: realm.name,
                flight_number: realm.flightNumber,
                details: includeDetails ? realm.details : nil,
                success: realm.success,
                links: links,
                date_utc: realm.dateUTC ?? ""
            )
        }
    }
    
}
