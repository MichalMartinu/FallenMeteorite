//
//  AppIntroductionViewController.swift
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
        view.configure(
            header: AppStrings.introductionHeader.rawValue,
            message: AppStrings.introductionMessage.rawValue,
            image: Images.image(.meteorite),
            buttonTitle: AppStrings.thatIsCool.rawValue
        )
        view.backgroundColor = CustomColor.color(.backgroundGray)
        return view
    }()

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
