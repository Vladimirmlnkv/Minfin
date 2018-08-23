//
//  AboutHeaderView.swift
//  MinFin
//
//  Created by Владимир Мельников on 23/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class AboutHeaderView: UIView {

    @IBOutlet var titleLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib("AboutHeaderView")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib("AboutHeaderView")
    }
    
    
}
