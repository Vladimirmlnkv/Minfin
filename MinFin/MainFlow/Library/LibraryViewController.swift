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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackgroundView()
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "БИБЛИОТЕКА"
        collectionView.dataSource = self
        collectionView.delegate = self
        let barButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gerbMinfinRuSmall"), landscapeImagePhone: nil, style: .plain, target: nil, action: nil)
        barButtonItem.isEnabled = false
        barButtonItem.tintColor = nil
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    func openDetailBook() {
        let bookDetailsVC = storyboard?.instantiateViewController(withIdentifier: "BookDetailsViewController") as! BookDetailsViewController
        navigationController?.pushViewController(bookDetailsVC, animated: true)
    }

}

extension LibraryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        openDetailBook()
    }
    
}

extension LibraryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCollectionViewCell", for: indexPath) as! BookCollectionViewCell
        cell.delegate = self
        return cell
    }
}

extension LibraryViewController: BookCollectionViewCellDelegate {
    func didPressMore(on cell: BookCollectionViewCell) {
        openDetailBook()
    }
}
