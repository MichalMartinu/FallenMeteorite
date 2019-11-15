//
//  InformationView.swift
//  FallenMeteorite
//
//  Created by Michal Martinů on 14/11/2019.
//  Copyright © 2019 Michal Martinů. All rights reserved.
//

import UIKit

protocol InformationViewDelegate: AnyObject {

    func informationViewDelegateListViewTappedButton(_ view: InformationView, with button: UIButton)
}

final class InformationView: UIView {

    weak var delegate: InformationViewDelegate?

    private lazy var loadingIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.color = .white
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let messageHeaderLabel: UILabel = {
        let label = UILabel()
        label.textColor = CustomColor.color(.highEmphasis)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = CustomColor.color(.mediumEmphasis)
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()

    let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = CustomColor.color(.red)
        button.layer.cornerRadius = Layout.roundCorners.medium.rawValue
        button.setBackgroundColor(CustomColor.color(.darkRed), forState: .highlighted)
        button.setTitleColor(CustomColor.color(.highEmphasis), for: .normal)
        button.setTitleColor(CustomColor.color(.disabled), for: .highlighted)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }()

    init() {
        super.init(frame: .zero)

        backgroundColor = CustomColor.color(.background)

        [imageView, loadingIndicatorView, messageHeaderLabel, messageLabel, button].forEach{ addSubview($0) }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let messageHeaderLabelSpacing: CGFloat = 84
        let messageLabelSpacing: CGFloat = 16
        let buttonSpacing: CGFloat = 48

        let contentViewFrame: CGFloat = 64

        let maxLabelWidth: CGFloat = 300
        let buttonWidth: CGFloat = 280
        let expectedLabelSize = CGSize(width: maxLabelWidth, height: .greatestFiniteMagnitude)

        let messageHeaderLabelSize = messageHeaderLabel.sizeThatFits(expectedLabelSize)
        let messageLabelSize = messageLabel.sizeThatFits(expectedLabelSize)

        let viewsHeight =
            contentViewFrame + messageHeaderLabelSpacing + messageHeaderLabelSize.height
                + messageLabelSpacing + messageLabelSize.height

        let minXcontentView = (frame.width - contentViewFrame) / 2
        let minYcontentView = (frame.height - viewsHeight) / 2

        [loadingIndicatorView, imageView].forEach{
            $0.frame = CGRect(
                x: minXcontentView,
                y: minYcontentView,
                width: contentViewFrame,
                height: contentViewFrame
            )
        }

        let minXmessageHeaderLabel = (frame.width - messageHeaderLabelSize.width) / 2

        messageHeaderLabel.frame = CGRect(
            x: minXmessageHeaderLabel,
            y: loadingIndicatorView.frame.maxY + messageHeaderLabelSpacing,
            width: messageHeaderLabelSize.width,
            height: messageHeaderLabelSize.height
        )

        let minXmessageLabel = (frame.width - messageLabelSize.width) / 2

        messageLabel.frame = CGRect(
            x: minXmessageLabel,
            y: messageHeaderLabel.frame.maxY + messageLabelSpacing,
            width: messageLabelSize.width,
            height: messageLabelSize.height
        )

        let minXbutton = (frame.width - buttonWidth) / 2

        button.frame = CGRect(
            x: minXbutton,
            y: messageLabel.frame.maxY + buttonSpacing,
            width: buttonWidth,
            height: Layout.preferredButtonHeight
        )
    }

    @objc private func buttonTapped(_ sender: UIButton) {

        delegate?.informationViewDelegateListViewTappedButton(self, with: sender)
    }

    func configure(header: String, message: String?, image: UIImage? = nil, buttonTitle: String? = nil) {

        messageHeaderLabel.text = header
        messageLabel.text = message

        if image == nil {
            loadingIndicatorView.startAnimating()
            imageView.isHidden = true
        } else {
            loadingIndicatorView.stopAnimating()
            imageView.isHidden = false
            imageView.image = image
        }

        if let buttonTitle = buttonTitle {
            button.isHidden = false
            button.setTitle(buttonTitle, for: .normal)
        } else {
            button.isHidden = true
        }

        setNeedsLayout()
    }
}
