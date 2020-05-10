//
//  DecimalClock.swift
//
//
//  Created by Justin Reusch on 5/1/20.
//

import Foundation

class DecimalClock {
    private(set) var decimalTime: DecimalTime
    private(set) var running: Bool = false
    private(set) var updateInterval: TimeInterval = DecimalClock.decimalSecond
    private(set) var calendar: Calendar
    
    static let decimalSecond: TimeInterval = DecimalTime.decimalSecond
    
    /// The timer which will drive any updates
    private var timer: Timer?
    
    var date: Date { decimalTime.date }
    
    
    init?(from date: Date = Date(), with calendar: Calendar = Calendar.current, start: Bool = false, updatedEvery interval: TimeInterval = 1_000) {
        self.calendar = calendar
        guard let decimalTime = DecimalTime(from: date, using: calendar) else { return nil }
        self.decimalTime = decimalTime
        if start {
            self.start(updatedEvery: interval)
        }
    }
    
    func start(updatedEvery interval: TimeInterval? = nil) {
        self.startTimer(updatedEvery: interval)
        self.running = true
    }
    
    func stop() {
        self.stopTimer()
        self.running = false
    }
    
    func refreshTime(from date: Date = Date()) -> Bool {
        self.decimalTime.setTime(from: date)
    }
    
    // Timer methods ------------------------------------ //
    
    /**
     Creates a timer
     - Parameter interval: The interval which the emitter will update the current time and date
     */
    private func startTimer(updatedEvery interval: TimeInterval? = nil) {
        if let interval = interval {
            self.updateInterval = interval
        }
        timer?.invalidate()
        if #available(iOS 10.0, *), #available(OSX 10.12, *) {
            timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true, block: { [weak self] timer in
                self?.updateTimer()
            })
        } else {
            // Fallback on earlier versions
            timer = Timer.scheduledTimer(timeInterval: updateInterval, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
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
