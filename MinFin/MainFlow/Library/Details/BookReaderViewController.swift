//
//  BookReaderViewController.swift
//  MinFin
//
//  Created by Владимир Мельников on 30/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit
import PDFKit

protocol BookReaderViewControllerDelegate {
    func savePage(index: Int)
}

@available(iOS 11.0, *)
class BookReaderViewController: UIViewController {
    
    var bookURL: URL!
    var bookData: Data!
    var bookTitle: String!
    var pdfView: PDFView!
    var delegate: BookReaderViewControllerDelegate!
    var lastPage: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackgroundView()
        navigationItem.title = bookTitle
        
        pdfView = PDFView(frame: view.frame)
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)
        pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        pdfView.document = PDFDocument(data: bookData)
        
        
        if let page = pdfView.document?.page(at: lastPage) {
            pdfView.go(to: page)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let currentPage = pdfView.currentPage, let index = pdfView.document?.index(for: currentPage) {
            delegate.savePage(index: index)
        }
    }


}
