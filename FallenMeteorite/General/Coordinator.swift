//
//  Coordinator.swift
//  Meteorite
//
//  Created by Michal Martinů on 12/11/2019.
//  Copyright © 2019 Michal Martinů. All rights reserved.
//

import UIKit

protocol Coordinator {

    var navigationController: UINavigationController { get set }

    func start()
}
