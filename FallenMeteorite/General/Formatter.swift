//
//  Formatter.swift
//  FallenMeteorite
//
//  Created by Michal Martinů on 13/11/2019.
//  Copyright © 2019 Michal Martinů. All rights reserved.
//

import Foundation

enum Formatter {

    static func yearFromJson(_ jsonString: String) -> String {

        var string = jsonString

        if let range = jsonString.range(of: "-") {
          string.removeSubrange(range.lowerBound..<jsonString.endIndex)
        }

        return string
    }

    static func doubleToString(_ number: Double, maxFractionDigits: Int = Int.max) -> String {

        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = maxFractionDigits

        formatter.numberStyle = .decimal
        return formatter.string(from: number as NSNumber) ?? "n/a"
    }
}
