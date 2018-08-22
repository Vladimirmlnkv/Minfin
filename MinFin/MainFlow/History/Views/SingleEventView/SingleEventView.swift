//
//  SingleEventView.swift
//  MinFin
//
//  Created by Владимир Мельников on 22/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class SingleEventView: UIView {
    
    @IBOutlet var avatarContainerView: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var avatarBlurView: UIVisualEffectView!
    
    @IBOutlet var labelContainerView: UIView!
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var dotView: UIView!
    
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
    
    private func updateCornerRadiuses() {
        avatarBlurView.clipsToBounds = true
        avatarBlurView.layer.cornerRadius = avatarBlurView.bounds.width / 2
        dotView.layer.cornerRadius = dotView.bounds.width / 2
        avatarContainerView.layer.cornerRadius = avatarContainerView.bounds.width / 2
        labelContainerView.layer.cornerRadius = labelContainerView.bounds.width / 2
    }
}
