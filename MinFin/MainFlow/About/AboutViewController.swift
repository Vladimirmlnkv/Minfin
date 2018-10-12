//
//  AboutViewController.swift
//  MinFin
//
//  Created by Владимир Мельников on 23/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit
import MapKit

class AboutViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var writeUsButton: UIButton!
    @IBOutlet var addressTitleLabel: UILabel!
    
    private let aboutInfo = [
        AboutData(name: AppLanguage.first_address_name.customLocalized(), address: AppLanguage.first_address.customLocalized()),
        AboutData(name: AppLanguage.second_address_name.customLocalized(), address: AppLanguage.second_address.customLocalized())
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackgroundView()
        writeUsButton.layer.cornerRadius = 20.0
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = AppLanguage.about.customLocalized().capitalized
        writeUsButton.setTitle(AppLanguage.write_us.customLocalized(), for: .normal)
        addressTitleLabel.text = AppLanguage.addresses.customLocalized()
        let barButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gerbMinfinRuSmall"), landscapeImagePhone: nil, style: .plain, target: nil, action: nil)
        barButtonItem.isEnabled = false
        barButtonItem.tintColor = nil
        navigationItem.rightBarButtonItem = barButtonItem
        tableView.estimatedRowHeight = 60.0
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
    }
    
    @IBAction func writeUsButtonAction(_ sender: Any) {
        
        let subject = AppLanguage.subject.customLocalized()
        let iosVersion = UIDevice.current.systemVersion
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        
        let body = "\n\n\(AppLanguage.platform.customLocalized()) iOS \(iosVersion)\n\(AppLanguage.device.customLocalized()) \(UIDevice.modelName)\n\(AppLanguage.version.customLocalized()) \(appVersion)"
        let encodedParams = "subject=\(subject)&body=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = "mailto:minfin@mail.ru?\(encodedParams)"
        
        if let emailURL = URL(string: url) {
            if UIApplication.shared.canOpenURL(emailURL) {
                UIApplication.shared.openURL(emailURL)
            }
        }
    }
    
    func openMapForPlace(name: String) {
        
        let latitude: CLLocationDegrees = 55.755839
        let longitude: CLLocationDegrees = 37.626866
        
        let regionDistance:CLLocationDistance = 1000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name
        mapItem.openInMaps(launchOptions: options)
    }
}

extension AboutViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if aboutInfo[indexPath.row].address != "" {
            openMapForPlace(name: aboutInfo[indexPath.row].name)
        }
    }
    
}

extension AboutViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aboutInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AboutTableViewCell") as! AboutTableViewCell
        let data = aboutInfo[indexPath.row]
        cell.backgroundColor = .clear
        cell.mainTitleLabel.text = data.name
        cell.delegate = self
        cell.descriptionTitleLabel.text = data.address
        return cell
    }
    
}

extension AboutViewController: AboutTableViewCellDelegate {
    func didPressLinkButton() {
        let urlString = "https://www.minfin.ru"
        if let url = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
