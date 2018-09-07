//
//  BookReaderViewController.swift
//  MinFin
//
//  Created by Владимир Мельников on 30/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit
import PDFKit

class BookReaderViewController: UIViewController {
    
    var bookURL: URL!
    var bookData: Data!
    var bookTitle: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackgroundView()
        navigationItem.title = bookTitle
        
        if #available(iOS 11.0, *) {
            let pdfView = PDFView(frame: view.frame)
            pdfView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(pdfView)
            pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
            pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
            pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
            pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            pdfView.document = PDFDocument(data: bookData)
        }
    }


}
