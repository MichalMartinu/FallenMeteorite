//
//  UserDefault.swift
//  FallenMeteorite
//
//  Created by Michal Martinů on 13/11/2019.
//  Copyright © 2019 Michal Martinů. All rights reserved.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {

    let key: String
    let defaultValue: T

    init(_ key: String, defaultValue: T) {

        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

struct UserDefaultsConfig {

    @UserDefault("has_seen_app_introduction", defaultValue: false)
    static var hasSeenAppIntroduction: Bool

    @UserDefault("last_update_date", defaultValue: nil)
    static var lastUpadateDate: Date?
}
