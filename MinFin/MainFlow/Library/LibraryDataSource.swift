//
//  LibraryDataSource.swift
//  MinFin
//
//  Created by Владимир Мельников on 29/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(value: T)
    case failure()
}

protocol BooksLoader {
    func load(fileName: String, bookName: String, result: @escaping (Result<Bool>) -> Void)
}

class LibraryDataSource: BooksLoader {
    
    private let booksEndpoint = "http://82.196.15.171:8081/books"
    private let versionEndpoit = "http://82.196.15.171:8081/version"
    
    func getVersion(result: @escaping (Result<Int>) -> Void) {
        
        let url = URL(string: versionEndpoit)
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            if let data = data, let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                DispatchQueue.main.async {
                    result(Result.success(value: json["currentVersion"] as! Int))
                }
            } else {
                DispatchQueue.main.async {
                    result(Result.failure())
                }
            }
        }        
        task.resume()
    }
    
    func getCatalogsData(result: @escaping (Result<CatalogsData>) -> Void) {
        let url = URL(string: booksEndpoint)
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            if let data = data, let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                DispatchQueue.main.async {
                    let catalogsData = CatalogsData(json: json)
                    result(Result.success(value: catalogsData))
                }
            } else {
                DispatchQueue.main.async {
                    result(Result.failure())
                    
                }
            }
        }
        task.resume()
    }
    
    func load(fileName: String, bookName: String, result: @escaping (Result<Bool>) -> Void) {
        
        if let url = URL(string: fileName) {
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request, completionHandler: { (data, response, _) in
                if let data = data {
                    var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).first
                    docURL = docURL?.appendingPathComponent("\(bookName).pdf")
                    try! data.write(to: docURL!)
                    DispatchQueue.main.async {
                        result(Result.success(value: true))
                    }
                } else {
                    DispatchQueue.main.async {
                        result(Result.failure())
                    }
                }
            })
            task.resume()
        }
    }
}
