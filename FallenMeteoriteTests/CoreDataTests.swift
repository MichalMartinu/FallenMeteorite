//
//  MeteoriteCoreDataTests.swift
//  FallenMeteoriteTests
//
//  Created by Michal Martinů on 16/11/2019.
//  Copyright © 2019 Michal Martinů. All rights reserved.
//

import XCTest
import CoreData
import MapKit

@testable import FallenMeteorite

class CoreDataTests: XCTestCase {

    var meteoriteCoreData: MeteoriteCoreData!

    let meteorite1 = Meteorite(
        name: "Test 1",
        id: "1",
        recclass: "IT",
        mass: "1",
        fall: "found",
        year: "2011-01-01T00:00:000",
        geolocation: Geolocation(latitude: "23.123", longitude: "34.231")
    )

    let meteorite2 = Meteorite(
        name: "Test 2",
        id: "2",
        recclass: "TI",
        mass: "2",
        fall: "fallen",
        year: "2012-01-01T00:00:000",
        geolocation: Geolocation(latitude: "23.123", longitude: "34.231")
    )

    let meteorite3 = Meteorite(
        name: "Test 3",
        id: "3",
        recclass: "TI",
        mass: "3",
        fall: "fallen",
        year: "2013-01-01T00:00:000",
        geolocation: Geolocation(latitude: "0.0", longitude: "0.0")
    )

    override func setUp() {
        super.setUp()

        meteoriteCoreData = MeteoriteCoreData(context: mockPersistantContainer.viewContext)
        initStubs()
    }

    override func tearDown() {
        super.tearDown()

        flushData()
        meteoriteCoreData = nil

        super.tearDown()
    }

    func testCreateMeteorite() {

        let meteorites = meteoriteCoreData.saveMeteorites([meteorite1])

        XCTAssertNotNil(meteorites)

        let meteorite = meteorites.first

        XCTAssertNotNil(meteorite)


        XCTAssertEqual(meteorite?.name, meteorite1.name)
        XCTAssertEqual(meteorite?.id, meteorite1.id)
        XCTAssertEqual(meteorite?.recclass, meteorite1.recclass)
        XCTAssertEqual(meteorite?.mass, 1)
        XCTAssertEqual(meteorite?.fall, meteorite1.fall)
        XCTAssertEqual(meteorite?.year, 2011)
        XCTAssertEqual(meteorite?.latitude, 23.123)
        XCTAssertEqual(meteorite?.longitude, 34.231)
    }

    func testCreateCoordinateWithZeros() {

        let meteorite = meteoriteCoreData.saveMeteorites([meteorite3])

        XCTAssertNotNil(meteorite.first)
        XCTAssertEqual(meteorite.first?.coordinate.latitude, .leastNormalMagnitude)
        XCTAssertEqual(meteorite.first?.coordinate.longitude, .leastNormalMagnitude)
    }

    func testCreateAnnotation() {

        let meteorite = meteoriteCoreData.saveMeteorites([meteorite1])

        XCTAssertNotNil(meteorite.first)
        XCTAssertEqual(meteorite.first?.annotation.coordinate.latitude, 23.123)
        XCTAssertEqual(meteorite.first?.annotation.coordinate.longitude, 34.231)
    }

    func testFetchAllMeteoritesSorter() {

        let results = meteoriteCoreData.fetchAllMeteoritesSorted()

        XCTAssertEqual(results.count, 2)
        XCTAssertEqual(numberOfItemsInPersistentStore, 2)

        XCTAssertTrue(results[0].id == "2")
        XCTAssertTrue(results[1].id == "1")
    }

    func testSaveMeteorite() {

        let results = meteoriteCoreData.saveMeteorites([meteorite3])

        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(numberOfItemsInPersistentStore, 3)
    }

    func testDeleteAllMeteorites() {

        meteoriteCoreData.deleteAllMeteorites()

        XCTAssertEqual(numberOfItemsInPersistentStore, 0)
    }

    // MARK: moc in-memory persistant store

    var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        return managedObjectModel
    }()

    lazy var mockPersistantContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "FallenMeteorite", managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false

        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )

            // Check if creating container wrong
            if let error = error {
                fatalError("In memory coordinator creation failed \(error)")
            }
        }
        return container
    }()
}

//MARK: Create some fake meteorites
extension CoreDataTests {

    func initStubs() {

           func insertMeteorite(_ meteorite: Meteorite) {

               let savedMeteorite = CDMeteorite(context: mockPersistantContainer.viewContext)

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
           }

           insertMeteorite(meteorite1)
           insertMeteorite(meteorite2)

           do {
               try mockPersistantContainer.viewContext.save()
           }  catch {
               print("create fakes error \(error)")
           }
       }

    func flushData() {

        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "CDMeteorite")
        let objs = try! mockPersistantContainer.viewContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            mockPersistantContainer.viewContext.delete(obj)
        }

        do {
            try mockPersistantContainer.viewContext.save()
        }  catch {
            print("create fakes error \(error)")
        }
    }

    var numberOfItemsInPersistentStore: Int {

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDMeteorite")
        let results = try! mockPersistantContainer.viewContext.fetch(fetchRequest)
        return results.count
    }
}
