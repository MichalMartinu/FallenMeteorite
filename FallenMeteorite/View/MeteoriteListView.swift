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
                    header: AppStrings.emptyHeader.rawValue,
                    message: AppStrings.emptyMessage.rawValue,
                    image: Images.image(.meteorite)
                )
            case .loading:
                informationView.configure(
                    header: AppStrings.loadingHeader.rawValue,
                    message: AppStrings.loadingMessage.rawValue
            )
            case .offline:
                informationView.configure(
                    header: AppStrings.offlineHeader.rawValue,
                    message: AppStrings.offlineMessage.rawValue,
                    image: Images.image(.meteorite),
                    buttonTitle: AppStrings.tryAgain.rawValue
                )
            case .error:
                informationView.configure(
                    header: AppStrings.errorHeader.rawValue,
                    message: message,
                    image: Images.image(.meteorite),
                    buttonTitle: AppStrings.tryAgain.rawValue
                )
        }
    }
}

extension MeteoriteListView: InformationViewDelegate {

    func informationViewDelegateListViewTappedButton(_ view: InformationView, with button: UIButton) {
        delegate?.meteoriteListViewTappedButton(self, with: button)
    }
}
