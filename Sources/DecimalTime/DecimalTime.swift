//
//  DecimalTime.swift
//
//
//  Created by Justin Reusch on 4/30/20.
//

import Foundation

/**
 Holds a fixed decimal time
 */
public struct DecimalTime: CustomStringConvertible, Comparable, Equatable, Hashable {
    
    public private(set) var date: Date
    public private(set) var calendar: Calendar
    
    // ------------------------- //
    
    public private(set) var hours: Int = 0
    public private(set) var hoursWithRemainder: Double = 0
    //
    public private(set) var minutes: Int = 0
    public private(set) var minutesWithRemainder: Double = 0
    //
    public private(set) var seconds: Int = 0
    public private(set) var secondsWithRemainder: Double = 0
    //
    public private(set) var milliseconds: Int = 0
    public private(set) var millisecondsWithRemainder: Double = 0
    //
    public private(set) var nanoseconds: Int = 0
    public private(set) var nanosecondsWithRemainder: Double = 0
    
    // ------------------------- //
    
    public var decimalTimeIntervalSinceMidnight: DecimalTimeInterval { secondsWithRemainder }
    
    // ------------------------- //
    
    private var dateComponents: DateComponents { date.dateComponents([.year, .month, .weekOfYear, .day, .weekday], from: calendar) }
    
    public var year: Int? { dateComponents.year }
    public var month: Int? { dateComponents.month }
    public var weekOfYear: Int?  { dateComponents.weekOfYear }
    public var day: Int?  { dateComponents.day }
    public var weekday: Int?  { dateComponents.weekday }
    
    // ------------------------- //
    
    static let conversionRatio: Double = 0.864
    static let decimalSecond: TimeInterval = 1 / DecimalTime.conversionRatio
    
    // Computed ------------------------------------ //
    
    /// Gets clock rotations in degrees for each time component
    public var rotation: DecimalTimeRotationComponents {
        let hourRotation = Double(hoursWithRemainder / 10) * 360
        let minuteRotation = Double(minutesWithRemainder / 100) * 360
        let secondRotation = Double(secondsWithRemainder / 100) * 360
        let millisecondRotation = Double(millisecondsWithRemainder / 1_000) * 360
        let nanosecondRotation = Double(nanosecondsWithRemainder / 1_000_000) * 360
        return (hours: hourRotation, minutes: minuteRotation, seconds: secondRotation, milliseconds: millisecondRotation, nanoseconds: nanosecondRotation)
    }
    
    /// Makes a descriptive time string of the decimal time instance
    public var description: String {
        let paddedHours = String(format: "%02d", hours)
        let paddedMinutes = String(format: "%02d", minutes)
        let paddedSeconds = String(format: "%02d", seconds)
        let paddedMilliseconds = String(format: "%03d", milliseconds)
        let paddedNanoseconds = String(format: "%06d", nanoseconds)
        return "Decimal Time: \(paddedHours):\(paddedMinutes):\(paddedSeconds).\(paddedMilliseconds).\(paddedNanoseconds)"
    }
    
    // Initializers ------------------------------------ //
    
    /**
     Inits with a `Date` instance and calendar
     - Parameter date: A `Date` instance  to convert
     - Parameter calendar: The `Calendar` to use - Defaults to current user calendar
     */
    public init?(from date: Date = Date(), using calendar: Calendar = Calendar.current) {
        self.date = date
        self.calendar = calendar
        let success = self.setTime(from: date)
        if !success { return nil }
    }
    
    /**
    Inits with a decimal time interval (in decimal seconds) since midnight
    - Parameter decimalTimeInterval: The amount of decimal seconds since midnight
    - Parameter calendar: The `Calendar` to use - Defaults to current user calendar
    */
    public init?(decimalTimeInterval: DecimalTimeInterval, using calendar: Calendar = Calendar.current) {
        let timeIntervalInStandardSeconds: TimeInterval = decimalTimeInterval.timeInterval
        guard let midnight = Date.getMidnightOfCurrentDay(from: calendar) else { return nil }
        let date = Date(timeInterval: timeIntervalInStandardSeconds, since: midnight)
        self.date = date
        self.calendar = calendar
        guard let (whole, withRemainder) = try? DecimalTime.getDecimalTimeComponents(decimalTimeInterval: decimalTimeInterval, using: calendar) else { return nil }
        _ = self.setTime(wholeComponents: whole, componentsWithRemainder: withRemainder)
    }
    
