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

    private let networkManager = NetworkManager()
    private let coreDataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private lazy var meteoriteCoreData = MeteoriteCoreData(context: coreDataContext)

    init(navigationController: UINavigationController) {

        self.navigationController = navigationController
    }

    func start() {

        navigationController.viewControllers = [meteoriteListViewController]
        delegate?.appCoordinatorSetLoadingState(self)

        if UserDefaultsConfig.lastUpadateDate != nil {
            delegate?.appCoordinator(self, upateMeteorites: meteoriteCoreData.fetchAllMeteoritesSorted())
        }
    }

    func fetchNetworkData() {

        networkManager.loadDataWith(UrlRequest.request) { result in

            DispatchQueue.main.async {

                switch result {
                    case .success(let meteorites):
                        let savedMeteorites = self.updateData(meteorites)
                        let currentDate = Date()
                        UserDefaultsConfig.lastUpadateDate = currentDate
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
        
        meteoriteCoreData.deleteAllMeteorites()

        let meteorites = meteoriteCoreData.saveMeteorites(meteorites)

        return meteorites
    }
}

extension AppCoordinator: MeteoriteListViewControllerDelegate {

    func meteoriteListViewControllerNeedsUpdateData(_ controller: MeteoriteListViewController) {

        fetchNetworkData()
    }

    func meteoriteListViewControllerDidLoad(_ controller: MeteoriteListViewController) {

        if !UserDefaultsConfig.hasSeenAppIntroduction {

            let appIntroductionViewController = AppIntroductionViewController()
            appIntroductionViewController.delegate = self

            navigationController.present(appIntroductionViewController, animated: true, completion: nil)

            UserDefaultsConfig.hasSeenAppIntroduction = true
        }
    }

    func meteoriteListViewControllerTapped(_ controller: MeteoriteListViewController, meteorite: CDMeteorite) {

        let detailViewController = MeteoriteDetailViewController(meteorite: meteorite)
        navigationController.present(detailViewController, animated: true, completion: nil)
    }
}

extension AppCoordinator: AppIntroductionViewControllerDelegate {

    func appIntroductionViewControllerDismiss(_ controller: AppIntroductionViewController) {

        navigationController.dismiss(animated: true, completion: nil)
    }
}
