//
//  AppCoordinator.swift
//  Meteorite
//
//  Created by Michal Martinů on 12/11/2019.
//  Copyright © 2019 Michal Martinů. All rights reserved.
//

import UIKit
import CoreData

final class AppCoordinator: Coordinator {

    var navigationController: UINavigationController

    private let userDefaults = UserDefaults()
    private let coreDataManager = CoreDataManager(context: AppDelegate.viewContext)

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {

        let currentDate = Date()

        if let lastUpdateDate = userDefaults.lastUpdateDate() {

            if DateManager.checkIfDate(currentDate, isInSameDayAs: lastUpdateDate) {
                fetchAndShowListVCWithSavedMeterorites()
            } else {
                fetchAndShowListVCWithSavedMeterorites()
                fetchNetworkData { result in

                    switch result {
                        case .success(let meteorites):
                            self.updateData(meteorites)
                        case .error(let error):
                            print(error) //TODO: Handle
                    }
                }
            }
        } else {
            // TODO: This
            // Empty
            // Show loading screen
            fetchNetworkData { result in

                switch result {
                    case .success(let meteorites):
                        self.updateData(meteorites)
                    case .error(let error):
                        print(error) //TODO: Handle
                }
            }

            navigationController.viewControllers = [MeteoriteListViewController(meteorites:[CDMeteorite](), userDefaults: userDefaults)]
        }
    }

    func fetchAndShowListVCWithSavedMeterorites() {

        let meteoriteListViewController = MeteoriteListViewController(
            meteorites: coreDataManager.fetchAllMeteorites(),
            userDefaults: userDefaults
        )
        navigationController.viewControllers = [meteoriteListViewController]
    }

    func fetchNetworkData(completion: @escaping (NetworkingManager.Result) -> Void) {

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
