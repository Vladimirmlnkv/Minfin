//
//  ClusterDetailsContainerView.swift
//  MinFin
//
//  Created by Владимир Мельников on 25/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

protocol ClusterDetailsContainerViewDelegate {
    func didSelect(person: Person)
}

class ClusterDetailsContainerView: UIView {

    @IBOutlet var mainView: UIView!
    @IBOutlet var blurView: UIVisualEffectView!
    @IBOutlet var collectionView: UICollectionView!
    
    var cluster: Cluster!
    var delegate: ClusterDetailsContainerViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib("ClusterDetailsContainerView")
        updateCornerRadiuses()
        setDependencies()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib("ClusterDetailsContainerView")
        updateCornerRadiuses()
        setDependencies()
    }
    
    private func setDependencies() {        
        collectionView.register(UINib(nibName: "ClusterDetailsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ClusterDetailsCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func updateCornerRadiuses() {
        mainView.layer.cornerRadius = 10.0
        clipsToBounds = true
        layer.cornerRadius = 10.0
        blurView.clipsToBounds = true
        blurView.layer.cornerRadius = 10.0
    }

}

extension ClusterDetailsContainerView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cluster.persons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClusterDetailsCollectionViewCell", for: indexPath) as! ClusterDetailsCollectionViewCell
        let person = cluster.persons[indexPath.row]
        cell.nameLabel.text = person.name
        cell.dateLabel.text = "\(person.startYear) - \(person.endYear!)"
        if person.photoUrl != "" {
            cell.avatarImageView.image = UIImage(named: person.photoUrl)
        }
        return cell
    }
    
}

extension ClusterDetailsContainerView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.didSelect(person: cluster.persons[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if cluster.persons.count <= 3 {
            return CGSize(width: frame.width, height: 50.0)
        } else {
            return CGSize(width: frame.width / 2 - 10 , height:50.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
}
