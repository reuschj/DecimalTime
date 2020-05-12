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
