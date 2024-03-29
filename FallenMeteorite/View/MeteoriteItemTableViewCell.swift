//
//  MeteorItemTableViewCell.swift
//  FallenMeteorite
//
//  Created by Michal Martinů on 13/11/2019.
//  Copyright © 2019 Michal Martinů. All rights reserved.
//

import UIKit

final class MeteoriteItemTableViewCell: UITableViewCell {

    static let identifier = "MeteoriteItemTableViewCell"
    static let preferredHeight: CGFloat = 84

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = CustomColor.color(.inkLight)
        return label
    }()

    private let meteoriteImageView: UIImageView = {
        let imageView = Images.imageView(.meteorite)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let yearInformationView = ViewWithLabel()

    private let weightInformationView = ViewWithLabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = CustomColor.color(.background)

        [yearInformationView, weightInformationView].forEach{
            $0.roundCorners(Layout.cornerRadius.medium.rawValue)
        }

        [nameLabel, meteoriteImageView, yearInformationView, weightInformationView].forEach{ addSubview($0) }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let imageSize: CGFloat = 36
        let nameLabelHeight: CGFloat = 20
        let maxWidth = contentView.bounds.width - 2 * Layout.padding.large.rawValue

        let minYImageView = (contentView.bounds.height - imageSize) / 2

        meteoriteImageView.frame = CGRect(
            x: Layout.padding.large.rawValue,
            y: minYImageView,
            width: imageSize,
            height: imageSize
        )

        let viewsHeight = nameLabel.frame.height + ViewWithLabel.preferredHeight + Layout.padding.small.rawValue
        let minYnameLabel = (contentView.bounds.height - viewsHeight) / 2

        nameLabel.frame = CGRect(
            x: meteoriteImageView.frame.maxX + Layout.padding.large.rawValue,
            y: minYnameLabel,
            width: maxWidth - imageSize - Layout.padding.large.rawValue,
            height: nameLabelHeight
        )

        yearInformationView.frame = CGRect(
            x: meteoriteImageView.frame.maxX + Layout.padding.large.rawValue,
            y: nameLabel.frame.maxY + Layout.padding.small.rawValue,
            width: yearInformationView.preferredWidth,
            height: ViewWithLabel.preferredHeight
        )

        weightInformationView.frame = CGRect(
            x: yearInformationView.frame.maxX + Layout.padding.small.rawValue,
            y: nameLabel.frame.maxY + Layout.padding.small.rawValue,
            width: weightInformationView.preferredWidth,
            height: ViewWithLabel.preferredHeight
        )
    }

    func configure(with meteorite: CDMeteorite) {
        nameLabel.text = meteorite.name

        yearInformationView.configure(String(meteorite.year), backgroundColor: CustomColor.color(.lightGray))
        weightInformationView.configure(
            "\(Formatter.doubleToString(meteorite.mass, maxFractionDigits: 2)) g",
            backgroundColor: CustomColor.color(.lightGray)
        )

        layoutIfNeeded()
        setNeedsLayout()
    }
}
