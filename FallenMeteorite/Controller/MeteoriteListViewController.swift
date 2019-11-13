//
//  MeteoriteListViewController.swift
//  FallenMeteorite
//
//  Created by Michal Martinů on 12/11/2019.
//  Copyright © 2019 Michal Martinů. All rights reserved.
//

import UIKit

class MeteoriteListViewController: UIViewController {

    private lazy var rootView: MeteoriteListView = {
        let view = MeteoriteListView()
        view.tableView.delegate = self
        view.tableView.dataSource = dataSource
        view.tableView.register(
            MeteoriteItemTableViewCell.self,
            forCellReuseIdentifier: MeteoriteItemTableViewCell.identifier
        )
        return view
    }()

    private let meteoriteLogoImageView: UIImageView = {
        let logoImageView = Images.imageView(.meteoriteLogo)
        logoImageView.contentMode = .scaleAspectFill
        return logoImageView
    }()

    private let dataSource: MeteoriteListDataSource

    init(meteorites: [CDMeteorite]) {

        dataSource = MeteoriteListDataSource(meteorites: meteorites)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barStyle = .black
        navigationItem.titleView = meteoriteLogoImageView
    }
}

extension MeteoriteListViewController: AppCoordinatorDelegate {

    func appCoordinator(_ coordinator: AppCoordinator, didUpateMeteorites: [CDMeteorite]) {
        // TODO: Implement
    }
}

extension MeteoriteListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return MeteoriteItemTableViewCell.preferredHeight
    }
}