    /**
     Inits with a time interval (in standard seconds) since midnight
     - Parameter timeInterval: The amount of seconds since midnight
     - Parameter calendar: The `Calendar` to use - Defaults to current user calendar
     */
    public init?(timeInterval: TimeInterval, using calendar: Calendar = Calendar.current) {
        guard let midnight = Date.getMidnightOfCurrentDay(from: calendar) else { return nil }
        let date = Date(timeInterval: timeInterval, since: midnight)
        self.date = date
        self.calendar = calendar
        guard let (whole, withRemainder) = try? DecimalTime.getDecimalTimeComponents(timeInterval: timeInterval, using: calendar) else { return nil }
        _ = self.setTime(wholeComponents: whole, componentsWithRemainder: withRemainder)
    }
    
    /**
     Inits with time components
     - Parameter hours: Amount of whole hours (since midnight)
     - Parameter minutes: Amount of whole minutes (since last hour)
     - Parameter seconds: Amount of whole seconds (since last minute)
     - Parameter milliseconds: Amount of whole milliseconds (since last second)
     - Parameter nanoseconds: Amount of whole nanoseconds (since last millisecond)
     - Parameter calendar: The `Calendar` to use - Defaults to current user calendar
     */
    public init?(hours: Int, minutes: Int = 0, seconds: Int = 0, milliseconds: Int = 0, nanoseconds: Int = 0, using calendar: Calendar = Calendar.current) {
        let decimalMS: Double = Double(milliseconds) + (Double(nanoseconds) / 1_000_000)
        let decimalSeconds: Double = Double(seconds) + (decimalMS / 1_000)
        let decimalMinutes: Double = (decimalSeconds / 100) + Double(minutes)
        let decimalHours: Double = (decimalMinutes / 100) + Double(hours)
        self.init(hourInterval: decimalHours, using: calendar)
    }
    
    /**
     Inits with the amount of decimal hours since midnight
     - Parameter hours: The amount of decimal hours since midnight
     - Parameter calendar: The `Calendar` to use - Defaults to current user calendar
     */
    public init?(hourInterval hours: Double, using calendar: Calendar = Calendar.current) {
        let decimalTimeInterval: DecimalTimeInterval = hours * 100 * 100
        self.init(decimalTimeInterval: decimalTimeInterval, using: calendar)
    }
    
    // Methods ------------------------------------ //
    
    /**
     Sets the time from a `Date` instance
     - Parameter date: A `Date` instance  to convert
     */
    public mutating func setTime(from date: Date = Date()) -> Bool {
        guard let (whole, withRemainder) = DecimalTime.getDecimalTimeComponents(from: date, using: calendar) else { return false }
        return self.setTime(wholeComponents: whole, componentsWithRemainder: withRemainder)
    }
    
    /**
     Sets the time from components
     - Parameter whole: A tuple of whole date components (with remainder truncated)
     - Parameter withRemainder: A tuple of  date components with remainders
     */
    mutating func setTime(wholeComponents whole: WholeDecimalTimeComponents, componentsWithRemainder withRemainder: DecimalTimeComponentsWithRemainder) -> Bool {
        let (hours, minutes, seconds, milliseconds, nanoseconds) = whole
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
        self.milliseconds = milliseconds
        self.nanoseconds = nanoseconds
        //
        let (hoursWithRemainder, minutesWithRemainder, secondsWithRemainder, millisecondsWithRemainder, nanosecondsWithRemainder) = withRemainder
        self.hoursWithRemainder = hoursWithRemainder
        self.minutesWithRemainder = minutesWithRemainder
        self.secondsWithRemainder = secondsWithRemainder
        self.millisecondsWithRemainder = millisecondsWithRemainder
        self.nanosecondsWithRemainder = nanosecondsWithRemainder
        return true
    }
    
    // Comparison ------------------------------------ //
    
    public static func == (lhs: DecimalTime, rhs: DecimalTime) -> Bool { lhs.date == rhs.date }
    
    public static func < (lhs: DecimalTime, rhs: DecimalTime) -> Bool { lhs.date < rhs.date }
    
    // Computation ------------------------------------ //
    
