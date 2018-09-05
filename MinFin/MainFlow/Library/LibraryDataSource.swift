//
//  LibraryDataSource.swift
//  MinFin
//
//  Created by Владимир Мельников on 29/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import Foundation
import Alamofire

enum Result<T> {
    case success(value: T)
    case failure()
}

protocol BooksLoader {
    var isLoading: Bool { get }
    func load(fileName: String, bookName: String, progressClosure: @escaping (Double) -> Void, result: @escaping (Result<Bool>) -> Void)
    func stopBookLoad()
}

class LibraryDataSource: BooksLoader {
    
    private let booksEndpoint = "http://82.196.15.171:8081/books"
    private let versionEndpoit = "http://82.196.15.171:8081/version"
    private var bookRequest: DataRequest?
    
    var isLoading: Bool {
        return bookRequest != nil
    }
    
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
    
    func getCatalogsData(progressClosure: @escaping (Double) -> Void, result: @escaping (Result<CatalogsData>) -> Void) {
        
        Alamofire.request(booksEndpoint, method: .get, encoding: JSONEncoding.default).downloadProgress { (progress) in
            progressClosure(progress.fractionCompleted)
        }.responseData { (resp: DataResponse<Data>) in
            if let data = resp.data, let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
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
    }
    
    func stopBookLoad() {
        if let bookRequest = bookRequest {
            bookRequest.cancel()
            self.bookRequest = nil
        }
    }
    
    func load(fileName: String, bookName: String, progressClosure: @escaping (Double) -> Void, result: @escaping (Result<Bool>) -> Void) {
        
        if let url = URL(string: fileName) {
            bookRequest = Alamofire.request(url, method: .get).downloadProgress(closure: { progress in
                progressClosure(progress.fractionCompleted)
            }).responseData(completionHandler: { [weak self] (response: DataResponse<Data>) in
                switch response.result {
                case .failure( _):
                    DispatchQueue.main.async {
                        result(Result.failure())
                    }
                case .success(let data):
                    var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).first
                    docURL = docURL?.appendingPathComponent("\(bookName).pdf")
                    try! data.write(to: docURL!)
                    DispatchQueue.main.async {
                        result(Result.success(value: true))
                    }
                    self?.bookRequest = nil
                }
            })
        }
    }
}
