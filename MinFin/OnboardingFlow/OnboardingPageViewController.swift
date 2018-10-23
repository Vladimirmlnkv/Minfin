//
//  OnboardingPageViewController.swift
//  MinFin
//
//  Created by Владимир Мельников on 09/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class OnboardingPageViewController: UIPageViewController {
    
    fileprivate lazy var onboardingViewControllers: [UIViewController] = {
        let sb = UIStoryboard(name: "Onboarding", bundle: nil)
        
        let firstVC = sb.instantiateViewController(withIdentifier: "FirstOnboardingViewController") as! FirstOnboardingViewController
        firstVC.delegate = self
        
        let secondVC = sb.instantiateViewController(withIdentifier: "OnboardingInfoViewController1") as! OnboardingInfoViewController
        secondVC.delegate = self
        
        let thirdVC = sb.instantiateViewController(withIdentifier: "OnboardingInfoViewController2") as! OnboardingInfoViewController
        thirdVC.delegate = self
        
        let fourthVC = sb.instantiateViewController(withIdentifier: "OnboardingInfoViewController3") as! OnboardingInfoViewController
        fourthVC.delegate = self
        
        let fifthVC = sb.instantiateViewController(withIdentifier: "OnboardingInfoViewController4") as! OnboardingInfoViewController
        fifthVC.delegate = self
        
        let finalVC = sb.instantiateViewController(withIdentifier: "FinalOnboardingViewController") as! FinalOnboardingViewController
        finalVC.delegate = self
        
        return [firstVC, secondVC, thirdVC, fourthVC, fifthVC, finalVC]
    }()
    var currentIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        addBackgroundView()
        UIPageControl.appearance().tintColor = Color.mainTextColor
        dataSource = self
        if let firstVC = onboardingViewControllers.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func endOnboarding() {
        UserDefaults.standard.set(false, forKey: (UIApplication.shared.delegate! as! AppDelegate).isFirstLaunchKey)
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let startVC = mainStoryboard.instantiateInitialViewController()
        UIApplication.shared.delegate!.window!!.rootViewController = startVC
    }
}

extension OnboardingPageViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = onboardingViewControllers.index(of: viewController) else { return nil }
        let previousIndex = index - 1
        guard previousIndex >= 0 else { return nil }
        guard onboardingViewControllers.count > previousIndex else { return nil }
        return onboardingViewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = onboardingViewControllers.index(of: viewController) else { return nil }
        let nextIndex = index + 1
        guard nextIndex != onboardingViewControllers.count else { return nil }
        guard onboardingViewControllers.count > nextIndex  else { return nil }
        return onboardingViewControllers[nextIndex]
    }

//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return onboardingViewControllers.count
//    }
//
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        if let currentIndex = currentIndex {
//            return currentIndex
//        }
//        return 0
//    }
}

extension OnboardingPageViewController: FinalOnboardingViewControllerDelegate {
    
    func didPressStart() {
        endOnboarding()
    }
    
}

extension OnboardingPageViewController: OnboardingViewControllerDelegate {
    
    func didPressContune(on vc: UIViewController) {
        if let index = onboardingViewControllers.index(of: vc) {
            if index == onboardingViewControllers.endIndex - 1 {
                endOnboarding()
            } else {
                currentIndex = index + 1
                setViewControllers([onboardingViewControllers[index.advanced(by: 1)]], direction: .forward, animated: true, completion: nil)
            }
        }
    }
    
    func didPressSkip(on vc: UIViewController) {
        endOnboarding()
    }
        
}
