//
//  Book.swift
//  MinFin
//
//  Created by Владимир Мельников on 24/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import Foundation

class Book {
    let title: String
    let author: String
    let year: Int
    let shortDescription: String
    let longDescription: String
    let fileName: String
    let headings: [Heading]
    
    init(title: String, author: String, year: Int, shortDescription: String, longDescription: String, fileName: String, headings: [Heading] ) {
        self.title = title
        self.author = author
        self.year = year
        self.shortDescription = shortDescription
        self.longDescription = longDescription
        self.fileName = fileName
        self.headings = headings
    }
}

class Heading {
    let displayName: String
    var code: String?
    
    init(displayName: String) {
        self.displayName = displayName
    }
}
