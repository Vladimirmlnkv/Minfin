//
//  BookmarksViewController.swift
//  MinFin
//
//  Created by Владимир Мельников on 08/10/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit
import RealmSwift

class BookmarksViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    private var books = [Book]()
    private var headings: [Heading]!
    var realm: Realm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackgroundView()
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let predicate = NSPredicate(format: "isBookmarked == YES", "")
        if let catalog = realm.objects(CatalogsData.self).first {
            books = Array(catalog.books.filter(predicate))
            headings = Array(catalog.headings)
            tableView.reloadData()
        }
    }
}

extension BookmarksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailsVC = storyboard?.instantiateViewController(withIdentifier: "BookDetailsViewController") as! BookDetailsViewController
        detailsVC.book = books[indexPath.row]
        detailsVC.headings = headings
        detailsVC.booksLoader = LibraryDataSource()
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

extension BookmarksViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkCell", for: indexPath) as! BookmarkCell
        let book = books[indexPath.row]
        cell.bookTitleLabel.text = book.title
        cell.delegate = self
        if let imageData = book.imageData {
            cell.bookImage.image = UIImage(data: imageData)
        } else {
            cell.bookImage.image = UIImage(named: "book")
        }
        
        return cell
    }
    
}

extension BookmarksViewController: BookmarkCellDelegate {
    
    func didPressCrossButton(for cell: BookmarkCell) {
        if let indexPath = tableView.indexPathForRow(at: cell.center) {
            let book = books[indexPath.row]
            try! realm.write {
                book.isBookmarked = false
            }
            books.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.endUpdates()
        }
    }
    
}
