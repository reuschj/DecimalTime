//
//  Date.swift
//
//
//  Created by Justin Reusch on 5/1/20.
//

import Foundation

extension Date {
    
    /// Gets date components from date using a calendar
    func dateComponents(_ components: Set<Calendar.Component>, from calendar: Calendar = Calendar.current) -> DateComponents {
        calendar.dateComponents(components, from: self)
    }
    
    /// Gets decimal time from date using a calendar
    func decimalTime(from calendar: Calendar = Calendar.current) -> DecimalTime? {
        DecimalTime(from: self, using: calendar)
    }
    
    // Static function to get a date for midnight a given day
    static func getMidnightOf(date: Date = Date(), from calendar: Calendar = Calendar.current) -> Date? {
        let dateComponents = date.dateComponents([.year, .month, .day, .timeZone])
        return calendar.date(from: dateComponents)
    }
    
    
    // Static function to get a date for midnight of the current day
    static func getMidnightOfCurrentDay(from calendar: Calendar = Calendar.current) -> Date? {
        return Date.getMidnightOf(date: Date(), from: calendar)
    }
    
    // Calculates the time interval in seconds of the current time from midnight of the same day
    func timeIntervalSinceMidnight(from calendar: Calendar = Calendar.current) -> TimeInterval? {
        guard let midnight = Date.getMidnightOf(date: self, from: calendar) else { return nil }
        return self.timeIntervalSince(midnight)
    }
}
