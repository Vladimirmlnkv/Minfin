//
//  CatalogsData.swift
//  MinFin
//
//  Created by Владимир Мельников on 29/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import RealmSwift

class CatalogsData: Object {
    
    let books = List<Book>()
    let headings = List<Heading>()
    
    @objc dynamic var booksVersion: Int = 0
    @objc dynamic var headingsVersion: Int = 0
    
    convenience init(books: [Book], headings: [Heading]) {
        self.init()
        self.books.append(objectsIn: books)
        self.headings.append(objectsIn: headings)
    }
    
    convenience init(json: [String: Any]) {
        self.init()
        let booksData = json["books"] as! [[String: Any]]
        let headingsData = json["headings"] as! [[String: Any]]
        books.append(objectsIn: booksData.map { Book(json: $0) })
        headings.append(objectsIn: headingsData.map { Heading(json: $0) })
    }
}
