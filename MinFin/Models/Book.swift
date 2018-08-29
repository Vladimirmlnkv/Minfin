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
    let headingCode: Int
    
    init(title: String, author: String, year: Int, shortDescription: String, longDescription: String, fileName: String, heading: Int) {
        self.title = title
        self.author = author
        self.year = year
        self.shortDescription = shortDescription
        self.longDescription = longDescription
        self.fileName = fileName
        self.headingCode = heading
    }
    
    init(json: [String: Any]) {
        title = json["title"] as! String
        author = json["author"] as! String
        year = json["year"] as! Int
        shortDescription = json["shortDescription"] as! String
        longDescription = json["longDescription"] as! String
        fileName = json["fileName"] as! String
        headingCode = json["headingCode"] as! Int
    }
}

class Heading {
    let displayName: String
    var code: Int = 0
    
    init(displayName: String) {
        self.displayName = displayName
    }
    
    init(json: [String: Any]) {
        displayName = json["displayName"] as! String
        code = json["code"] as! Int
    }
}
