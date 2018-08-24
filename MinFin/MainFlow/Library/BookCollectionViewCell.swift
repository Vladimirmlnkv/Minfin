//
//  BookCollectionViewCell.swift
//  MinFin
//
//  Created by Владимир Мельников on 21/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

protocol BookCollectionViewCellDelegate {
    func didPressMore(on cell: BookCollectionViewCell)
}

class BookCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var bookNameLabel: UILabel!
    @IBOutlet var authorNameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var mainTitleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var downloadButton: UIButton!
    var delegate: BookCollectionViewCellDelegate!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        downloadButton.layer.cornerRadius = 15.0
    }
    
    
    @IBAction func downloadButtonAction(_ sender: Any) {
        delegate.didPressMore(on: self)
    }
    
}
