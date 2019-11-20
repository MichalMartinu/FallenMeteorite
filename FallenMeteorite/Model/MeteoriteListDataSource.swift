//
//  MeteoriteListDataSource.swift
//  FallenMeteorite
//
//  Created by Michal Martinů on 13/11/2019.
//  Copyright © 2019 Michal Martinů. All rights reserved.
//

import UIKit

final class MeteoriteListDataSource: NSObject, UITableViewDataSource {

    private(set) var meteorites = [CDMeteorite]()

    let totalCountCellIndex = 0

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meteorites.count + 1         // +1 for total count cell
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == totalCountCellIndex {

            let cell = tableView.dequeueReusableCell(
                withIdentifier: MeteoriteTotalCountTableViewCell.identifier, for: indexPath
            ) as! MeteoriteTotalCountTableViewCell

            cell.configure(meteorites.count)
            return cell
        } else {

            let meteorite = meteorites[indexPath.row]

            let cell = tableView.dequeueReusableCell(
                withIdentifier: MeteoriteItemTableViewCell.identifier, for: indexPath
            ) as! MeteoriteItemTableViewCell

            cell.configure(with: meteorite)
            return cell
        }
    }

    func updateData(with meteorites: [CDMeteorite]) {
        self.meteorites = meteorites
    }
}
