//
//  typealiases.swift
//  
//
//  Created by Justin Reusch on 5/3/20.
//

import Foundation

/// Decimal time components broken down to basic time components
public typealias DecimalTimeComponents<Type> = (hours: Type, minutes: Type, seconds: Type, milliseconds: Type, nanoseconds: Type)

/// Decimal time components with remainder (the fractional sum of all sub-components)
public typealias DecimalTimeComponentsWithRemainder = DecimalTimeComponents<Double>

/// Decimal time components with any remainder truncated to express only the amount of whole units
public typealias WholeDecimalTimeComponents = DecimalTimeComponents<Int>

/// The rotation values for decimal time components to use for clock hands
public typealias DecimalTimeRotationComponents = DecimalTimeComponents<Double>
