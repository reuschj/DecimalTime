//
//  typealiases.swift
//  
//
//  Created by Justin Reusch on 5/3/20.
//

import Foundation

typealias DecimalTimeComponents<Type> = (hours: Type, minutes: Type, seconds: Type, milliseconds: Type, nanoseconds: Type)
typealias DecimalTimeComponentsWithRemainder = DecimalTimeComponents<Double>
typealias WholeDecimalTimeComponents = DecimalTimeComponents<Int>
typealias DecimalTimeRotationComponents = DecimalTimeComponents<Double>
