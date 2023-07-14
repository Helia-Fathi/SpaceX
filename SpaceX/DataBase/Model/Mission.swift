//
//  Mission.swift
//  SpaceX
//
//  Created by Helia Fathi on 7/13/23.
//

import Foundation
import RealmSwift

class LaunchRealm: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var flightNumber: Int = 0
    @objc dynamic var success: Bool = false
    @objc dynamic var smallImageURL: String?
    @objc dynamic var dateUTC: String?
    @objc dynamic var isMarked: Bool = false
    
    // These will be loaded when the cell is selected
    @objc dynamic var details: String?
    @objc dynamic var wikipedia: String?
    @objc dynamic var mainImages: String?
    
    override static func primaryKey() -> String? {
        return "flightNumber"
    }
}
