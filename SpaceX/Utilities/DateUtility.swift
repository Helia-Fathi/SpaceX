//
//  DateUtility.swift
//  SpaceX
//
//  Created by Helia Fathi on 7/18/23.
//

import Foundation

protocol DateFormatterProtocol {
    func formatDate(from originalDateString: String) -> String?
}

class DateUtility: DateFormatterProtocol {
    func formatDate(from originalDateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = dateFormatter.date(from: originalDateString) else { return nil }
        
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let newDateString = dateFormatter.string(from: date)
        return newDateString
    }
}
