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
    
    @IBOutlet var topLabelTopConstraint: NSLayoutConstraint!
    private var governers = [Person]()
    private var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.topOffset = navigationController!.navigationBar.frame.height + UIApplication.shared.statusBarFrame.height + 20
        topLabelTopConstraint.constant = contentView.topOffset
        contentViewWidthConstraint.constant = self.contentView.maxWidth
        headsLabel.text = "Главы\nгосударств"
        scrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "ИСТОРИЯ МИНФИНА В СОБЫТИЯХ СТРАНЫ"
        loadDataFromJson()
        contentView.governers = governers
        contentView.events = events
        contentView.eventsMinYCoordinate = eventsLabel.frame.minY + contentView.topOffset
        let barButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gerbMinfinRuSmall"), landscapeImagePhone: nil, style: .plain, target: nil, action: nil)
        barButtonItem.isEnabled = false
        barButtonItem.tintColor = nil
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.contentSize = CGSize(width: contentView.maxWidth, height: view.bounds.height - 100)
    }
    
    private func loadDataFromJson() {
        var governers = [Person]()
        var events = [Event]()
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
                    if let eventsJson = jsonResult["events"] as? [Any] {
                        for e in eventsJson {
                            events.append(Event(json: e))
                        }
                    }
                }
            }
        }
        self.governers = governers
        self.events = events
    }
}
