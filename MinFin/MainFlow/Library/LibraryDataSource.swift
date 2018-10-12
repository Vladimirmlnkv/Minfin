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
    func load(fileName: String, progressClosure: @escaping (Double) -> Void, result: @escaping (Result<Bool>) -> Void)
    func stopBookLoad()
}

struct Versions {
    let booksVersion: Int
    let headingsVersion: Int
}

class LibraryDataSource: BooksLoader {
    
    private let booksEndpoint = "https://minfin.fox.wf/api/getExport"
    private let versionEndpoit = "https://minfin.fox.wf/api/getVersion"
    
    //book_id as param
    private let getBookEndpoint = "https://minfin.fox.wf/api/book/%@/download"
    private var bookRequest: DownloadRequest?
    private var sessionManager: Alamofire.SessionManager
    
    var isLoading: Bool {
        return bookRequest != nil
    }
    
    init() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        sessionManager = delegate.backgroundSessionsManager
    }
    
    func getVersion(result: @escaping (Result<Versions>) -> Void) {
        
        let url = URL(string: versionEndpoit)
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            if let data = data, let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let bookVersion = json["booksVersion"] as! Int
                let headingsVersion = json["headingsVersion"] as! Int
                DispatchQueue.main.async {
                    result(Result.success(value: Versions(booksVersion: bookVersion, headingsVersion: headingsVersion)))
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
                    let heading = Heading(displayName: "Все рубрики")
                    heading.code = 0
                    catalogsData.headings.insert(heading, at: 0)
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
    
    func load(fileName: String, progressClosure: @escaping (Double) -> Void, result: @escaping (Result<Bool>) -> Void) {
        if let url = URL(string: String(format: getBookEndpoint, fileName)) {
            
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).first
                docURL = docURL?.appendingPathComponent(fileName)
                return (docURL!, [.removePreviousFile, .createIntermediateDirectories])
            }
            
            bookRequest = sessionManager.download(url, to: destination)
                .downloadProgress(closure: { progress in
                    progressClosure(progress.fractionCompleted)
                })
                .responseData(completionHandler: { [weak self] (response: DownloadResponse<Data>) in
                switch response.result {
                case .failure( _):
                    DispatchQueue.main.async {
                        result(Result.failure())
                    }
                case .success( _):
                    DispatchQueue.main.async {
                        result(Result.success(value: true))
                    }
                    self?.bookRequest = nil
                }
            })
        }
    }
}
