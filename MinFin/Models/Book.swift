//
//  Book.swift
//  MinFin
//
//  Created by Владимир Мельников on 24/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import Foundation
import RealmSwift

class Book: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var author: String = ""
    @objc dynamic var year: String = ""
    @objc dynamic var shortDescription: String = ""
    @objc dynamic var longDescription: String = ""
    @objc dynamic var fileName: String = ""
    @objc dynamic var headingCode: Int = 0
    @objc dynamic var imageData: Data?
    @objc dynamic var isBookmarked: Bool = false
    
    convenience init(title: String, author: String, year: String, shortDescription: String, longDescription: String, fileName: String, heading: Int) {
        self.init()
        self.title = title
        self.author = author
        self.year = year
        self.shortDescription = shortDescription
        self.longDescription = longDescription
        self.fileName = fileName
        self.headingCode = heading
    }
    
    convenience init(json: [String: Any]) {
        self.init()
        title = json["title"] as! String
        author = json["author"] as! String
        year = json["year"] as! String
        shortDescription = json["short_description"] as! String
        longDescription = json["long_descritpion"] as! String
        fileName = json["book_id"] as! String
        headingCode = json["heading_code"] as! Int
    }
    
    func getDocUrl() -> URL? {
        var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).first
        docURL = docURL?.appendingPathComponent(fileName)
        return docURL
    }
}

class Heading: Object {
    @objc dynamic var displayName: String = ""
    @objc dynamic var code: Int = 0
    
    convenience init(displayName: String) {
        self.init()
        self.displayName = displayName
    }
    
    convenience init(json: [String: Any]) {
        self.init()
        displayName = json["display_name"] as! String
        code = json["code"] as! Int
    }
}
