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
    private let userDefaults: UserDefaults

    init(meteorites: [CDMeteorite], userDefaults: UserDefaults) {

        self.userDefaults = userDefaults

        super.init(nibName: nil, bundle: nil)

        print(meteorites.count)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
    }
}

