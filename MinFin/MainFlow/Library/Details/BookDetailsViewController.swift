//
//  BookDetailsViewController.swift
//  MinFin
//
//  Created by Владимир Мельников on 21/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit
import RealmSwift

protocol ImageLoader { }
extension ImageLoader {
    func convertPDFPageToImage(url: URL, completion: @escaping (UIImage?) -> Void ) {
        DispatchQueue.global(qos: .background).async {
            do {
                let pdfdata = try NSData(contentsOfFile: url.path, options: NSData.ReadingOptions.init(rawValue: 0))
                
                let pdfData = pdfdata as CFData
                let provider:CGDataProvider = CGDataProvider(data: pdfData)!
                let pdfDoc:CGPDFDocument = CGPDFDocument(provider)!
                let pdfPage:CGPDFPage = pdfDoc.page(at: 1)!
                var pageRect:CGRect = pdfPage.getBoxRect(.mediaBox)
                pageRect.size = CGSize(width:pageRect.size.width, height:pageRect.size.height)
                
                UIGraphicsBeginImageContext(pageRect.size)
                let context:CGContext = UIGraphicsGetCurrentContext()!
                context.saveGState()
                context.translateBy(x: 0.0, y: pageRect.size.height)
                context.scaleBy(x: 1.0, y: -1.0)
                context.concatenate(pdfPage.getDrawingTransform(.mediaBox, rect: pageRect, rotate: 0, preserveAspectRatio: true))
                context.drawPDFPage(pdfPage)
                context.restoreGState()
                let pdfImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
                DispatchQueue.main.async {
                    completion(pdfImage)
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}

class BookDetailsViewController: UIViewController, ImageLoader {

    @IBOutlet var bookNameLabel: UILabel!
    @IBOutlet var authorNameLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    
    @IBOutlet var mainTitleLabel: UILabel!
    @IBOutlet var authorDescriptionLabel: UILabel!
    @IBOutlet var yearDescriptionLabel: UILabel!
    @IBOutlet var downloadButton: UIButton!
    @IBOutlet var openButton: UIButton!
    
    @IBOutlet var aboutTitleLabel: UILabel!
    @IBOutlet var aboutDescriptionLabel: UILabel!
    @IBOutlet var tagsLabel: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var contentView: UIView!
    @IBOutlet var openButtonWidthConstraitn: NSLayoutConstraint!
    @IBOutlet var bookImageView: UIImageView!
    
    var book: Book!
    var headings: [Heading]!
    var booksLoader: BooksLoader!
    
    private var deleteBarButtonItem: UIBarButtonItem!
    
    var documentController: UIDocumentInteractionController!    
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var downloadButtonWidthConstraint: NSLayoutConstraint!
    private var bookMarkBarButtonItem: UIBarButtonItem!
    private var shareBarButtonItem: UIBarButtonItem!
    private var openButtonDefaultWidth: CGFloat = 120.0
    private let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let transform = CGAffineTransform(scaleX: 1, y: 4)
        
        deleteBarButtonItem = UIBarButtonItem(image: UIImage(named: "icons8-trash-50"), landscapeImagePhone: UIImage(named: "icons8-trash-50"), style: .done, target: self, action: #selector(deleteButtonAction))
        shareBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareAction))
        shareBarButtonItem.tintColor = Color.mainTextColor
        setBarButtonItems()
        
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
        
        if let longDescription = book.longDescription {
            aboutDescriptionLabel.text = longDescription
        } else {
            aboutDescriptionLabel.text = book.shortDescription
        }
        
        if let heading = headings.filter({$0.code == book.headingCode}).first {
            tagsLabel.text = heading.displayName
        }
        
        if fileExists() {
            setOpenButton()
            if let data = book.imageData, let image = UIImage(data: data) {
                self.setImage(image: image)
            }
        } else {
            downloadButton.setTitle(AppLanguage.download.customLocalized(), for: .normal)
        }

    }
    
    private func setBarButtonItems() {
        let imageName = book.isBookmarked ? "starFull": "star"
        bookMarkBarButtonItem = UIBarButtonItem(image: UIImage(named: imageName), style: .done, target: self, action: #selector(addBookmarkAction))
        if fileExists() {
            navigationItem.rightBarButtonItems = [bookMarkBarButtonItem, shareBarButtonItem, deleteBarButtonItem]
        } else {
            navigationItem.rightBarButtonItems = [bookMarkBarButtonItem, shareBarButtonItem]
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        booksLoader.stopBookLoad()
    }
    
    private func restoreImage() {
        bookImageView.image = UIImage(named: "book")
        bookNameLabel.isHidden = false
        authorNameLabel.isHidden = false
        yearLabel.isHidden = false
    }
    
    private func setImage(image: UIImage) {
        bookImageView.image = image
        bookNameLabel.isHidden = true
        authorNameLabel.isHidden = true
        yearLabel.isHidden = true
    }
    
    private func restoreDownloadButton() {
        downloadButton.setTitle(AppLanguage.download.customLocalized(), for: .normal)
        downloadButton.setImage(nil, for: .normal)
        progressView.isHidden = true
        setBarButtonItems()
        openButton.isHidden = true
        UIView.animate(withDuration: 0.3, animations: {
            self.downloadButtonWidthConstraint.constant = self.openButtonDefaultWidth
            self.contentView.layoutIfNeeded()
        })
        restoreImage()
    }
    
    @objc func addBookmarkAction() {
        try! realm.write {
            book.isBookmarked = !book.isBookmarked
        }
        setBarButtonItems()
    }
    
    @objc func shareAction() {
        let text = String(format: AppLanguage.share_text.customLocalized(), book.title, book.author, "google.com")
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
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
        if #available(iOS 11.0, *) {
            downloadButton.setTitle(AppLanguage.open_in.customLocalized(), for: .normal)
            openButton.isHidden = false
            openButton.layer.cornerRadius = downloadButton.layer.cornerRadius
            openButton.setTitle(AppLanguage.open.customLocalized(), for: .normal)
            openButton.addTarget(self, action: #selector(openButtonAction), for: .touchUpInside)
        } else {
            openButtonWidthConstraitn.constant = 0
        }
        setBarButtonItems()
    }
    
    @objc func openButtonAction() {
        if #available(iOS 11.0, *) {
            if let url = book.getDocUrl(), FileManager.default.fileExists(atPath: url.path) {
                if let data = FileManager.default.contents(atPath: url.path) {
                    let vc = storyboard?.instantiateViewController(withIdentifier: "BookReaderViewController") as! BookReaderViewController
                    vc.lastPage = book.lastPage
                    vc.bookData = data
                    vc.bookTitle = title
                    vc.delegate = self
                    navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    private func fileExists() -> Bool {
        if let url = book.getDocUrl(), FileManager.default.fileExists(atPath: url.path) {
            return true
        }
        return false
    }
    
    @objc func deleteButtonAction() {
        if let url = book.getDocUrl(), FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(at: url)
                restoreDownloadButton()
                try! realm.write {
                    self.book.imageData = nil
                    self.book.lastPage = 0
                }
            } catch {
                print(error)
            }
            
        }
        
    }
    
    @IBAction func downloadButtonAction(_ sender: Any) {
        
        if booksLoader.isLoading {
            booksLoader.stopBookLoad()
            restoreDownloadButton()
        } else {
            if let url = book.getDocUrl(), FileManager.default.fileExists(atPath: url.path) {
                    self.documentController = UIDocumentInteractionController(url: url)
                    let booksUrl = URL(string:"itms-books:")!
                    if UIApplication.shared.canOpenURL(booksUrl) {
                        self.documentController.presentOpenInMenu(from: self.downloadButton.frame, in: self.view, animated: true)
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
                
                booksLoader.load(fileName: book.fileName, progressClosure: { progress in
                    self.progressView.progress = Float(progress)
                }) { result in
                    switch result {
                    case .failure:
                        self.restoreDownloadButton()
                    case .success(_ ):
                        self.setOpenButton()
                        self.convertPDFPageToImage(url: self.book.getDocUrl()!) { (image) in
                            if let image = image {
                                self.setImage(image: image)
                                try! self.realm.write {
                                    self.book.imageData = UIImagePNGRepresentation(image)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    

}

extension BookDetailsViewController: BookReaderViewControllerDelegate {
    
    func savePage(index: Int) {
        try! realm.write {
            book.lastPage = index
        }
    }
    
}
