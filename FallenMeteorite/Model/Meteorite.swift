//
//  Meteorite.swift
//  FallenMeteorite
//
//  Created by Michal Martinů on 12/11/2019.
//  Copyright © 2019 Michal Martinů. All rights reserved.
//

import Foundation

struct Meteorite: Codable {
    var name: String
    var id: String
    var recclass: String?
    var mass: String
    var fall: String?
    var year: String?
    var geolocation: Geolocation?
}

struct Geolocation: Codable {
    var latitude: String
    var longitude: String
}
