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
    private(set) var updateInterval: TimeInterval = 1000
    private(set) var calendar: Calendar
    
    /// The timer which will drive any updates
    private var timer: Timer?
    
    var date: Date { decimalTime.date }
    
    
    init?(from: Date = Date(), with calendar: Calendar = Calendar.current, start: Bool = false, updatedEvery interval: TimeInterval = 1_000) {
        self.calendar = calendar
        self.decimalTime = DecimalTime(from: date, using: calendar) else { return nil }
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
    
    func refreshTime(from date: Date = Date(), using calendar: Calendar = Calendar.current) -> Bool {
        self.decimalTime.setTime(from: date, using: calendar)
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
            timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { [weak self] timer in
                self?.updateTimer()
            })
        } else {
            // Fallback on earlier versions
            timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
        }
    }
    
    /// Stops the timer
    private func stopTimer() {
        timer?.invalidate()
    }
    
    /// Updates the timer
    @objc private func updateTimer() {
        self.refreshTime(from: Date(), using: calendar)
    }
}
