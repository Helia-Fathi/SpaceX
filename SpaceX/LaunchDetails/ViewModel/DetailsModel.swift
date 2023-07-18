//
//  DetailsModel.swift
//  SpaceX
//
//  Created by Helia Fathi on 7/18/23.
//

import Foundation

class DetailsModel: ObservableObject {
    
    @Inject var dataBase: DataBaseProviderProtocol
    
    func saveMissionAsMark(flightNumber: String) {
        let mission = MarkMissionModel(flightNumber: flightNumber)
        self.dataBase.saveMark(mission: [mission])
    }
    
    func deleteMission(flightNumber: String) {
        self.dataBase.deleteMark(flightNumber: flightNumber)
    }
    
    func checkIsMarked(flightNumber: String) -> Bool {
        return self.dataBase.checkIsMark(flightNumber: flightNumber)
    }
    
}
