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
                MeteoriteDetailView.DetailItem(title: "Mass", text: "\(Formatter.formatWeight(meteorite.mass)) g"),
                MeteoriteDetailView.DetailItem(title: "Fall", text: meteorite.fall),
                MeteoriteDetailView.DetailItem(title: "Latitutde", text: Formatter.formatCoordinate(meteorite.latitude)),
                MeteoriteDetailView.DetailItem(title: "Longitude", text: Formatter.formatCoordinate(meteorite.longitude))
            ],
            annotation: annotationFrom(meteorite: meteorite)
        )
    }

    private func coordinateFrom(meteorite: CDMeteorite) -> CLLocationCoordinate2D? {

        if meteorite.latitude == 0.0, meteorite.longitude == 0.0 {
            return nil
        }

        return CLLocationCoordinate2D(latitude: meteorite.latitude, longitude: meteorite.longitude)
    }

    private func annotationFrom(meteorite: CDMeteorite) -> MKPointAnnotation? {

        guard let coordinate = coordinateFrom(meteorite: meteorite) else { return nil }

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate

        return annotation
    }
}

extension MeteoriteDetailViewController: MeteoriteDetailViewDelegate {

    func meteoriteDetailView(_ view: MeteoriteDetailView, didTouch mapView: MKMapView) {

        guard let coordinate = coordinateFrom(meteorite: meteorite) else { return }

        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
        mapItem.name = meteorite.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsMapTypeKey : MKMapType.hybrid.rawValue])
    }
}