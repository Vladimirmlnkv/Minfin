//
//  UIViewControllerExtension.swift
//  MinFin
//
//  Created by Владимир Мельников on 23/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func addBackgroundView() {
        
        let backgroundView = MainBackgroundView(frame: view.frame)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(backgroundView, at: 0)
        let topConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: backgroundView, attribute: .top, multiplier: 1.0, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: backgroundView, attribute: .bottom, multiplier: 1.0, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: backgroundView, attribute: .leading, multiplier: 1.0, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: backgroundView, attribute: .trailing, multiplier: 1.0, constant: 0)
        view.addConstraints([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
    }
    
}
