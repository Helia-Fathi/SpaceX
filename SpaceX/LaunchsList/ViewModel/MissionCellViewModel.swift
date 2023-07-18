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
    
    init?(response: [String: Any]) {
        guard let flightNumber = response["flight_number"] as? Int else { return nil }
        self.flightNumber = "Flight \(flightNumber)"
        self.details = response["details"] as? String ?? "No details available"
        self.success = response["success"] as? Bool ?? false
        if let links = response["links"] as? [String: Any], let patch = links["patch"] as? [String: String] {
            self.smallImageURL = patch["small"]
        } else {
            self.smallImageURL = nil
        }
        self.dateUTC = response["date_utc"] as? String
        self.isMarked = true
    }
}
