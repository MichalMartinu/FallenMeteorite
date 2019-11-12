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

    func saveMeteorites(_ meteorites: [Meteorite]) {

        meteorites.forEach { meteorite in

            let cdmeteorite = CDMeteorite(context: context)

            cdmeteorite.name = meteorite.name
            cdmeteorite.fall = meteorite.fall
            cdmeteorite.id = meteorite.id
            cdmeteorite.mass = Int64(meteorite.mass) ?? 0
            
            if
            let latitude = meteorite.geolocation?.latitude,
            let longitude = meteorite.geolocation?.longitude
            {
                cdmeteorite.latitude = Double(latitude) ?? 0.0
                cdmeteorite.longitude = Double(longitude) ?? 0.0
            }
        }

        do {
            try context.save()
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
