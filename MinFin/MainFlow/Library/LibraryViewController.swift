//
//  LibraryViewController.swift
//  MinFin
//
//  Created by Владимир Мельников on 21/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class LibraryViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var headerTitleLabel: UILabel!
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var rybrikButton: UIButton!
    private var books = [Book]()
    private var searchIsActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearBackgroundColor()
        addBackgroundView()
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "БИБЛИОТЕКА"
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        let barButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gerbMinfinRuSmall"), landscapeImagePhone: nil, style: .plain, target: nil, action: nil)
        barButtonItem.isEnabled = false
        barButtonItem.tintColor = nil
        navigationItem.rightBarButtonItem = barButtonItem
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
        navigationController?.pushViewController(bookDetailsVC, animated: true)
    }
    
    @IBAction func rybrikButtonAction(_ sender: Any) {
        if searchIsActive {
            searchIsActive = false
            searchBar.resignFirstResponder()
        } else {
            let headingsVC = storyboard?.instantiateViewController(withIdentifier: "HeadingsViewController") as! HeadingsViewController
            present(headingsVC, animated: true, completion: nil)
        }
    }
    

}

extension LibraryViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        rybrikButton.setImage(nil, for: .normal)
        rybrikButton.setTitle("Отмена", for: .normal)
        searchIsActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        rybrikButton.setImage(#imageLiteral(resourceName: "rybrikCopy"), for: .normal)
        rybrikButton.setTitle("Рубрикатор", for: .normal)
        searchIsActive = false
    }
    
}

extension LibraryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        open(book: books[indexPath.row])
    }
    
}

extension LibraryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCollectionViewCell", for: indexPath) as! BookCollectionViewCell
        cell.configure(with: books[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension LibraryViewController: BookCollectionViewCellDelegate {
    func didPressMore(on cell: BookCollectionViewCell) {
        if let indexPath = collectionView.indexPathForItem(at: cell.center) {
            open(book: books[indexPath.row])
        }
    }
}
