//
//  ClusterDetailsContainerView.swift
//  MinFin
//
//  Created by Владимир Мельников on 25/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class ClusterDetailsContainerView: UIView {

    @IBOutlet var mainView: UIView!
    @IBOutlet var blurView: UIVisualEffectView!
    @IBOutlet var collectionView: UICollectionView!
    
    var cluster: Cluster!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib("ClusterDetailsContainerView")
        updateCornerRadiuses()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib("ClusterDetailsContainerView")
        updateCornerRadiuses()
    }
    
    private func updateCornerRadiuses() {
        mainView.layer.cornerRadius = 10.0
        clipsToBounds = true
        layer.cornerRadius = 10.0
        blurView.clipsToBounds = true
        blurView.layer.cornerRadius = 10.0
    }

}
