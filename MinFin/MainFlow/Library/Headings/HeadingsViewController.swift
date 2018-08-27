//
//  HeadingsViewController.swift
//  MinFin
//
//  Created by Владимир Мельников on 25/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

protocol HeadingsViewControllerDelegate {
    func didSelect(heading: Heading?)
}

class HeadingsViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var cancelButton: UIButton!
    
    var headings = [Heading]()
    var delegate: HeadingsViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackgroundView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }

    @IBAction func cancelButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension HeadingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate.didSelect(heading: indexPath.row == 0 ? nil: headings[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
    
}

extension HeadingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeadingTableViewCell", for: indexPath) as! HeadingTableViewCell
        cell.mainTitleLabel.text = headings[indexPath.row].displayName
        return cell
    }
    
}
