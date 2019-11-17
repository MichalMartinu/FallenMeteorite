//
//  CDMeteorite.swift
//  FallenMeteorite
//
//  Created by Michal Martinů on 17/11/2019.
//  Copyright © 2019 Michal Martinů. All rights reserved.
//

import Foundation
import CoreData
import MapKit

extension CDMeteorite {

    var coordinate: CLLocationCoordinate2D {
        var latitude = self.latitude
        var longitude = self.longitude

        if self.latitude == 0.0 {
            latitude = .leastNormalMagnitude
        }

        if self.longitude == 0.0 {
            longitude = .leastNormalMagnitude
        }

        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var annotation: MKPointAnnotation {

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate

        return annotation
    }
}
