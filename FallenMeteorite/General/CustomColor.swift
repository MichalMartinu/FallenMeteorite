//
//  CustomColor.swift
//  FallenMeteorite
//
//  Created by Michal Martinů on 13/11/2019.
//  Copyright © 2019 Michal Martinů. All rights reserved.
//

import UIKit

enum CustomColor {

    enum CustomColorString: String {
        case highEmphasis = "font-high-emphasis"
        case mediumEmphasis = "font-medium-emphasis"
        case disabled = "font-disabled"
        case background = "background"
        case lightGray = "light-gray"
        case yellow = "yellow"
        case brown = "brown"
        case red = "red"
        case darkRed = "dark-red"
    }

    static func color(_ customColor: CustomColorString) -> UIColor {
        return UIColor(named: customColor.rawValue) ?? UIColor()
    }
}
