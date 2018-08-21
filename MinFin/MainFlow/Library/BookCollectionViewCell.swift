//
//  BookCollectionViewCell.swift
//  MinFin
//
//  Created by Владимир Мельников on 21/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var bookNameLabel: UILabel!
    @IBOutlet var authorNameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var mainTitleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var downloadButton: UIButton!
    
    
    @IBAction func downloadButtonAction(_ sender: Any) {
    }
    
}
