//
//  NetworkManagerAccesing.swift
//  FallenMeteorite
//
//  Created by Michal Martinů on 16/11/2019.
//  Copyright © 2019 Michal Martinů. All rights reserved.
//

import Foundation

fileprivate let sharedAppNetworkManager = NetworkManager()

protocol NetworkManagerAccesing: AnyObject {

    var networkManager: NetworkManager { get }
}

extension NetworkManagerAccesing {

    var networkManager: NetworkManager {
         
        return sharedAppNetworkManager
    }
}
