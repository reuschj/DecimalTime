//
//  DecimalClock.swift
//
//
//  Created by Justin Reusch on 5/1/20.
//

import Foundation

/**
 A decimal time clock that updates itself at regular intervals
 */
public class DecimalClock {
    
    /// Embedded, updatable, stored decimal time
    private(set) var decimalTime: DecimalTime
    
    /// Flag for if the clock is running or not (is stopped)
    private(set) var running: Bool = false
    
    /// The interval at which the clock updates (or refreshes with the current time)
    private(set) var updateInterval: TimeInterval = DecimalClock.decimalSecond
    
    /// Stored calendar instance
    private(set) var calendar: Calendar = Calendar.current
        
    // ------------------------- //
    
    /// The timer which will drive any updates
    private var timer: Timer?
    
    // Static -------------------- //
    
    static let decimalSecond: TimeInterval = DecimalTime.decimalSecond
    
    // Computed ------------------------------------ //
    
    var date: Date { decimalTime.date }
    
    // Initializers ------------------------------------ //
    
    /**
     Initializes with a `DecimalTime` instance and calendar
     - Parameter decimalTime: The `DecimalTime`instance to initialize the clock with (current by default)
     - Parameter calendar: The `Calendar` to use - Defaults to current user calendar
     - Parameter start: Start the clock running at initialization
     - Parameter interval: Choose the update interval for the clock (in decimal seconds)
     */
    init(from decimalTime: DecimalTime, with calendar: Calendar = Calendar.current, start: Bool = false, updatedEvery interval: DecimalTimeInterval = 1) {
        self.calendar = calendar
        self.decimalTime = decimalTime
        self.running = false
        self.updateInterval = interval
        if start {
            self.start(updatedEvery: interval)
        }
    }
    
    /**
     Initializes with a `Date` instance and calendar
     - Parameter date: The `Date`instance to initialize the clock with (current by default)
     - Parameter calendar: The `Calendar` to use - Defaults to current user calendar
     - Parameter start: Start the clock running at initialization
     - Parameter interval: Choose the update interval for the clock (in decimal seconds)
     */
    convenience init?(from date: Date = Date(), with calendar: Calendar = Calendar.current, start: Bool = false, updatedEvery interval: DecimalTimeInterval = 1) {
        guard let decimalTime = DecimalTime(from: date, using: calendar) else { return nil }
        self.init(from: decimalTime, with: calendar, start: start, updatedEvery: interval)
    }
    
    // Methods ------------------------------------ //
    
    /**
     Starts the clock with the requested interval
     - Parameter interval: Choose the update interval for the clock (in decimal seconds)
     */
    func start(updatedEvery interval: DecimalTimeInterval? = nil) {
        self.startTimer(updatedEvery: interval)
        self.running = true
    }
    
    /// Stops the clock
    func stop() {
        self.stopTimer()
        self.running = false
    }
    
    /// Refreshes the decimal time
    func refreshTime(from date: Date = Date()) -> Bool {
        self.decimalTime.setTime(from: date)
    }
    
    // Timer methods ------------------------------------ //
    
    /**
     Creates a timer
     - Parameter interval: The interval which the emitter will update the current time and date
     */
    private func startTimer(updatedEvery interval: DecimalTimeInterval? = nil) {
        if let interval = interval {
            self.updateInterval = interval
        }
        timer?.invalidate()
        if #available(iOS 10.0, *), #available(OSX 10.12, *) {
            timer = Timer.scheduledTimer(withTimeInterval: updateInterval.timeInterval, repeats: true) { [weak self] timer in
                self?.updateTimer()
            }
        } else {
            // Fallback on earlier versions
            timer = Timer.scheduledTimer(timeInterval: updateInterval.timeInterval, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
        }
    }
    
    /// Stops the timer
    private func stopTimer() {
        timer?.invalidate()
    }
    
    /// Updates the timer
    @objc private func updateTimer() {
        _ = self.refreshTime(from: Date())
    }
}
