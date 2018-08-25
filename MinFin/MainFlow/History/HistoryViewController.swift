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
    
    @IBOutlet var eventsLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet var ministersLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet var topLabelTopConstraint: NSLayoutConstraint!
    
    private var governers = [Person]()
    private var events = [Event]()
    private var ministers = [Person]()
    private var clusters = [Cluster]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.delegate = self
        contentView.topOffset = navigationController!.navigationBar.frame.height + UIApplication.shared.statusBarFrame.height + 20
        
        let fullHeight = view.frame.height - contentView.topOffset - contentView.bottomOffset
        contentView.personsSectionHeight = fullHeight * 3 / 2 / 10
        contentView.eventsSectionHeight = fullHeight - 2 * contentView.personsSectionHeight        
        
        topLabelTopConstraint.constant = contentView.topOffset
        ministersLabelTopConstraint.constant = contentView.topOffset + contentView.personsSectionHeight
        eventsLabelTopConstraint.constant = contentView.topOffset + contentView.personsSectionHeight * 2
        contentViewWidthConstraint.constant = self.contentView.maxWidth
        contentView.eventsMinYCoordinate = eventsLabelTopConstraint.constant
        
        headsLabel.text = "Главы\nгосударств"
        navigationController?.setNavigationBarHidden(false, animated: true)
        loadDataFromJson()
        contentView.governers = governers
        contentView.events = events
        contentView.ministers = ministers
        contentView.clusters = clusters
        let barButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gerbMinfinRuSmall"), landscapeImagePhone: nil, style: .plain, target: nil, action: nil)
        barButtonItem.isEnabled = false
        barButtonItem.tintColor = nil
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "ИСТОРИЯ МИНФИНА В СОБЫТИЯХ СТРАНЫ"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.contentSize = CGSize(width: contentView.maxWidth, height: view.bounds.height - 100)
    }
    
    func openDetails(for info: DetailInfo) {
        let personVC = storyboard?.instantiateViewController(withIdentifier: "PersonDetailViewController") as! PersonDetailViewController
        personVC.detailInfo = info
        navigationItem.title = "Назад"
        navigationController?.pushViewController(personVC, animated: true)
    }
    
    private func loadDataFromJson() {
        var governers = [Person]()
        var events = [Event]()
        var ministers = [Person]()
        var clusters = [Cluster]()
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
                    if let ministersJson = jsonResult["ministers"] as? [Any] {
                        for m in ministersJson {
                            ministers.append(Person(json: m))
                        }
                    }
                    
                    if let clustersJson = jsonResult["clusters"] as? [Any] {
                        for c in clustersJson {
                            clusters.append(Cluster(json: c))
                        }
                    }
                }
            }
        }
        self.clusters = clusters
        self.governers = governers
        self.events = events
        self.ministers = ministers
    }
}

extension HistoryViewController: TimeLineContentViewDelegate {
    
    func didSelect(detailInfo: DetailInfo) {
        openDetails(for: detailInfo)
    }    
}
