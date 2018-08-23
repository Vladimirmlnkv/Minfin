//
//  MainBackgroundView.swift
//  MinFin
//
//  Created by Владимир Мельников on 23/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class MainBackgroundView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib("MainBackgroundView")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib("MainBackgroundView")
    }

}
