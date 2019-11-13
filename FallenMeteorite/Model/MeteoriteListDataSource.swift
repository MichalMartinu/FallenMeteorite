//
//  MeteoriteListDataSource.swift
//  FallenMeteorite
//
//  Created by Michal Martinů on 13/11/2019.
//  Copyright © 2019 Michal Martinů. All rights reserved.
//

import UIKit

final class MeteoriteListDataSource: NSObject, UITableViewDataSource {

    private var meteorites = [CDMeteorite]()

    init(meteorites: [CDMeteorite]) {
        self.meteorites = meteorites
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meteorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let meteorite = meteorites[indexPath.row]

        let cell = tableView.dequeueReusableCell(
            withIdentifier: MeteoriteItemTableViewCell.identifier, for: indexPath
        ) as! MeteoriteItemTableViewCell

        cell.configure(with: meteorite)

        return cell
    }

    func updateData(with meteorites: [CDMeteorite]) {
        self.meteorites = meteorites
    }
}
