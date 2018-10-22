//
//  OnboardingInfoViewController.swift
//  MinFin
//
//  Created by Владимир Мельников on 02/09/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

protocol OnboardingViewControllerDelegate {
    func didPressContune(on vc: UIViewController)
    func didPressSkip(on vc: UIViewController)
}

class OnboardingInfoViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    var image: UIImage!
    var delegate: OnboardingViewControllerDelegate!
    @IBOutlet var continueButton: UIButton!
    @IBOutlet var skipButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        continueButton.layer.cornerRadius = 10.0
        skipButton.layer.cornerRadius = 10.0
    }
    
    @IBAction func continueButtonAction(_ sender: Any) {
        delegate.didPressContune(on: self)
    }
    
    @IBAction func skipButtonAction(_ sender: Any) {
        delegate.didPressSkip(on: self)
    }
    
    
}
