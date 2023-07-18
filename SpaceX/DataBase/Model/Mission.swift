//
//  Mission.swift
//  SpaceX
//
//  Created by Helia Fathi on 7/13/23.
//

import Foundation
import RealmSwift

class LaunchRealm: Object {
    @objc dynamic var flightNumber: String = ""
    
    override static func primaryKey() -> String? {
        return "flightNumber"
    }
}
