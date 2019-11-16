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

        case inkDark = "Ink-dark"
        case inkLight = "Ink-light"
        case inkDisabled = "Ink-disabled"
        case background = "Background"
        case backgroundGray = "Background-gray"
        case lightGray = "Light-gray"
        case yellow = "Yellow"
        case red = "Red"
        case darkRed = "Dark-red"
    }

    static func color(_ customColor: CustomColorString) -> UIColor {
        
        return UIColor(named: customColor.rawValue) ?? UIColor()
    }
}
