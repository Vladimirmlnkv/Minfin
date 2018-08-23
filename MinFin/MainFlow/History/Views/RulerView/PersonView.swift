//
//  RulerView.swift
//  MinFin
//
//  Created by Владимир Мельников on 22/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class PersonView: UIView {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var blurView: UIVisualEffectView!
    
    static let viewHeight: CGFloat = 111.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib("PersonView")
        updateCornersRadiuses()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib("PersonView")
        updateCornersRadiuses()
    }
    
    func updateCornersRadiuses() {
        clipsToBounds = true
        layer.cornerRadius = 10.0
    }
}
