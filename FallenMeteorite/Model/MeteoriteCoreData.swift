//
//  MeteoriteCoreData.swift
//  FallenMeteorite
//
//  Created by Michal Martinů on 12/11/2019.
//  Copyright © 2019 Michal Martinů. All rights reserved.
//

import Foundation
import CoreData

final class MeteoriteCoreData {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        
        self.context = context
    }

    func saveMeteorites(_ meteorites: [Meteorite]) -> [CDMeteorite] {

        let savedMeteorites = meteorites.map { meteorite -> CDMeteorite in

            let savedMeteorite = CDMeteorite(context: context)

            savedMeteorite.name = meteorite.name
            savedMeteorite.fall = meteorite.fall
            savedMeteorite.id = meteorite.id
            savedMeteorite.mass = Double(meteorite.mass) ?? 0.0
            savedMeteorite.recclass = meteorite.recclass
            savedMeteorite.year = Int64(Formatter.yearFromJson(meteorite.year ?? "")) ?? 0

            if
            let latitude = meteorite.geolocation?.latitude,
            let longitude = meteorite.geolocation?.longitude
            {
                savedMeteorite.latitude = Double(latitude) ?? 0.0
                savedMeteorite.longitude = Double(longitude) ?? 0.0
            }

            return savedMeteorite
        }

        do {
            try context.save()
            return savedMeteorites
        } catch {
            fatalError("Failed to execute request: \(error)")
        }
    }

    func fetchAllMeteoritesSorted() -> [CDMeteorite] {

        let fetchRequest:NSFetchRequest<CDMeteorite> = CDMeteorite.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(CDMeteorite.mass), ascending: false)]

        do {
            let meteorites = try context.fetch(fetchRequest)
            return meteorites
        } catch {
            fatalError("Failed to execute request: \(error)")
        }
    }

    func deleteAllMeteorites() {

        let fetchRequest:NSFetchRequest<CDMeteorite> = CDMeteorite.fetchRequest()

        do {
            let results = try context.fetch(fetchRequest)

            for object in results {
                context.delete(object)
            }

            try context.save()
            
        } catch {
            fatalError("Failed to execute request: \(error)")
        }
    }
}
