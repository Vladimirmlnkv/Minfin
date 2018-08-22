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
    
    static let viewHeight: CGFloat = 111.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib("PersonView")
        layer.cornerRadius = bounds.width / 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib("PersonView")
        layer.cornerRadius = bounds.width / 2
    }
    
}
