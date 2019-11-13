//
//  AppCoordinator.swift
//  Meteorite
//
//  Created by Michal Martinů on 12/11/2019.
//  Copyright © 2019 Michal Martinů. All rights reserved.
//

import UIKit
import CoreData

protocol AppCoordinatorDelegate: AnyObject {

    func appCoordinator(_ coordinator: AppCoordinator, didUpateMeteorites: [CDMeteorite])
}

final class AppCoordinator: Coordinator {

    var navigationController: UINavigationController

    weak var delegate: AppCoordinatorDelegate?

    private let userDefaults = UserDefaults()
    private let coreDataManager = CoreDataManager(context: AppDelegate.viewContext)

    private let currentDate = Date()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {

        if let lastUpdateDate = userDefaults.lastUpdateDate() {
            startWithSavedData(lastUpdated: lastUpdateDate)

        } else {
            startWithoutSavedData()
        }
    }

    private func startWithSavedData(lastUpdated: Date) {

        if DateManager.checkIfDate(currentDate, isInSameDayAs: lastUpdated) {
            fetchAndShowListVCWithSavedMeterorites()
        } else {
            fetchAndShowListVCWithSavedMeterorites()
            fetchNetworkData { result in

                switch result {
                    case .success(let meteorites):
                        let savedMeteorites = self.updateData(meteorites)
                        self.delegate?.appCoordinator(self, didUpateMeteorites: savedMeteorites)
                    case .error(let error):
                        print(error) //TODO: Handle
                }
            }
        }
    }

    private func startWithoutSavedData() {

        // TODO: This
        // Empty
        // Show loading screen
        fetchNetworkData { result in

            switch result {
                case .success(let meteorites):
                    let savedMeteorites = self.updateData(meteorites)
                    self.delegate?.appCoordinator(self, didUpateMeteorites: savedMeteorites)
                case .error(let error):
                    print(error) //TODO: Handle
            }
        }

        navigationController.viewControllers = [
            MeteoriteListViewController(meteorites:[CDMeteorite]())
        ]
    }

    private func fetchAndShowListVCWithSavedMeterorites() {

        let meteoriteListViewController = MeteoriteListViewController(meteorites: coreDataManager.fetchAllMeteoritesSorted())

        delegate = meteoriteListViewController
        navigationController.viewControllers = [meteoriteListViewController]
    }

    private func fetchNetworkData(completion: @escaping (NetworkingManager.Result) -> Void) {

        let networkingManager = NetworkingManager()

        networkingManager.loadData { result in

            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    private func updateData(_ meteorites: [Meteorite]) -> [CDMeteorite] {
        
        coreDataManager.deleteAllMeteorites()
        let meteorites = coreDataManager.saveMeteorites(meteorites)
        userDefaults.saveLastUpdateDate(DateManager.currentDate())
        return meteorites
    }
}
