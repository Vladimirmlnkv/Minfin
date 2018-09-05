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
    @IBOutlet var contentView: UIView!
    
    var book: Book!
    var headings: [Heading]!
    var booksLoader: BooksLoader!
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    var documentController: UIDocumentInteractionController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackgroundView()
        downloadButton.layer.cornerRadius = 15.0
        spinner.isHidden = true
        bookNameLabel.text = book.title
        authorNameLabel.text = book.author
        yearLabel.text = "\(book.year) \(AppLanguage.year.customLocalized())"
        
        mainTitleLabel.text = book.title
        authorDescriptionLabel.text = book.author
        yearDescriptionLabel.text = "\(book.year) \(AppLanguage.year.customLocalized())"
        
        aboutDescriptionLabel.text = book.longDescription
        
        if let heading = headings.filter({$0.code == book.headingCode}).first {
            tagsLabel.text = heading.displayName
        }
        
        if fileExists() {
            setOpenButton()
        } else {
            downloadButton.setTitle(AppLanguage.download.customLocalized(), for: .normal)
        }

    }
    
    
    private func setOpenButton() {
        downloadButton.setTitle(AppLanguage.open.customLocalized(), for: .normal)
        spinner.isHidden = true
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
            let title = getBookTitle()
            var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).first
            docURL = docURL?.appendingPathComponent("\(title).pdf")
            if let url = docURL, FileManager.default.fileExists(atPath: url.path) {
                self.documentController = UIDocumentInteractionController(url: url)
                let booksUrl = URL(string:"itms-books:")!
                if UIApplication.shared.canOpenURL(booksUrl) {
                    self.documentController.presentOpenInMenu(from: self.downloadButton.frame, in: self.view, animated: true)
                }
            }
        } else {
            spinner.isHidden = false
            spinner.startAnimating()
            booksLoader.load(fileName: book.fileName, bookName: title) { result in
                switch result {
                case .failure:
                    print("failed to load")
                    self.spinner.isHidden = true
                    let alert = UIAlertController(title: "Error", message: "Can't load book", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                case .success(_ ):
                    self.spinner.isHidden = true
                    self.setOpenButton()
                }
            }
        }
    }
    

}
