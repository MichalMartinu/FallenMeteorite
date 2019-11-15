//
//  UserDefaultsExtensions.swift
//  FallenMeteorite
//
//  Created by Michal Martinů on 13/11/2019.
//  Copyright © 2019 Michal Martinů. All rights reserved.
//

import Foundation

enum DefaultsKeys: String {
    case lastUpdateDate = "lastUpdateDate"
}

extension UserDefaults {

    static func saveLastUpdateDate(_ date: Date) {

        UserDefaults.standard.set(date, forKey: DefaultsKeys.lastUpdateDate.rawValue)
    }

    static func lastUpdateDate() -> Date? {
        
        return UserDefaults.standard.object(forKey: DefaultsKeys.lastUpdateDate.rawValue) as? Date
    }

    static var isFirstLaunch: Bool {

        let hasBeenLaunchedBefore = "hasBeenLaunchedBefore"

        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunchedBefore)

        if isFirstLaunch {
            UserDefaults.standard.set(true, forKey: hasBeenLaunchedBefore)
        }
        
        return isFirstLaunch
    }
}
