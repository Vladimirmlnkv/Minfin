//
//  FirstOnboardingViewController.swift
//  MinFin
//
//  Created by Владимир Мельников on 19/10/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class FirstOnboardingViewController: UIViewController {

    @IBOutlet var textLabel: UILabel!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var skipButton: UIButton!
    
    var delegate: OnboardingViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.layer.cornerRadius = 10.0
        skipButton.layer.cornerRadius = 10.0
        textLabel.text = "Добро пожаловать в мобильное приложение «Минфин.История»\nЗдесь вы можете подробно узнать об истории становления и развития Министерства финансов Российской Федерации, а также ознакомиться с редкими изданиями книжного фонда Министерства финансов Российской Федерации"
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        delegate.didPressContune(on: self)
    }
    
    @IBAction func skipButtonAction(_ sender: Any) {
        delegate.didPressSkip(on: self)
    }
    

}
