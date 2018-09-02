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
        
        let firstVC = sb.instantiateViewController(withIdentifier: "OnboardingInfoViewController") as! OnboardingInfoViewController
        firstVC.delegate = self
        let secondVC = sb.instantiateViewController(withIdentifier: "OnboardingInfoViewController") as! OnboardingInfoViewController
        secondVC.delegate = self
        let thirdVC = sb.instantiateViewController(withIdentifier: "OnboardingInfoViewController") as! OnboardingInfoViewController
        thirdVC.delegate = self
        
        return [firstVC, secondVC, thirdVC]
    }()
    var currentIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return onboardingViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        if let currentIndex = currentIndex {
            return currentIndex
        }
        return 0
    }
}

extension OnboardingPageViewController: FinalOnboardingViewControllerDelegate {
    
    func didPressStart() {
        
    }
    
}

extension OnboardingPageViewController: OnboardingInfoViewControllerDelegate {
    
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
