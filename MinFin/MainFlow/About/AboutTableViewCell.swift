//
//  AboutTableViewCell.swift
//  MinFin
//
//  Created by Владимир Мельников on 23/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

protocol AboutTableViewCellDelegate {
    func didPressLinkButton(in cell: AboutTableViewCell)
}

class AboutTableViewCell: UITableViewCell {

    @IBOutlet var blurView: UIVisualEffectView!
    @IBOutlet var mainTitleLabel: UILabel!
    @IBOutlet var descriptionTitleLabel: UILabel!
    @IBOutlet var linkButton: UIButton!
    
    var delegate: AboutTableViewCellDelegate!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        blurView.clipsToBounds = true
        blurView.layer.cornerRadius = 10.0
    }
    
    @IBAction func linkButtonAction(_ sender: Any) {
        delegate.didPressLinkButton(in: self)
    }
    

}
