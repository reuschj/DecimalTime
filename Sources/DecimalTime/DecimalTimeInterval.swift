//
//  DecimalTimeInterval.swift
//  
//
//  Created by Justin Reusch on 5/11/20.
//

import Foundation

/// A time interval expressed as the amount of decimal seconds
public typealias DecimalTimeInterval = Double

public extension DecimalTimeInterval {
    var timeInterval: TimeInterval { self * DecimalTime.conversionRatio }
    var milliseconds: Double { self * 1_000 }
    var seconds: Double { self }
    var nanoseconds: Double { self.milliseconds * 1_000_000  }
    var minutes: Double { self / 100 }
    var hours: Double { self.minutes / 100  }
}
