//
//  StartViewController.swift
//  MinFin
//
//  Created by Владимир Мельников on 03/09/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit
import RealmSwift

class StartViewController: UIViewController {

    @IBOutlet var progressView: UIProgressView!
    var isForceUpdate = false
    
    @IBOutlet var firstTitleLabel: UILabel!
    @IBOutlet var secondTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ministryComponents = AppLanguage.ministry.customLocalized().components(separatedBy: "\n")
        
        firstTitleLabel.text = ministryComponents[0]
        secondTitleLabel.text = ministryComponents[1]
        
        let realm = try! Realm()
        let savedCatalogsData = realm.objects(CatalogsData.self).first
        let dataSource = LibraryDataSource()
        
        dataSource.getVersion { (result: Result<Int>) in
            switch result {
            case .failure:
                self.nextScreen()
            case .success(let version):
                if savedCatalogsData == nil || savedCatalogsData!.version < version {
                    dataSource.getCatalogsData(progressClosure: { (progress) in
                        UIView.animate(withDuration: 0.1, animations: {
                            self.progressView.progress = Float(progress)
                        })
                    }) { (catalogsResult: Result<CatalogsData>) in
                        switch catalogsResult {
                        case .failure:
                            self.nextScreen()
                        case .success(let newCatalogsData):
                            newCatalogsData.version = version
                            try! realm.write {
                                if let s = savedCatalogsData {
                                    for book in s.books {
                                        if let imageData = book.imageData {
                                            let predicate = NSPredicate(format: "title == %@", book.title)
                                            if let index = newCatalogsData.books.index(matching: predicate) {
                                                newCatalogsData.books[index].imageData = imageData
                                                newCatalogsData.books[index].isBookmarked = book.isBookmarked
                                            }
                                        }
                                    }
                                    realm.delete(s)
                                }
                                realm.add(newCatalogsData)
                            }
                            self.nextScreen()
                        }
                    }
                } else {
                    self.progressView.progress = 1.0
                    self.nextScreen()
                }
            }
        }
    }
    
    private func nextScreen() {
        if isForceUpdate {
            dismiss(animated: true, completion: nil)
        } else {
            let vc = storyboard?.instantiateViewController(withIdentifier: "MainNavigationController") as! UINavigationController
            UIApplication.shared.delegate!.window!!.rootViewController = vc
        }
    }
}
