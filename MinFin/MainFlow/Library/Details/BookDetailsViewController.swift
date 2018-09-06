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
    
    var documentController: UIDocumentInteractionController!    
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var downloadButtonWidthConstraint: NSLayoutConstraint!
    private var openButtonDefaultWidth: CGFloat = 120.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let transform = CGAffineTransform(scaleX: 1, y: 4)
        
        let shareBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareAction))
        shareBarButtonItem.tintColor = Color.mainTextColor
        navigationItem.rightBarButtonItem = shareBarButtonItem
        
        progressView.transform = transform
        progressView.isHidden = true
        progressView.layer.cornerRadius = 5.0
        addBackgroundView()
        downloadButton.layer.cornerRadius = 15.0
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
    
    private func restoreDownloadButton() {
        downloadButton.setTitle(AppLanguage.download.customLocalized(), for: .normal)
        downloadButton.setImage(nil, for: .normal)
        progressView.isHidden = true
        UIView.animate(withDuration: 0.3, animations: {
            self.downloadButtonWidthConstraint.constant = self.openButtonDefaultWidth
            self.contentView.layoutIfNeeded()
        })
    }
    
    @objc func shareAction() {
        let activityTest = "Я читаю книгу \(book.title) в приложении Минфин.История.\nВставить нужный текст.\nСкачайте приложение по ссылке"
        let activityVC = UIActivityViewController(activityItems: [activityTest], applicationActivities: nil)
        activityVC.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(activityVC, animated: true, completion: nil)
    }
    
    private func setOpenButton() {
        downloadButton.setTitle(AppLanguage.open.customLocalized(), for: .normal)
        downloadButton.setImage(nil, for: .normal)
        progressView.isHidden = true
        if downloadButtonWidthConstraint.constant != openButtonDefaultWidth {
            UIView.animate(withDuration: 0.3, animations: {
                self.downloadButtonWidthConstraint.constant = self.openButtonDefaultWidth
                self.contentView.layoutIfNeeded()
            })
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
        
        if booksLoader.isLoading {
            booksLoader.stopBookLoad()
            restoreDownloadButton()
        } else {
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
                UIView.animate(withDuration: 0.3, animations: {
                    self.downloadButton.setImage(#imageLiteral(resourceName: "stop"), for: .normal)
                    self.downloadButton.setTitle("", for: .normal)
                    self.downloadButtonWidthConstraint.constant = 30.0
                    self.progressView.isHidden = false
                    self.progressView.progress = 0
                    self.contentView.layoutIfNeeded()
                })
                
                booksLoader.load(fileName: book.fileName, bookName: title, progressClosure: { progress in
                    self.progressView.progress = Float(progress)
                }) { result in
                    switch result {
                    case .failure:
                        self.restoreDownloadButton()
                    case .success(_ ):
                        self.setOpenButton()
                    }
                }
            }
        }
    }
    

}
