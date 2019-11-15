//
//  Formatter.swift
//  FallenMeteorite
//
//  Created by Michal Martinů on 13/11/2019.
//  Copyright © 2019 Michal Martinů. All rights reserved.
//

import Foundation

enum Formatter {

    static func formatWeight(_ weight: Double) -> String {

        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2

        formatter.numberStyle = .decimal
        return formatter.string(from: weight as NSNumber) ?? "n/a"
    }

    static func formatCoordinate(_ coordinate: Double) -> String {
        return coordinate == 0.0 ? "Unknown" : String(coordinate)
    }
}
