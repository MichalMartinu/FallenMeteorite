//
//  FirstLaunchInfromationViewController.swift
//  FallenMeteorite
//
//  Created by Michal Martinů on 14/11/2019.
//  Copyright © 2019 Michal Martinů. All rights reserved.
//

import UIKit

protocol AppIntroductionViewControllerDelegate: AnyObject {

    func appIntroductionViewControllerDismiss(_ controller: AppIntroductionViewController)
}

final class AppIntroductionViewController: UIViewController {

    weak var delegate: AppIntroductionViewControllerDelegate?

    private lazy var rootView: InformationView = {
        let view = InformationView()
        view.delegate = self
        view.configure(header: header, message: message, image: image, buttonTitle: buttonTitle)
        view.backgroundColor = CustomColor.color(.backgroundGray)
        return view
    }()

    private let header = "Welcome to fallen meteorite"
    private let message = "This application would show you fallen meteorites on Earth since year 2011 sorted by weight descending. Application updates data automatically."
    private let buttonTitle = "That is cool"
    private let image = Images.image(.meteorite)


    override func loadView() {
        super.loadView()

        view = rootView
    }
}

extension AppIntroductionViewController: InformationViewDelegate {

    func informationViewDelegateListViewTappedButton(_ view: InformationView, with button: UIButton) {

        delegate?.appIntroductionViewControllerDismiss(self)
    }
}
