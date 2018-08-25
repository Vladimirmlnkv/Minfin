//
//  ClusterView.swift
//  MinFin
//
//  Created by Владимир Мельников on 25/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class ClusterView: UIView {

    @IBOutlet var blurView: UIVisualEffectView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib("ClusterView")
        updateCornerRadiuses()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib("ClusterView")
        updateCornerRadiuses()
    }
    
    private func updateCornerRadiuses() {
        clipsToBounds = true
        layer.cornerRadius = 10.0
        blurView.clipsToBounds = true
        blurView.layer.cornerRadius = blurView.bounds.width / 2
    }
    
}
