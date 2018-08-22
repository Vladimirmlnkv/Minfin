//
//  HistoryViewController.swift
//  MinFin
//
//  Created by Владимир Мельников on 22/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet var headsLabel: UILabel!
    @IBOutlet var ministersLabel: UILabel!
    @IBOutlet var eventsLabel: UILabel!
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var contentView: TimeLineContentView!
    @IBOutlet var contentViewWidthConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentViewWidthConstraint.constant = self.contentView.maxWidth
        headsLabel.text = "Главы\nгосударств"
        scrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "ИСТОРИЯ МИНФИНА В СОБЫТИЯХ СТРАНЫ"
        contentView.governers = getGovernors()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.contentSize = CGSize(width: contentView.maxWidth, height: view.bounds.height - 100)
    }
    
    private func getGovernors() -> [Person] {
        var governers = [Person]()
        if let path = Bundle.main.path(forResource: "minfin", ofType: "json")
        {
            if let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path))
            {
                if let jsonResult = try! JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
                {
                    if let governorsJson = jsonResult["governors"] as? [Any] {
                        for g in governorsJson {
                            governers.append(Person(json: g))
                        }
                    }
                }
            }
        }
        return governers
    }
}
