//
//  Person.swift
//  MinFin
//
//  Created by Владимир Мельников on 22/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class Person: DetailInfo {
    
    var displayName: String {
        return fullName ?? name
    }
    
    var name: String
    var fullName: String?
    var startYear: Int
    var endYear: Int?
    
    var photoUrl: String!
    var longDescription: String?
    var quote: String? = nil
    var quoteSource: String? = nil
    
    init(json: Any) {
        if let dict = json as? [String: Any] {
            name = dict["name"] as! String
            startYear = dict["startYear"] as! Int
            endYear = dict["endYear"] as? Int
            longDescription = dict["longDescription"] as? String
            photoUrl = dict["photoUrl"] as! String
            fullName = dict["fullName"] as? String
        } else {
            photoUrl = ""
            name = ""
            startYear = 0
            endYear = 0
            longDescription = nil
        }
    }
}
