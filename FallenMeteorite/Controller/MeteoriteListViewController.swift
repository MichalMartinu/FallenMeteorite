//
//  MeteoriteListViewController.swift
//  FallenMeteorite
//
//  Created by Michal Martinů on 12/11/2019.
//  Copyright © 2019 Michal Martinů. All rights reserved.
//

import UIKit
import CoreData

class MeteoriteListViewController: UIViewController {

    private let coreDataManager = CoreDataManager(context: AppDelegate.viewContext)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red

        let networkingManager = NetworkingManager()

        networkingManager.loadData { result in

            DispatchQueue.main.async {

                switch(result) {
                    case .success(let meteorites): self.updateDatabase(meteorites)
                    case .error(let message): print(message)
                }
            }
        }
    }

    private func updateDatabase(_ meteorites: [Meteorite]) {

        meteorites.forEach {
            print($0.mass)
        }

        coreDataManager.deleteAllMeteorites()
        coreDataManager.saveMeteorites(meteorites)
    }
}

