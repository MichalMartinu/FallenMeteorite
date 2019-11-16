//
//  MeteoriteDetailView.swift
//  FallenMeteorite
//
//  Created by Michal Martinů on 15/11/2019.
//  Copyright © 2019 Michal Martinů. All rights reserved.
//

import UIKit
import MapKit

protocol MeteoriteDetailViewDelegate: AnyObject {

    func meteoriteDetailView(_ view: MeteoriteDetailView, didTouch mapView: MKMapView)
}

final class MeteoriteDetailView: UIView {

    struct DetailItem {
        let title: String?
        let text: String?
    }

    weak var delegate: MeteoriteDetailViewDelegate?

    private var orderedViews = [LabelWithDescription]()

    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.layer.cornerRadius = Layout.cornerRadius.large.rawValue
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        mapView.isPitchEnabled = false
        mapView.isRotateEnabled = false
        mapView.mapType = .hybrid
        mapView.delegate = self
        mapView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(mapViewTapped(_:)))
        )
        return mapView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = CustomColor.color(.inkLight)
        return label
    }()

    private let yearLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = CustomColor.color(.yellow)
        return label
    }()

    private let imageView: UIImageView = {
        let imageView = Images.imageView(.meteorite)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let mapZoom: Double = 10000000

    init() {
        super.init(frame: .zero)

        backgroundColor = CustomColor.color(.backgroundGray)

        [titleLabel, yearLabel, imageView, mapView].forEach { addSubview($0) }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let maxViewsWidth = frame.width - 2 * Layout.preferredPadding
        let yearLabelHeight: CGFloat = 20
        let viewsHeight: CGFloat = 16
        let imageSize: CGFloat = 128

        let expectedTitleSize = CGSize(width: maxViewsWidth, height: .greatestFiniteMagnitude)
        let titleLabelSize = titleLabel.sizeThatFits(expectedTitleSize)

        titleLabel.frame = CGRect(
            x: Layout.preferredPadding,
            y: Layout.preferredPadding,
            width: titleLabelSize.width,
            height: titleLabelSize.height
        )

        yearLabel.frame = CGRect(
            x: Layout.preferredPadding,
            y: titleLabel.frame.maxY + Layout.padding.medium.rawValue,
            width: maxViewsWidth,
            height: yearLabelHeight
        )

        if !orderedViews.isEmpty {

            orderedViews[0].frame = CGRect(
                x: Layout.preferredPadding,
                y: yearLabel.frame.maxY + Layout.padding.large.rawValue,
                width: maxViewsWidth,
                height: viewsHeight
            )

            for (index, labelWithView) in orderedViews[1...].enumerated() {
                labelWithView.frame = CGRect(
                    x: Layout.preferredPadding,
                    y: orderedViews[index].frame.maxY + Layout.padding.small.rawValue,
                    width: maxViewsWidth,
                    height: viewsHeight
                )
            }
        }

        let maxYBottomViewPostion = orderedViews.last?.frame.maxY ?? yearLabel.frame.maxY

        let minXImagePosition = (frame.width - imageSize) / 2
        let minYImagePosition = ((frame.height - maxYBottomViewPostion - imageSize) / 2) + maxYBottomViewPostion

        imageView.frame = CGRect(
            x: minXImagePosition,
            y: minYImagePosition,
            width: imageSize,
            height: imageSize
        )
        mapView.frame = CGRect(
            x: Layout.preferredPadding,
            y: maxYBottomViewPostion + Layout.padding.large.rawValue,
            width: maxViewsWidth,
            height: frame.height - maxYBottomViewPostion - Layout.preferredPadding - Layout.padding.large.rawValue
        )
    }

    func configure(title: String?, year: String?, items: [DetailItem], annotation: MKPointAnnotation?) {

        titleLabel.text = title
        yearLabel.text = year

        orderedViews.forEach{ $0.removeFromSuperview() }

        items.forEach {

            let labelWithDescription = LabelWithDescription()
            labelWithDescription.configure(title: $0.title, text: $0.text)
            orderedViews.append(labelWithDescription)
        }

        orderedViews.forEach{ addSubview($0) }

        setNeedsLayout()

        if let annotation = annotation {
            mapView.isHidden = false
            mapView.addAnnotation(annotation)

            let region = MKCoordinateRegion(
                center: annotation.coordinate,
                latitudinalMeters: mapZoom,
                longitudinalMeters: mapZoom
            )

            mapView.setRegion(region, animated: false)
        } else {
            mapView.isHidden = true
        }
    }

    @objc private func mapViewTapped(_ gestureReconizer: UITapGestureRecognizer) {

        delegate?.meteoriteDetailView(self, didTouch: mapView)
    }
}

extension MeteoriteDetailView: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        return MKPinAnnotationView()
    }
}
