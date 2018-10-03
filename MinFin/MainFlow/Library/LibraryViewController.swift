//
//  LibraryViewController.swift
//  MinFin
//
//  Created by Владимир Мельников on 21/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit
import RealmSwift

class LibraryViewController: UIViewController, ImageLoader {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var headerTitleLabel: UILabel!
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var rybrikButton: UIButton!
    
    private var books = [Book]()
    private var booksList = [Book]()
    private var dataSource = LibraryDataSource()
    
    private var headings = [
        Heading(displayName: "Все рубрики"),
        Heading(displayName: "Финансы"),
        Heading(displayName: "Экономина"),
        Heading(displayName: "Юриспруденция"),
        Heading(displayName: "География и этнография"),
        Heading(displayName: "Статистика"),
        Heading(displayName: "История"),
        Heading(displayName: "Сборники и справочники"),
        Heading(displayName: "Зарубежная литература")
    ]
    private var searchIsActive = false
    private var filterHeading: Heading? = nil {
        didSet {
            filterBooksList()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        let savedCatalogsData = realm.objects(CatalogsData.self).first
        if let s = savedCatalogsData {
            self.updateCollectionView(from: s)
        } else {
            self.showNoDataAret()
        }
        clearBackgroundColor()
        addBackgroundView()
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = AppLanguage.library.customLocalized().capitalized
        headerTitleLabel.text = AppLanguage.catalog.customLocalized()
        searchBar.placeholder = AppLanguage.search.customLocalized()
        rybrikButton.setTitle(AppLanguage.headings.customLocalized(), for: .normal)
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        let barButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gerbMinfinRuSmall"), landscapeImagePhone: nil, style: .plain, target: nil, action: nil)
        barButtonItem.isEnabled = false
        barButtonItem.tintColor = nil
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    private func showNoDataAret() {
        let alert = UIAlertController(title: AppLanguage.no_connection_title.customLocalized(), message: AppLanguage.no_connection_message.customLocalized(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AppLanguage.ok.customLocalized(), style: .cancel, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func updateCollectionView(from catalogsData: CatalogsData) {
        self.books = Array(catalogsData.books)
        self.headings = Array(catalogsData.headings)
        self.booksList = self.books
        self.collectionView.reloadData()
    }
    
    private func filterBooksList() {
        if let filterHeading = filterHeading {
            if searchIsActive && searchBar.text != "" {
                booksList = books.filter({$0.headingCode == filterHeading.code
                }).filter({ (book) -> Bool in
                    return self.bookConformsTo(book: book, searchText: searchBar.text)
                })
            } else {
                booksList = books.filter({$0.headingCode == filterHeading.code})
            }
        } else {
            if searchIsActive && searchBar.text != "" {
                booksList = books.filter({ (book) -> Bool in
                    return self.bookConformsTo(book: book, searchText: searchBar.text)
                })
            } else {
                booksList = books
            }
        }
        collectionView.reloadData()
    }
    
    private func bookConformsTo(book: Book, searchText: String?) -> Bool {
        if let text = searchText {
            return book.author.range(of: text) != nil || book.title.range(of: text) != nil || "\(book.year)".range(of: text) != nil
        }
        return false
    }

    private func clearBackgroundColor() {
        guard let UISearchBarBackground: AnyClass = NSClassFromString("UISearchBarBackground") else { return }
        
        for view in searchBar.subviews {
            for subview in view.subviews {
                if subview.isKind(of: UISearchBarBackground) {
                    subview.alpha = 0
                }
            }
        }
    }
    
    func open(book: Book) {
        let bookDetailsVC = storyboard?.instantiateViewController(withIdentifier: "BookDetailsViewController") as! BookDetailsViewController
        bookDetailsVC.book = book
        bookDetailsVC.headings = headings
        bookDetailsVC.booksLoader = dataSource
        navigationController?.pushViewController(bookDetailsVC, animated: true)
    }
    
    @IBAction func rybrikButtonAction(_ sender: Any) {
        if searchIsActive {
            searchBar.text = ""
            searchIsActive = false
            searchBar.resignFirstResponder()
            filterBooksList()
            rybrikButton.setImage(#imageLiteral(resourceName: "rybrikCopy"), for: .normal)
            rybrikButton.setTitle(AppLanguage.headings.customLocalized(), for: .normal)
        } else {
            let headingsVC = storyboard?.instantiateViewController(withIdentifier: "HeadingsViewController") as! HeadingsViewController
            headingsVC.headings = headings
            headingsVC.delegate = self
            present(headingsVC, animated: true, completion: nil)
        }
    }
    

}

extension LibraryViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        rybrikButton.setImage(nil, for: .normal)
        rybrikButton.setTitle(AppLanguage.cancel.customLocalized(), for: .normal)
        searchIsActive = true
        headerTitleLabel.text = AppLanguage.search_results.customLocalized()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text!.isEmpty {
            rybrikButton.setImage(#imageLiteral(resourceName: "rybrikCopy"), for: .normal)
            rybrikButton.setTitle(AppLanguage.headings.customLocalized(), for: .normal)
            searchIsActive = false
            headerTitleLabel.text = AppLanguage.catalog.customLocalized()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterBooksList()
    }
    
}

extension LibraryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        open(book: booksList[indexPath.row])
    }
    
}

extension LibraryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return booksList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCollectionViewCell", for: indexPath) as! BookCollectionViewCell

        cell.configure(with: booksList[indexPath.row])
        cell.delegate = self
        if let data = booksList[indexPath.row].imageData, let image = UIImage(data: data) {
            cell.bookImageView.image = image
            cell.bookNameLabel.isHidden = true
            cell.authorNameLabel.isHidden = true
            cell.dateLabel.isHidden = true
        } else {
            cell.bookImageView.image = UIImage(named: "book")
            cell.bookNameLabel.isHidden = false
            cell.authorNameLabel.isHidden = false
            cell.dateLabel.isHidden = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! BookCollectionViewCell
        cell.bookImageView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            cell.bookImageView.alpha = 1.0
        }
        
    }
}

extension LibraryViewController: BookCollectionViewCellDelegate {
    func didPressMore(on cell: BookCollectionViewCell) {
        if let indexPath = collectionView.indexPathForItem(at: cell.center) {
            open(book: booksList[indexPath.row])
        }
    }
}

extension LibraryViewController: HeadingsViewControllerDelegate {
    func didSelect(heading: Heading?) {
        filterHeading = heading
    }
}
