//
//  Person.swift
//  MinFin
//
//  Created by Владимир Мельников on 22/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

class Person {
    
    let name: String
    let startYear: Int
    let endYear: Int
    
    init(json: Any) {
        if let dict = json as? [String: Any] {
            name = dict["name"] as! String
            startYear = dict["startYear"] as! Int
            endYear = dict["endYear"] as! Int
        } else {
            name = ""
            startYear = 0
            endYear = 0
        }
    }
}
