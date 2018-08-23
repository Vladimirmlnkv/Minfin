//
//  AboutViewController.swift
//  MinFin
//
//  Created by Владимир Мельников on 23/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var writeUsButton: UIButton!
    
    private let aboutInfo = [
        AboutData(name: "Министерство финансов РФ", address: "109097, Москва, ул. Ильинка, 9"),
        AboutData(name: "Книжный фонд «Научная библиотека Министерства финансов Российской Федерации»", address: "109097, Москва, ул. Ильинка, 9")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackgroundView()
        writeUsButton.layer.cornerRadius = 20.0
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "О МИНФИНЕ"
        let barButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gerbMinfinRuSmall"), landscapeImagePhone: nil, style: .plain, target: nil, action: nil)
        barButtonItem.isEnabled = false
        barButtonItem.tintColor = nil
        navigationItem.rightBarButtonItem = barButtonItem
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func writeUsButtonAction(_ sender: Any) {
        
    }
    
}

extension AboutViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let aboutView = AboutHeaderView(frame: CGRect())
        return aboutView
    }
    
}

extension AboutViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aboutInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AboutTableViewCell") as! AboutTableViewCell
        let data = aboutInfo[indexPath.row]
        cell.mainTitleLabel.text = data.name
        cell.descriptionTitleLabel.text = data.address
        return cell
    }
    
}
