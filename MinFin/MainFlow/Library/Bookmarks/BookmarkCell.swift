//
//  BookmarkCell.swift
//  MinFin
//
//  Created by Владимир Мельников on 08/10/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

protocol BookmarkCellDelegate {
    func didPressCrossButton(for cell: BookmarkCell)
}

class BookmarkCell: UITableViewCell {

    @IBOutlet var bookImage: UIImageView!
    @IBOutlet var bookTitleLabel: UILabel!
    var delegate: BookmarkCellDelegate!
    
    @IBAction func crossButtonAction(_ sender: Any) {
        delegate.didPressCrossButton(for: self)
    }
    
}
