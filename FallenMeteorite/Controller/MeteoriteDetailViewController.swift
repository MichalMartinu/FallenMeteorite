//
//  MeteoriteDetailViewController.swift
//  FallenMeteorite
//
//  Created by Michal Martinů on 14/11/2019.
//  Copyright © 2019 Michal Martinů. All rights reserved.
//

import UIKit
import MapKit

final class MeteoriteDetailViewController: UIViewController {

    private lazy var rootView: MeteoriteDetailView = {
        let view = MeteoriteDetailView()
        view.delegate = self
        return view
    }()

    private let meteorite: CDMeteorite

    init(meteorite: CDMeteorite) {

        self.meteorite = meteorite

        super.init(nibName: nil, bundle: nil)

        configureDetailView(with: meteorite)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

        view = rootView
    }

    private func configureDetailView(with meteorite: CDMeteorite) {

        rootView.configure(
            title: meteorite.name,
            year: String(meteorite.year),
            items: [
                MeteoriteDetailView.DetailItem(title: "Recctclass", text: meteorite.recclass),
                MeteoriteDetailView.DetailItem(
                    title: "Mass", text: "\(Formatter.doubleToString(meteorite.mass, maxFractionDigits: 2)) g"
                ),
                MeteoriteDetailView.DetailItem(title: "Fall", text: meteorite.fall),
                MeteoriteDetailView.DetailItem(title: "Latitude", text: Formatter.doubleToString(meteorite.latitude)),
                MeteoriteDetailView.DetailItem(title: "Longitude", text: Formatter.doubleToString(meteorite.longitude))
            ],
            annotation: meteorite.annotation
        )
    }
}

extension MeteoriteDetailViewController: MeteoriteDetailViewDelegate {

    func meteoriteDetailView(_ view: MeteoriteDetailView, didTouch mapView: MKMapView) {

        let mapItem = MKMapItem(placemark: MKPlacemark(
            coordinate: meteorite.coordinate,
            addressDictionary: nil)
        )
        mapItem.name = meteorite.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsMapTypeKey : MKMapType.hybrid.rawValue])
    }
}
