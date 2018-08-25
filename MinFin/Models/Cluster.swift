//
//  Cluster.swift
//  MinFin
//
//  Created by Владимир Мельников on 25/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import Foundation

class Cluster {
    
    var startYear: Int
    var endYear: Int
    var persons: [Person]
    
    init(json: Any) {
        if let dict = json as? [String: Any] {
            startYear = dict["startYear"] as! Int
            endYear = dict["endYear"] as! Int            
            let personsArray = dict["persons"] as! [Any]
            persons = personsArray.map { Person(json: $0)}
        } else {
            startYear = 0
            endYear = 0
            persons = [Person]()
        }
    }
    
}
