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
    var headings: [Heading]!
    var booksLoader: BooksLoader!
    
    var documentController: UIDocumentInteractionController!
    
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
        
        if let heading = headings.filter({$0.code == book.headingCode}).first {
            tagsLabel.text = heading.displayName
        }
        
        if fileExists() {
            downloadButton.setTitle(AppLanguage.open.customLocalized(), for: .normal)
        } else {
            downloadButton.setTitle(AppLanguage.download.customLocalized(), for: .normal)
        }

    }

    private func getBookTitle() -> String {
        let components = book.title.components(separatedBy: " ")
        return components.reduce("", {$0 + $1})
    }
    
    private func fileExists() -> Bool {
        var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).first
        docURL = docURL?.appendingPathComponent("\(getBookTitle()).pdf")
        if let url = docURL, FileManager.default.fileExists(atPath: url.path) {
            return true
        }
        return false
    }
    
    @IBAction func downloadButtonAction(_ sender: Any) {
        let title = getBookTitle()
        var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).first
        docURL = docURL?.appendingPathComponent("\(title).pdf")
        
        if let url = docURL, FileManager.default.fileExists(atPath: url.path) {
            documentController = UIDocumentInteractionController(url: url)
            let booksUrl = URL(string:"itms-books:")!
            if UIApplication.shared.canOpenURL(booksUrl) {
                documentController.presentOpenInMenu(from: downloadButton.frame, in: view, animated: true)
            }
        } else {
            booksLoader.load(fileName: book.fileName, bookName: title) { result in
                switch result {
                case .failure:
                    print("failed to load")
                case .success(_ ):
                    self.downloadButton.setTitle(AppLanguage.open.customLocalized(), for: .normal)
                }
            }
        }
    }
    

}
