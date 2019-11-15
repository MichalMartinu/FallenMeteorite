//
//  Layout.swift
//  FallenMeteorite
//
//  Created by Michal Martinů on 13/11/2019.
//  Copyright © 2019 Michal Martinů. All rights reserved.
//

import UIKit

enum Layout {

    enum padding: CGFloat {

        /// 4
        case small = 4
        /// 8
        case medium = 8
        /// 16
        case large = 16
        /// 24
        case huge = 24
    }

    enum cornerRadius: CGFloat {

        /// 2
        case small = 4
        /// 4
        case medium = 8
        /// 16
        case large = 12
    }

    static let preferredButtonHeight: CGFloat = 44
    static let preferredPadding: CGFloat = 16
}
