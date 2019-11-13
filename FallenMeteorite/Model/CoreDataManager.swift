//
//  CoreDataManager.swift
//  FallenMeteorite
//
//  Created by Michal Martinů on 12/11/2019.
//  Copyright © 2019 Michal Martinů. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataManager {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func saveMeteorites(_ meteorites: [Meteorite]) -> [CDMeteorite] {

        var savedMeteorites = [CDMeteorite]()

        meteorites.forEach { meteorite in

            let savedMeteorite = CDMeteorite(context: context)

            savedMeteorite.name = meteorite.name
            savedMeteorite.fall = meteorite.fall
            savedMeteorite.id = meteorite.id
            savedMeteorite.mass = Double(meteorite.mass) ?? 0.0
            savedMeteorite.year = Int64(DateManager.yearFromJson(meteorite.year ?? "")) ?? 0

            if
            let latitude = meteorite.geolocation?.latitude,
            let longitude = meteorite.geolocation?.longitude
            {
                savedMeteorite.latitude = Double(latitude) ?? 0.0
                savedMeteorite.longitude = Double(longitude) ?? 0.0
            }

            savedMeteorites.append(savedMeteorite)
        }

        do {
            try context.save()
            return savedMeteorites
        } catch {
            fatalError("Failed to execute request: \(error)")
        }
    }

    func fetchAllMeteorites() -> [CDMeteorite] {

        let fetchRequest:NSFetchRequest<CDMeteorite> = CDMeteorite.fetchRequest()

        do {
            let meteorites = try context.fetch(fetchRequest)
            return meteorites
        } catch {
            fatalError("Failed to execute request: \(error)")
        }
    }

    func deleteAllMeteorites() {

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDMeteorite")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        batchDeleteRequest.resultType = .resultTypeObjectIDs

        do {
            let result = try context.execute(batchDeleteRequest) as! NSBatchDeleteResult

            let changes: [AnyHashable: Any] = [
                NSDeletedObjectsKey: result.result as! [NSManagedObjectID]
            ]

            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])

        } catch {
            fatalError("Failed to execute request: \(error)")
        }
    }
}
