//
//  FirstLaunchInfromationViewController.swift
//  FallenMeteorite
//
//  Created by Michal Martinů on 14/11/2019.
//  Copyright © 2019 Michal Martinů. All rights reserved.
//

import UIKit

protocol FirstLaunchInformationViewControllerDelegate: AnyObject {

    func firstLaunchInformationViewControllerDismiss(_ controller: FirstLaunchInformationViewController)
    func firstLaunchInformationViewControllerDidDissapear(_ controller: FirstLaunchInformationViewController)
}

final class FirstLaunchInformationViewController: UIViewController {

    weak var delegate: FirstLaunchInformationViewControllerDelegate?

    private let rootView = InformationView()

    private let header = "Welcome to fallen meteorite"
    private let message = "This application would show you meteorites fallen on Earth from year 2011 sorted by weigh descending. Application updates data automatically."
    private let buttonTitle = "That is cool"
    private let image = Images.image(.meteorite)


    override func loadView() {
        super.loadView()

        rootView.delegate = self
        rootView.configure(header: header, message: message, image: image, buttonTitle: buttonTitle)
        rootView.backgroundColor = CustomColor.color(.backgroundGray)
        
        view = rootView
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        delegate?.firstLaunchInformationViewControllerDidDissapear(self)
    }
}

extension FirstLaunchInformationViewController: InformationViewDelegate {

    func informationViewDelegateListViewTappedButton(_ view: InformationView, with button: UIButton) {
        delegate?.firstLaunchInformationViewControllerDismiss(self)
    }
}
