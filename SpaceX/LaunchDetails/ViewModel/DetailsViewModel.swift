//
//  DetailsViewModel.swift
//  SpaceX
//
//  Created by Helia Fathi on 7/18/23.
//

import Foundation

class DetailsViewModel: ObservableObject {
    
    @Inject var dataBase: DataBaseProviderProtocol
    @Inject var formatDate: DateFormatterProtocol
    
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
    
    func formatTheDate(from originalDateString: String) -> String? {
        return formatDate.formatDate(from: originalDateString)
    }
}
