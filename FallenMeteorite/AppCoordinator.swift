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
        controller.delegate = self
        return controller
    }()

    private let userDefaults = UserDefaults()
    private let coreDataManager = CoreDataManager(context: AppDelegate.viewContext)
    private let networkingManager = NetworkManager()

    private var firstLaunchInformationViewController: FirstLaunchInformationViewController?

    private var isFirstLaunch: Bool

    private let currentDate = Date()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        isFirstLaunch = userDefaults.isFirstLaunch
    }

    func start() {

        navigationController.viewControllers = [meteoriteListViewController]
        delegate?.appCoordinatorSetLoadingState(self)

        if let lastUpdateDate = userDefaults.lastUpdateDate() {
            delegate?.appCoordinator(self, upateMeteorites: coreDataManager.fetchAllMeteoritesSorted())

            if !DateManager.checkIfDate(currentDate, isInSameDayAs: lastUpdateDate) {
                fetchNetworkData()
            }
        } else {
            fetchNetworkData()
        }
    }

    private func fetchNetworkData() {

        networkingManager.loadData { result in

            DispatchQueue.main.async {
                switch result {
                    case .success(let meteorites):
                        let savedMeteorites = self.updateData(meteorites)
                        self.delegate?.appCoordinator(self, upateMeteorites: savedMeteorites)
                        self.meteoriteListViewController.present(FirstLaunchInformationViewController(), animated: true, completion: nil)
                    case .error(let error):
                        self.delegate?.appCoordintorSetErrorState(self, message: error)
                    case .offline:
                        self.delegate?.appCoordinatorSetOfflineState(self)
                }
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

extension AppCoordinator: MeteoriteListViewControllerDelegate {

    func meteoriteListViewControllerNeedsUpdateData(_ controller: MeteoriteListViewController) {

        fetchNetworkData()
    }

    func meteoriteListViewControllerDidLoad(_ controller: MeteoriteListViewController) {

        if isFirstLaunch {

            firstLaunchInformationViewController = FirstLaunchInformationViewController()

            guard let firstLaunchInformationViewController = firstLaunchInformationViewController else { return }

            firstLaunchInformationViewController.delegate = self

            DispatchQueue.main.async {
                // Removing DispatchQueue.main.async would cause irregular warning
                // I think that is caused by quick launch of application
                // Despite this fact any efect on functuality was not proved
                self.navigationController.present(firstLaunchInformationViewController, animated: true, completion: nil)
            }
        }
    }
}

extension AppCoordinator: FirstLaunchInformationViewControllerDelegate {

    func firstLaunchInformationViewControllerDismiss(_ controller: FirstLaunchInformationViewController) {

        navigationController.dismiss(animated: true, completion: nil)
    }

    func firstLaunchInformationViewControllerDidDissapear(_ controller: FirstLaunchInformationViewController) {

        firstLaunchInformationViewController = nil
    }
}
