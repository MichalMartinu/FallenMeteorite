//
//  MeteoriteTotalCountTableViewCell.swift
//  FallenMeteorite
//
//  Created by Michal Martinů on 20/11/2019.
//  Copyright © 2019 Michal Martinů. All rights reserved.
//

import UIKit

final class MeteoriteTotalCountTableViewCell: UITableViewCell {

    static let identifier = "MeteoriteTotalCountTableViewCell"
    static let preferredHeight: CGFloat = 64

    private let totalCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = CustomColor.color(.inkLight)
        label.textAlignment = .center
        return label
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = CustomColor.color(.background)

        addSubview(totalCountLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        totalCountLabel.frame = contentView.bounds
    }

    func configure(_ count: Int) {

        totalCountLabel.text = "Total: \(count)"

        layoutIfNeeded()
        setNeedsLayout()
    }
}
