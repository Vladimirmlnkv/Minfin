//
//  RightEventView.swift
//  MinFin
//
//  Created by Владимир Мельников on 23/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class RightEventView: UIView, EventView {

    static let imageSize: CGFloat = 50.0
    static let horizontalSpace: CGFloat = 24.0
    static let viewHeight: CGFloat = 70.0
    
    @IBOutlet var blurView: UIVisualEffectView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var timeLineView: UIView!
    @IBOutlet var timeLineViewWidthConstraint: NSLayoutConstraint!
    
    var event: Event!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib("RightEventView")
        updateCornerRadiuses()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib("RightEventView")
        updateCornerRadiuses()
    }
    
    private func updateCornerRadiuses() {
        clipsToBounds = true
        layer.cornerRadius = 10.0
        blurView.clipsToBounds = true
        blurView.layer.cornerRadius = blurView.bounds.width / 2
    }
    
}
