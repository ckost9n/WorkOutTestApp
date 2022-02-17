//
//  Date + Extension.swift
//  WorkOutTestApp
//
//  Created by Konstantin on 30.01.2022.
//

import Foundation

extension Date {
    
    func localDate() -> Date {
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: self))
        let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: self) ?? Date()
        return localDate
    }
    
    func getWeekdayNumber() -> Int {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: self)
        return weekday
    }
    
    func startEndDate() -> (Date, Date) {
        
        let formater = DateFormatter()
        formater.dateFormat = "yyyy/MM/dd"
        
        let calendar = Calendar.current
        let day = calendar.component(.day, from: self)
        let month = calendar.component(.month, from: self)
        let year = calendar.component(.year, from: self)
        
        let dateStart = formater.date(from: "\(year)/\(month)/\(day)") ?? Date()
        
        let local = dateStart.localDate()
        let dateEnd: Date = {
            let components = DateComponents(day: 1)
            return Calendar.current.date(byAdding: components, to: local) ?? Date()
        }()
        
        return (local, dateEnd)
    }
    
    func offsetDays(days: Int) -> Date {
        let offsetDay = Calendar.current.date(byAdding: .day, value: -days, to: self) ?? Date()
        return offsetDay
    }
    
    func offsetMonth(month: Int) -> Date {
        let offsetDay = Calendar.current.date(byAdding: .month, value: -month, to: self) ?? Date()
        return offsetDay
    }
    
    func getWeekArray() -> [[String]] {
        
        let formater = DateFormatter()
        formater.locale = Locale(identifier: "ru_RU")
        formater.dateFormat = "EEEEEE"
        
        var weekArray: [[String]] = [[], []]
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        
        for weekdayNumber in -6...0 {
            let date = calendar.date(byAdding: .weekday, value: weekdayNumber, to: self) ?? Date()
            let day = calendar.component(.day, from: date)
            weekArray[1].append("\(day)")
            let weekday = formater.string(from: date)
            weekArray[0].append(weekday)
        }
        return weekArray
    }
    
    func getDateDayMMyyyy() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let date = formatter.string(from: self)
        return date
    }
    
}
