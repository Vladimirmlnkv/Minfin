//
//  BookDetailsViewController.swift
//  MinFin
//
//  Created by Владимир Мельников on 21/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class BookDetailsViewController: UIViewController {

    @IBOutlet var bookNameLabel: UILabel!
    @IBOutlet var authorNameLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    
    @IBOutlet var mainTitleLabel: UILabel!
    @IBOutlet var authorDescriptionLabel: UILabel!
    @IBOutlet var yearDescriptionLabel: UILabel!
    @IBOutlet var downloadButton: UIButton!
    
    @IBOutlet var aboutTitleLabel: UILabel!
    @IBOutlet var aboutDescriptionLabel: UILabel!
    @IBOutlet var tagsLabel: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func downloadButtonAction(_ sender: Any) {
        
    }
    

}
