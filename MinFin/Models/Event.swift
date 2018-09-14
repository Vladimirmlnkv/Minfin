//
//  Event.swift
//  MinFin
//
//  Created by Владимир Мельников on 22/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import Foundation

class Event: DetailInfo {
    
    var displayName: String {
        return name
    }
    
    var name: String
    var startYear: Int
    var endYear: Int?
    let isTextOnLeft: Bool
    let rowNumber: Int
    let needToCenterContent: Bool
    let photoUrl: String!
    
    var longDescription: String?
    var quote: String?
    var quoteSource: String?
    
    init(json: Any) {
        if let dict = json as? [String: Any] {
            name = dict["name"] as! String
            startYear = dict["startYear"] as! Int
            endYear = dict["endYear"] as? Int
            isTextOnLeft = dict["isTextOnLeft"] as! Bool
            rowNumber = dict["rowNumber"] as! Int
            needToCenterContent = dict["needToCenterContent"] as! Bool
            longDescription = dict["longDescription"] as? String
            quote = dict["quote"] as? String
            quoteSource = dict["quoteSource"] as? String
            if let url = dict["iconUrl"] as? String {
                photoUrl = url
            } else {
                photoUrl = ""
            }
        } else {
            name = ""
            startYear = 0
            endYear = nil
            isTextOnLeft = false
            rowNumber = 0
            needToCenterContent = false
            longDescription = nil
            quote = nil
            quoteSource = nil
            photoUrl = ""
        }
    }
}
