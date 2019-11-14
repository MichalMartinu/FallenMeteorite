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

    func appCoordinator(_ coordinator: AppCoordinator, upateMeteorites meteorites: [CDMeteorite])
    func appCoordinatorSetLoadingState(_ coordinator: AppCoordinator)
    func appCoordinatorSetOfflineState(_ coordinator: AppCoordinator)
    func appCoordintorSetErrorState(_ coordinator: AppCoordinator, message: String)
}

final class AppCoordinator: Coordinator {

    var navigationController: UINavigationController

    weak var delegate: AppCoordinatorDelegate?

    private lazy var meteoriteListViewController: MeteoriteListViewController = {
        let controller = MeteoriteListViewController()
        delegate = controller
        return controller
    }()

    private let userDefaults = UserDefaults()
    private let coreDataManager = CoreDataManager(context: AppDelegate.viewContext)

    private let currentDate = Date()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {

        navigationController.viewControllers = [meteoriteListViewController]
        delegate?.appCoordinatorSetLoadingState(self)

        if let lastUpdateDate = userDefaults.lastUpdateDate() {
            delegate?.appCoordinator(self, upateMeteorites: coreDataManager.fetchAllMeteoritesSorted())
            startWithSavedData(lastUpdated: lastUpdateDate)
        } else {
            startWithoutSavedData()
        }
    }

    private func startWithSavedData(lastUpdated: Date) {

        if !DateManager.checkIfDate(currentDate, isInSameDayAs: lastUpdated) {

            fetchNetworkData { result in
                self.handleNetworkResult(result)
            }
        }
    }

    private func startWithoutSavedData() {

        fetchNetworkData { result in
            self.handleNetworkResult(result)
        }
    }

    private func fetchNetworkData(completion: @escaping (NetworkingManager.Result) -> Void) {

        let networkingManager = NetworkingManager()

        networkingManager.loadData { result in

            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    private func handleNetworkResult(_ result: NetworkingManager.Result) {

        switch result {
            case .success(let meteorites):
                let savedMeteorites = self.updateData(meteorites)
                self.delegate?.appCoordinator(self, upateMeteorites: savedMeteorites)
            case .error(let error):
                self.delegate?.appCoordintorSetErrorState(self, message: error)
            case .offline:
                self.delegate?.appCoordinatorSetOfflineState(self)
        }
    }

    private func updateData(_ meteorites: [Meteorite]) -> [CDMeteorite] {
        
        coreDataManager.deleteAllMeteorites()
        let meteorites = coreDataManager.saveMeteorites(meteorites)
        userDefaults.saveLastUpdateDate(DateManager.currentDate())
        return meteorites
    }
}
