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

    private let coreDataManager = CoreDataManager(context: AppDelegate.viewContext)
    private let networkngManager = NetworkManager()

    private var firstLaunchInformationViewController: FirstLaunchInformationViewController?

    private var isFirstLaunch: Bool

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        isFirstLaunch = UserDefaults.isFirstLaunch
    }

    func start() {

        navigationController.viewControllers = [meteoriteListViewController]
        delegate?.appCoordinatorSetLoadingState(self)
        delegate?.appCoordinator(self, upateMeteorites: coreDataManager.fetchAllMeteoritesSorted())
    }

    func fetchNetworkData() {

        networkngManager.loadData { result in

            DispatchQueue.main.async {
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
        }
    }

    private func updateData(_ meteorites: [Meteorite]) -> [CDMeteorite] {
        
        coreDataManager.deleteAllMeteorites()
        let meteorites = coreDataManager.saveMeteorites(meteorites)
        UserDefaults.saveLastUpdateDate(Date())
        return meteorites
    }
}

extension AppCoordinator: MeteoriteListViewControllerDelegate {

    func meteoriteListViewControllerNeedsUpdateData(_ controller: MeteoriteListViewController) {

        fetchNetworkData()
    }

    func meteoriteListViewControllerDidLoad(_ controller: MeteoriteListViewController) {

        if isFirstLaunch {

            isFirstLaunch = false

            firstLaunchInformationViewController = FirstLaunchInformationViewController()

            guard let firstLaunchInformationViewController = firstLaunchInformationViewController else { return }

            firstLaunchInformationViewController.delegate = self

            navigationController.present(firstLaunchInformationViewController, animated: true, completion: nil)
        }
    }

    func meteoriteListViewControllerTapped(_ controller: MeteoriteListViewController, meteorite: CDMeteorite) {

        let detailViewController = MeteoriteDetailViewController(meteorite: meteorite)
        navigationController.present(detailViewController, animated: true, completion: nil)
    }
}

extension AppCoordinator: FirstLaunchInformationViewControllerDelegate {

    func firstLaunchInformationViewControllerDismiss(_ controller: FirstLaunchInformationViewController) {

        firstLaunchInformationViewController?.dismiss(animated: true, completion: nil)
    }

    func firstLaunchInformationViewControllerDidDissapear(_ controller: FirstLaunchInformationViewController) {

        firstLaunchInformationViewController = nil
    }
}
