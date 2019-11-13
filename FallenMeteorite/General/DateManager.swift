//
//  DateManager.swift
//  FallenMeteorite
//
//  Created by Michal Martinů on 13/11/2019.
//  Copyright © 2019 Michal Martinů. All rights reserved.
//

import Foundation

enum DateManager {

    static func yearFromJson(_ jsonString: String) -> String {

        let index = jsonString.index(jsonString.startIndex, offsetBy: 4)
        return String(jsonString[..<index])
    }

    static func currentDate() -> Date {
        
        return Date()
    }

    static func checkIfDate(_ firstDate: Date, isInSameDayAs secondDate: Date) -> Bool {

        return Calendar.current.isDate(firstDate, inSameDayAs: secondDate)
    }
}
