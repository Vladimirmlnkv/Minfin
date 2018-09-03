//
//  ClusterDetailsCollectionViewCell.swift
//  MinFin
//
//  Created by Владимир Мельников on 25/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class ClusterDetailsCollectionViewCell: UICollectionViewCell {

    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var animateView: UIView!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        animateView.layer.cornerRadius = 10.0
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                UIView.animate(withDuration: 0.3, animations: {
                    self.animateView.alpha = 0.5
                })
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.animateView.alpha = 0
                })
            }
        }
    }

}
