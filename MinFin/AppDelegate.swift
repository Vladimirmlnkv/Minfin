//
//  AppDelegate.swift
//  MinFin
//
//  Created by Владимир Мельников on 09/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var orientationLock = UIInterfaceOrientationMask.all
    let isFirstLaunchKey = "isFirstAppLaunchKey"
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.white
        appearance.currentPageIndicatorTintColor = Color.mainTextColor
        
        if UserDefaults.standard.value(forKey: isFirstLaunchKey) == nil {
            let onboardingStoryboard = UIStoryboard(name: "Onboarding", bundle: nil)
            let mainVC = onboardingStoryboard.instantiateViewController(withIdentifier: "OnboardingPageViewController") as! OnboardingPageViewController
            window?.rootViewController = mainVC
        }
        
        return true
    }
}

struct AppUtility {
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        self.lockOrientation(orientation)
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
}
