//
//  UIButton+Extensions.swift
//  FallenMeteorite
//
//  Created by Michal Martinů on 16/11/2019.
//  Copyright © 2019 Michal Martinů. All rights reserved.
//

import UIKit

extension UIButton {

    func setBackgroundColor(_ color: UIColor, forState: UIControl.State) {

        clipsToBounds = true

        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))

        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))

        let colorImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        setBackgroundImage(colorImage, for: forState)
    }
}
