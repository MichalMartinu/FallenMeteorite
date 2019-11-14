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

    func saveLastUpdateDate(_ date: Date) {

        self.set(date, forKey: DefaultsKeys.lastUpdateDate.rawValue)
    }

    func lastUpdateDate() -> Date? {
        
        return self.object(forKey: DefaultsKeys.lastUpdateDate.rawValue) as? Date
    }

    var isFirstLaunch: Bool {

        let hasBeenLaunchedBefore = "hasBeenLaunchedBefore"

        let isFirstLaunch = !self.bool(forKey: hasBeenLaunchedBefore)

        if isFirstLaunch {
            self.set(true, forKey: hasBeenLaunchedBefore)
        }
        
        return true
    }
}
