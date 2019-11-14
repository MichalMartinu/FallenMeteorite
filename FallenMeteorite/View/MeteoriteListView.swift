//
//  MeteoriteLIstView.swift
//  FallenMeteorite
//
//  Created by Michal Martinů on 13/11/2019.
//  Copyright © 2019 Michal Martinů. All rights reserved.
//

import UIKit

final class MeteoriteListView: UIView {

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = CustomColor.color(.lightGray)
        tableView.indicatorStyle = .white
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 66, bottom: 0, right: 0)
        return tableView
    }()

    init() {
        super.init(frame: .zero)

        backgroundColor = CustomColor.color(.background)
        tableView.backgroundColor = CustomColor.color(.background)

        addSubview(tableView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        tableView.frame = frame
    }
}
