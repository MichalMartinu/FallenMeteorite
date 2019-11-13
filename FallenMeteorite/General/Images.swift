//
//  Images.swift
//  FallenMeteorite
//
//  Created by Michal Martinů on 13/11/2019.
//  Copyright © 2019 Michal Martinů. All rights reserved.
//

import UIKit

enum Images {

    enum CustomImage: String {

        case meteoriteIcon = "meteorite-icon"
        case meteoriteLogo = "meteorite-navbar"
    }

    static func image(_ customImage: CustomImage) -> UIImage? {
        return UIImage(named: customImage.rawValue)
    }

    static func imageView(_ customImage: CustomImage) -> UIImageView {
        return UIImageView(image: image(customImage))
    }
}
