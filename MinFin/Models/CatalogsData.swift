//
//  CatalogsData.swift
//  MinFin
//
//  Created by Владимир Мельников on 29/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import Foundation

class CatalogsData {
    let books: [Book]
    let headings: [Heading]
    
    init(books: [Book], headings: [Heading]) {
        self.books = books
        self.headings = headings
    }
    
    init(json: [String: Any]) {
        let booksData = json["books"] as! [[String: Any]]
        let headingsData = json["headings"] as! [[String: Any]]
        books = booksData.map { Book(json: $0) }
        headings = headingsData.map { Heading(json: $0) }
    }
}
