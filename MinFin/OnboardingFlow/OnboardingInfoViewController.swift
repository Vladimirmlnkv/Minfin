//
//  OnboardingInfoViewController.swift
//  MinFin
//
//  Created by Владимир Мельников on 02/09/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

protocol OnboardingInfoViewControllerDelegate {
    func didPressContune(on vc: UIViewController)
    func didPressSkip(on vc: UIViewController)
}

class OnboardingInfoViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var blurView: UIVisualEffectView!
    
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var firstDescriptionLabel: UILabel!
    @IBOutlet var secondDescriptionLabel: UILabel!
    @IBOutlet var continueButton: UIButton!
    @IBOutlet var skipButton: UIButton!
    
    var delegate: OnboardingInfoViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blurView.clipsToBounds = true
        blurView.layer.cornerRadius = blurView.frame.width / 2
        continueButton.layer.cornerRadius = 10.0
    }

    
    @IBAction func continueButtonAction(_ sender: Any) {
        delegate.didPressContune(on: self)
    }
    
    @IBAction func skipButtonAction(_ sender: Any) {
        delegate.didPressSkip(on: self)
    }
    
    
}
