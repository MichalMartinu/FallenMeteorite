//
//  MeteoriteLIstView.swift
//  FallenMeteorite
//
//  Created by Michal Martinů on 13/11/2019.
//  Copyright © 2019 Michal Martinů. All rights reserved.
//

import UIKit

protocol MeteoriteListViewDelegate: AnyObject {

    func meteoriteListViewTappedButton(_ view: MeteoriteListView, with button: UIButton)
}

final class MeteoriteListView: UIView {

    enum InformationContentType {
        case empty
        case loading
        case offline
        case error
        case hidden
    }

    weak var delegate: MeteoriteListViewDelegate?

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = CustomColor.color(.lightGray)
        tableView.indicatorStyle = .white
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 66, bottom: 0, right: 0)
        return tableView
    }()

    private lazy var informationView: InformationView = {
        let view = InformationView()
        view.delegate = self
        return view
    }()

    private let loadingHeaderText = "Meteorites are loading"
    private let loadingMessageText = "While this app is loading I would like to tell you:\nHave a good day! :)"

    private let emptyImage = Images.image(.meteoriteIcon)
    private let emptyHeaderText = "There are not meteorites to show"
    private let emptyMessageText = "We cannot find any meteorites in database. :("

    private let errorImage = Images.image(.meteoriteIcon)
    private let errorHeaderText = "Error when loading data"

    private let offlineImage = Images.image(.meteoriteIcon)
    private let offlineHeaderText = "You are Offline"
    private let offlineMessageText = "Please check your internet connection and try your request again."

    private let tryAgainButtonText = "Try again"


    init() {
        super.init(frame: .zero)

        backgroundColor = CustomColor.color(.background)
        tableView.backgroundColor = CustomColor.color(.background)


        [tableView, informationView].forEach{ addSubview($0) }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        informationView.frame = frame
        tableView.frame = frame
    }

    func informationViewContentType(_ contentType: InformationContentType, message: String? = nil) {

        informationView.isHidden = false

        switch contentType {
            case .hidden:
                informationView.isHidden = true
            case .empty:
                informationView.configure(
                    header: emptyHeaderText,
                    message: emptyMessageText,
                    image: emptyImage
                )
            case .loading:
                informationView.configure(header: loadingHeaderText, message: loadingMessageText)
            case .offline:
                informationView.configure(
                    header: offlineHeaderText,
                    message: offlineMessageText,
                    image: offlineImage,
                    buttonTitle: tryAgainButtonText
                )
            case .error:
                informationView.configure(
                    header: errorHeaderText,
                    message: message,
                    image: errorImage,
                    buttonTitle: tryAgainButtonText
                )
        }
    }
}

extension MeteoriteListView: InformationViewDelegate {

    func informationViewDelegateListViewTappedButton(_ view: InformationView, with button: UIButton) {
        delegate?.meteoriteListViewTappedButton(self, with: button)
    }
}
