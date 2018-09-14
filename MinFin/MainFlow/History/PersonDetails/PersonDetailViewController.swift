//
//  PersonDetailViewController.swift
//  MinFin
//
//  Created by Владимир Мельников on 23/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class PersonDetailViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var mainNameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var mainTextLabel: UILabel!
    @IBOutlet var descriptionTextLabel: UILabel!
    
    @IBOutlet var secondNameLabel: UILabel!
    @IBOutlet var linkLabel: UILabel!
    
    var detailInfo: DetailInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackgroundView()
        mainNameLabel.text = detailInfo.displayName
        if detailInfo.photoUrl != "" {
            imageView.image = UIImage(named: detailInfo.photoUrl)
        }
        var dateText = ""
        if let endYear = detailInfo.endYear, endYear != 0 {
            dateText = "\(detailInfo.startYear) - \(endYear) года"
        } else {
            dateText = "\(detailInfo.startYear) год"
        }
        dateLabel.text = dateText
        
        mainTextLabel.text = detailInfo.longDescription
        descriptionTextLabel.text = detailInfo.quote
        if let source = detailInfo.quoteSource, source != "" {
            let components = source.components(separatedBy: "\n")
            secondNameLabel.text = components[0]
            linkLabel.text = components[1]
        } else {
            secondNameLabel.text = nil
            linkLabel.text = nil
        }
    }


}
