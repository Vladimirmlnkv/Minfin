//
//  SingleEventView.swift
//  MinFin
//
//  Created by Владимир Мельников on 22/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

protocol EventView {
    var event: Event! {get set}
    var backgroundViews: [UIView] { get }
}

class SingleEventView: UIView, EventView {
    
    static let viewHeight: CGFloat = 110.0
    static let horizontalSpace: CGFloat = 16.0
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var avatarBlurView: UIVisualEffectView!
    
    @IBOutlet var labelContainerView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var titleBlurView: UIVisualEffectView!
    
    @IBOutlet var dotView: UIView!
    @IBOutlet var imageBackgroundView: UIView!
    @IBOutlet var titleBackgroundView: UIView!
    
    var backgroundViews: [UIView] {
        return [imageBackgroundView, titleBackgroundView]
    }
    
    var event: Event!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib("SingleEventView")
        updateCornerRadiuses()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib("SingleEventView")
        updateCornerRadiuses()
    }
    
    func updateCornerRadiuses() {
        clipsToBounds = true
        imageBackgroundView.layer.cornerRadius = imageBackgroundView.frame.width / 2
        avatarBlurView.clipsToBounds = true
        avatarBlurView.layer.cornerRadius = avatarBlurView.frame.height / 2
        dotView.layer.cornerRadius = dotView.bounds.width / 2
        titleBlurView.clipsToBounds = true
        titleBlurView.layer.cornerRadius = 10.0
        titleBackgroundView.layer.cornerRadius = 10.0
        labelContainerView.layer.cornerRadius = labelContainerView.bounds.width / 2
    }
}
