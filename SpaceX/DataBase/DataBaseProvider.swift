//
//  DataBaseProvider.swift
//  SpaceX
//
//  Created by Helia Fathi on 7/13/23.
//

import Foundation

protocol DataBaseProviderProtocol {
    func saveMark(mission: [MarkMissionModel])
    func deleteMark(flightNumber: String)
    func checkIsMark(flightNumber: String) -> Bool
}

class DataBaseProvider: DataBaseProviderProtocol {
    
    @Inject private var dataBaseManager: DataBaseManagerProtocol
    
    func saveMark(mission: [MarkMissionModel]) {
        do {
            let object = mapToMissionObjects(mission)
            try self.dataBaseManager.addObject(objects: object)
        } catch let error as NSError {
            print("Couldn't save to db \(error)")
        }
    }
    
    func deleteMark(flightNumber: String) {
        dataBaseManager.deleteObject(type: LaunchRealm.self, by: String(flightNumber))
    }
    
    func checkIsMark(flightNumber: String) -> Bool {
        let markedMission = dataBaseManager.getObject(type: LaunchRealm.self, key: flightNumber)
        return markedMission != nil
    }
    
}
