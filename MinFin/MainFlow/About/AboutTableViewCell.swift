//
//  AboutTableViewCell.swift
//  MinFin
//
//  Created by Владимир Мельников on 23/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class AboutTableViewCell: UITableViewCell {

    @IBOutlet var blurView: UIVisualEffectView!
    @IBOutlet var mainTitleLabel: UILabel!
    @IBOutlet var descriptionTitleLabel: UILabel!
    @IBOutlet var linkButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        blurView.layer.cornerRadius = blurView.bounds.width / 2
        linkButton.layer.cornerRadius = 10.0
    }
    
    @IBAction func linkButtonAction(_ sender: Any) {
        
    }
    

}
