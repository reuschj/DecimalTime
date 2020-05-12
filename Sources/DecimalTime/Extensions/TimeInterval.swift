//
//  TimeInterval.swift
//  
//
//  Created by Justin Reusch on 5/9/20.
//

import Foundation

extension TimeInterval {
    var decimalTimeInterval: DecimalTimeInterval { self / DecimalTime.conversionRatio }
}

extension DecimalTimeInterval {
    var timeInterval: TimeInterval { self * DecimalTime.conversionRatio }
    var milliseconds: Double { self * 1_000 }
    var seconds: Double { self }
    var nanoseconds: Double { self.milliseconds * 1_000_000  }
    var minutes: Double { self / 100 }
    var hours: Double { self.minutes / 100  }
}
