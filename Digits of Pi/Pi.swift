//
//  Pi.swift
//  Digits of Pi
//
//  Created by Mike Griebling on 20.08.2024.
//

import BigInt
import Foundation

typealias Integer = BigInt.BInt

func arccot(_ x : Int64, _ unity : Integer) -> Integer {
    let bigx = Integer(x)
    let xsquared = Integer(x * x)
    var sum = unity / bigx
    var xpower = sum
    var n = Int64(3)
    var sign = false
    
    var term = Integer(0)
    while true {
        xpower = xpower / xsquared
        term = xpower / Integer(n)
        if term.isZero {
            break
        }
        if sign {
            sum += term
        } else {
            sum -= term
        }
        sign = !sign
        n += 2
    }
    return sum
}

public func computePi(_ digits: Double) async -> String {
    let digits = Int(digits) + 9
    let unity = Integer(10) ** digits
    let four = Integer(4)
    var s = ""
    
	let start = Date()
    let pi = four * (four * arccot(5, unity) - arccot(239, unity))
	let end = Date()
	
	print("Elapsed time = \(end.timeIntervalSince(start))")
    
    s = "\(pi)"
    s.insert(".", at: s.index(after: s.startIndex))  // add decimal point
    var index = s.startIndex
    while index < s.endIndex {
        index = s.index(index, offsetBy: 6, limitedBy: s.endIndex) ?? s.endIndex
        if index == s.endIndex { break }
        s.insert(" ", at: index)
    }
	let endFormat = Date()
	
	print("Formating time = \(endFormat.timeIntervalSince(end))")
    return " π = \(s)"
}
