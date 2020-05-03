//
//  errors.swift
//  
//
//  Created by Justin Reusch on 5/3/20.
//

import Foundation

public enum OutOfBoundsError<T: Comparable>: Error {
    case below(input: T, lowerBound: T)
    case over(input: T, upperBound: T)
}
