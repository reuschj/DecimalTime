//
//  typealiases.swift
//  
//
//  Created by Justin Reusch on 5/3/20.
//

import Foundation

public typealias DecimalTimeComponents<Type> = (hours: Type, minutes: Type, seconds: Type, milliseconds: Type, nanoseconds: Type)
public typealias DecimalTimeComponentsWithRemainder = DecimalTimeComponents<Double>
public typealias WholeDecimalTimeComponents = DecimalTimeComponents<Int>
public typealias DecimalTimeRotationComponents = DecimalTimeComponents<Double>
