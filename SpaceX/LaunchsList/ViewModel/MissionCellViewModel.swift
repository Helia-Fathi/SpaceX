//
//  MissionCellViewModel.swift
//  SpaceX
//
//  Created by Helia Fathi on 7/14/23.
//

import Foundation

struct MissionCellViewModel {
    let flightNumber: String
    let name: String
    let details: String
    let success: Bool
    let smallImageURL: String?
    let mainImage: String?
    let dateUTC: String?
    let isMarked: Bool
    let wikipedia: String?
    
    init?(response: [String: Any]) {
        guard let flightNumber = response["flight_number"] as? Int else { return nil }
        self.flightNumber = "Flight \(flightNumber)"
        self.name = response["name"] as? String ?? "No Name"
        self.details = response["details"] as? String ?? "No details available"
        self.success = response["success"] as? Bool ?? false
        if let links = response["links"] as? [String: Any] {
            self.wikipedia = links["wikipedia"] as? String
            if let patch = links["patch"] as? [String: String] {
                self.smallImageURL = patch["small"]
                self.mainImage = patch["large"]
            } else {
                self.smallImageURL = nil
                self.mainImage = nil
            }
        } else {
            self.smallImageURL = nil
            self.mainImage = nil
            self.wikipedia = nil
        }
        self.dateUTC = response["date_utc"] as? String
        self.isMarked = false
    }
}
