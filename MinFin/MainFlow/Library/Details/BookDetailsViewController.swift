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
    
    var book: Book!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackgroundView()
        downloadButton.layer.cornerRadius = 15.0
        
        bookNameLabel.text = book.title
        authorNameLabel.text = book.author
        yearLabel.text = "\(book.year) год"
        
        mainTitleLabel.text = book.title
        authorDescriptionLabel.text = book.author
        yearDescriptionLabel.text = "\(book.year) год"
        
        aboutDescriptionLabel.text = book.longDescription
    }

    
    @IBAction func downloadButtonAction(_ sender: Any) {
        
    }
    

}
