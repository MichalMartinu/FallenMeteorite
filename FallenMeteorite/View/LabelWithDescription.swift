//
//  LabelWithDescription.swift
//  FallenMeteorite
//
//  Created by Michal Martinů on 15/11/2019.
//  Copyright © 2019 Michal Martinů. All rights reserved.
//

import UIKit

final class LabelWithDescription: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = CustomColor.color(.mediumEmphasis)
        return label
    }()

    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = CustomColor.color(.mediumEmphasis)
        return label
    }()


    init() {
        super.init(frame: .zero)

        [titleLabel, textLabel].forEach{ addSubview($0) }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        titleLabel.sizeToFit()

        let minYLabelPosition = (frame.height - titleLabel.frame.height) / 2

        titleLabel.frame = CGRect(
            x: 0,
            y: minYLabelPosition,
            width: titleLabel.frame.width,
            height: titleLabel.frame.height
        )

        textLabel.frame = CGRect(
            x: titleLabel.frame.maxX,
            y: minYLabelPosition,
            width: frame.width - titleLabel.frame.width,
            height: titleLabel.frame.height
        )
    }

    func configure(title: String?, text: String?) {

        titleLabel.text = "\(title ?? ""): "
        textLabel.text = text

        setNeedsLayout()
    }
}
