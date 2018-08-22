//
//  Event.swift
//  MinFin
//
//  Created by Владимир Мельников on 22/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import Foundation

class Event {
    
    let name: String
    let startYear: Int
    let endYear: Int?
    let isTextOnLeft: Bool
    let rowNumber: Int
    let needToCenterContent: Bool
    
    init(json: Any) {
        if let dict = json as? [String: Any] {
            name = dict["name"] as! String
            startYear = dict["startYear"] as! Int
            endYear = dict["endYear"] as? Int
            isTextOnLeft = dict["isTextOnLeft"] as! Bool
            rowNumber = dict["rowNumber"] as! Int
            needToCenterContent = dict["needToCenterContent"] as! Bool
        } else {
            name = ""
            startYear = 0
            endYear = nil
            isTextOnLeft = false
            rowNumber = 0
            needToCenterContent = false
        }
    }
}
