//
//  MeteoriteListViewController.swift
//  FallenMeteorite
//
//  Created by Michal Martinů on 12/11/2019.
//  Copyright © 2019 Michal Martinů. All rights reserved.
//

import UIKit

protocol MeteoriteListViewControllerDelegate: AnyObject {

    func meteoriteListViewControllerNeedsUpdateData(_ controller: MeteoriteListViewController)
    func meteoriteListViewControllerDidLoad(_ controller: MeteoriteListViewController)
    func meteoriteListViewControllerTapped(_ controller: MeteoriteListViewController, meteorite: CDMeteorite)
}

final class MeteoriteListViewController: UIViewController {

    weak var delegate: MeteoriteListViewControllerDelegate?

    private lazy var rootView: MeteoriteListView = {
        let view = MeteoriteListView()
        view.tableView.delegate = self
        view.tableView.dataSource = dataSource
        view.tableView.register(
            MeteoriteItemTableViewCell.self,
            forCellReuseIdentifier: MeteoriteItemTableViewCell.identifier
        )
        view.tableView.register(
            MeteoriteTotalCountTableViewCell.self,
            forCellReuseIdentifier: MeteoriteTotalCountTableViewCell.identifier
        )
        view.delegate = self
        return view
    }()

    private let meteoriteLogoImageView: UIImageView = {
        let logoImageView = Images.imageView(.meteoriteLogo)
        logoImageView.contentMode = .scaleAspectFill
        return logoImageView
    }()

    private let dataSource = MeteoriteListDataSource()

    override func loadView() {
        super.loadView()

        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barStyle = .black
        navigationItem.titleView = meteoriteLogoImageView
        
        delegate?.meteoriteListViewControllerDidLoad(self)
    }
}

extension MeteoriteListViewController: AppCoordinatorDelegate {

    func appCoordinator(_ coordinator: AppCoordinator, upateMeteorites meteorites: [CDMeteorite]) {

        dataSource.updateData(with: meteorites)
        rootView.tableView.reloadData()

        if meteorites.isEmpty {
            rootView.informationViewContentType(.empty)
        } else {
            rootView.informationViewContentType(.hidden)
        }
    }

    func appCoordinatorSetLoadingState(_ coordinator: AppCoordinator) {

        rootView.informationViewContentType(.loading)
    }

    func appCoordinatorSetOfflineState(_ coordinator: AppCoordinator) {

        if dataSource.meteorites.isEmpty {
            rootView.informationViewContentType(.offline)
        }
    }

    func appCoordintorSetErrorState(_ coordinator: AppCoordinator, message: String) {

        if dataSource.meteorites.isEmpty {
            rootView.informationViewContentType(.error, message: message)
        }
    }

}

extension MeteoriteListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.row == dataSource.totalCountCellIndex {
            return MeteoriteTotalCountTableViewCell.preferredHeight
        } else {
            return MeteoriteItemTableViewCell.preferredHeight
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        delegate?.meteoriteListViewControllerTapped(self, meteorite: dataSource.meteorites[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MeteoriteListViewController: MeteoriteListViewDelegate {

    func meteoriteListViewTappedButton(_ view: MeteoriteListView, with button: UIButton) {

        rootView.informationViewContentType(.loading)
        delegate?.meteoriteListViewControllerNeedsUpdateData(self)
    }
}
