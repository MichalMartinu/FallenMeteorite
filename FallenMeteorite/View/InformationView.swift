//
//  InformationView.swift
//  FallenMeteorite
//
//  Created by Michal Martinů on 13/11/2019.
//  Copyright © 2019 Michal Martinů. All rights reserved.
//

import UIKit

final class InformationView: UIView {

    var preferredWidth: CGFloat {
        return informationLabel.frame.width + 2 * padding
    }

    static let preferredHeight: CGFloat = 18

    private let informationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = CustomColor.color(.mediumEmphasis)
        return label
    }()

    private let padding: CGFloat = 6

    init() {
        super.init(frame: .zero)

        addSubview(informationLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        informationLabel.sizeToFit()

        let minYinformationLabel: CGFloat = (frame.height - informationLabel.frame.height) / 2

        informationLabel.frame = CGRect(
            x: padding,
            y: minYinformationLabel,
            width: informationLabel.frame.width,
            height: informationLabel.frame.height
        )
    }

    func configure(_ text: String, backgroundColor: UIColor) {

        informationLabel.text = text
        self.backgroundColor = backgroundColor

        setNeedsLayout()
    }
}