    public static func + (decimalTime: DecimalTime, interval: DecimalTimeInterval) -> DecimalTime {
        let newDate = decimalTime.date + interval.timeInterval
        return DecimalTime(from: newDate, using: decimalTime.calendar) ?? decimalTime
    }
    
    public static func - (decimalTime: DecimalTime, interval: DecimalTimeInterval) -> DecimalTime {
        let newDate = decimalTime.date - interval.timeInterval
        return DecimalTime(from: newDate, using: decimalTime.calendar) ?? decimalTime
    }
    
    // Hashable ------------------------------------ //
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(secondsWithRemainder)
        hasher.combine(day)
        hasher.combine(year)
    }
    
    // Static ------------------------------------ //
    
    /**
     Static utility function to convert a `Date` instance to the time components for a decimal time
     - Parameter date: A `Date` instance  to convert
     - Parameter calendar: The `Calendar` to use - Defaults to current user calendar
     */
    public static func getDecimalTimeComponents(from date: Date = Date(), using calendar: Calendar = Calendar.current) -> (whole: WholeDecimalTimeComponents, withRemainder: DecimalTimeComponentsWithRemainder)? {
        guard let sinceMidnight = date.timeIntervalSinceMidnight(from: calendar) else { return nil }
        return try? getDecimalTimeComponents(timeInterval: sinceMidnight, using: calendar)
    }
    
    /**
     Static utility function to get the decimal time with a time interval (in standard seconds) since midnight
     - Parameter timeInterval: Time interval (in standard seconds) since midnight
     - Parameter calendar: The `Calendar` to use - Defaults to current user calendar
     */
    public static func getDecimalTimeComponents(timeInterval: TimeInterval, using calendar: Calendar = Calendar.current) throws -> (whole: WholeDecimalTimeComponents, withRemainder: DecimalTimeComponentsWithRemainder) {
        let decimalTimeIntervalSinceMidnight: Double = try checkRange(amount: timeInterval, range: 0..<86_400).decimalTimeInterval
        return try DecimalTime.getDecimalTimeComponents(decimalTimeInterval: decimalTimeIntervalSinceMidnight, using: calendar)
    }
    
    /**
     Static utility function to get the decimal time with a time interval (in decimal seconds) since midnight
     - Parameter decimalTimeInterval: Time interval (in decimal seconds) since midnight
     - Parameter calendar: The `Calendar` to use - Defaults to current user calendar
     */
    public static func getDecimalTimeComponents(decimalTimeInterval: DecimalTimeInterval, using calendar: Calendar = Calendar.current) throws -> (whole: WholeDecimalTimeComponents, withRemainder: DecimalTimeComponentsWithRemainder) {
        let decimalTimeIntervalSinceMidnight: Double = try checkRange(amount: decimalTimeInterval, range: 0..<100_000)
        let hoursWithRemainder = decimalTimeIntervalSinceMidnight / 100 / 100
        let hours = floor(hoursWithRemainder)
        let minutesWithRemainder: Double = (hours == 0 ? hoursWithRemainder : (hoursWithRemainder.truncatingRemainder(dividingBy: hours))) * 100
        let minutes = floor(minutesWithRemainder)
        let secondsWithRemainder: Double = (minutes == 0 ? minutesWithRemainder : (minutesWithRemainder.truncatingRemainder(dividingBy: minutes))) * 100
        let seconds = floor(secondsWithRemainder)
        let millisecondsWithRemainder: Double = (seconds == 0 ? secondsWithRemainder : (secondsWithRemainder.truncatingRemainder(dividingBy: seconds))) * 1_000
        let milliseconds = floor(millisecondsWithRemainder)
        let nanosecondsWithRemainder: Double = (milliseconds == 0 ? millisecondsWithRemainder : (millisecondsWithRemainder.truncatingRemainder(dividingBy: milliseconds))) * 1_000_000
        let nanoseconds = floor(nanosecondsWithRemainder)
        return (
            whole: (
                hours: Int(hours),
                minutes: Int(minutes),
                seconds: Int(seconds),
                milliseconds: Int(milliseconds),
                nanoseconds: Int(nanoseconds)
            ),
            withRemainder: (
                hours: hoursWithRemainder,
                minutes: minutesWithRemainder,
                seconds: secondsWithRemainder,
                milliseconds: millisecondsWithRemainder,
                nanoseconds: nanosecondsWithRemainder
            )
        )
    }
}
