//
//  FinalOnboardingViewController.swift
//  MinFin
//
//  Created by Владимир Мельников on 09/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

protocol FinalOnboardingViewControllerDelegate: class {
    func didPressStart()
}

class FinalOnboardingViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var startButton: UIButton!
    var delegate: FinalOnboardingViewControllerDelegate!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.layer.cornerRadius = 10.0
        imageView.image = image
    }
    
    @IBAction func startButtonAction(_ sender: Any) {
        delegate.didPressStart()
    }
    
}
