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
    @objc dynamic var year: Int = 0
    @objc dynamic var shortDescription: String = ""
    @objc dynamic var longDescription: String = ""
    @objc dynamic var fileName: String = ""
    @objc dynamic var headingCode: Int = 0
    @objc dynamic var imageData: Data?
    @objc dynamic var isBookmarked: Bool = false
    
    convenience init(title: String, author: String, year: Int, shortDescription: String, longDescription: String, fileName: String, heading: Int) {
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
        year = json["year"] as! Int
        shortDescription = json["shortDescription"] as! String
        longDescription = json["longDescription"] as! String
        fileName = json["fileName"] as! String
        headingCode = json["headingCode"] as! Int
    }
    
    func getDocUrl() -> URL? {
        let fileName = self.fileName.components(separatedBy: "/").last!
        var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).first
        docURL = docURL?.appendingPathComponent("\(fileName).pdf")
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
        displayName = json["displayName"] as! String
        code = json["code"] as! Int
    }
}
