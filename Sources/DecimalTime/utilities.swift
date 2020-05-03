//
//  utilities.swift
//  
//
//  Created by Justin Reusch on 5/3/20.
//

import Foundation

func checkRange<T: Comparable>(amount: T, range: Range<T>) throws -> T {
    guard amount >= range.lowerBound else { throw OutOfBoundsError.below(input: amount, lowerBound: range.lowerBound) }
    guard amount < range.upperBound else { throw OutOfBoundsError.over(input: amount, upperBound: range.lowerBound) }
    return amount
}
