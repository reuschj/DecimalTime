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
    
    // Calculates the time interval in seconds of the current time from midnight of the same day
    func timeIntervalSinceMidnight(from calendar: Calendar = Calendar.current) -> TimeInterval? {
        let now = Date()
        let dateComponents = now.dateComponents([.year, .month, .day, .timeZone])
        guard let midnight = calendar.date(from: dateComponents) else { return nil }
        return now.timeIntervalSince(midnight)
    }
}
