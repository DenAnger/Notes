//
//  DateHelper.swift
//  Notes
//
//  Created by Denis Abramov on 12.03.2021.
//

import Foundation

class DateHelper {
    static func convertDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let customStringDate = formatter.string(from: date)
        let customDate = formatter.date(from: customStringDate)
        formatter.dateFormat = "dd.MM, hh:mm"
        let stringDate = formatter.string(from: customDate!)
        return stringDate
    }
}

extension Date {
    func toSeconds() -> Int64 {
        return Int64((self.timeIntervalSince1970).rounded())
    }
    
    init(seconds: Int64!) {
        self = Date(timeIntervalSince1970: TimeInterval(Double.init(seconds)))
    }
}
