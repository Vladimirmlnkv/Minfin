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
    
    weak var delegate: FinalOnboardingViewControllerDelegate?

}
