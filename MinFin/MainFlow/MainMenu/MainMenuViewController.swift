//
//  MainMenuViewController.swift
//  MinFin
//
//  Created by Владимир Мельников on 21/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

    @IBOutlet var headerTitleLabel: UILabel!
    
    @IBOutlet var historyButton: UIButton!
    @IBOutlet var libraryButton: UIButton!
    @IBOutlet var aboutButton: UIButton!
    @IBOutlet var languageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = UIColor.clear
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.navigationBar.tintColor = Color.mainTextColor
                navigationController?.setNavigationBarHidden(true, animated: false)
        navigationItem.title = "Назад"
        headerTitleLabel.text = "МИНИСТЕРСТВО ФИНАНСОВ\nРОССИЙСКОЙ ФЕДЕРАЦИИ"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func historyButtonAction(_ sender: Any) {
        let historyVC = storyboard?.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
        navigationController?.pushViewController(historyVC, animated: true)
    }
    
    @IBAction func libraryButtonAction(_ sender: Any) {
        let libraryVC = storyboard?.instantiateViewController(withIdentifier: "LibraryViewController") as! LibraryViewController
        navigationController?.pushViewController(libraryVC, animated: true)
    }
    
    @IBAction func aboutButtonAction(_ sender: Any) {
        let aboutVC = storyboard?.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
        navigationController?.pushViewController(aboutVC, animated: true)
    }
    
    @IBAction func languageButtonAction(_ sender: Any) {
        
    }
}
