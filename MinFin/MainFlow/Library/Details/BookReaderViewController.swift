//
//  BookReaderViewController.swift
//  MinFin
//
//  Created by Владимир Мельников on 30/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class BookReaderViewController: UIViewController {

    @IBOutlet var webView: UIWebView!
    
    var bookURL: URL!
    var bookData: Data!
    var bookTitle: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackgroundView()
        navigationItem.title = bookTitle
        webView.load(bookData, mimeType: "application/pdf", textEncodingName: "", baseURL: bookURL.deletingLastPathComponent())
    }


}
