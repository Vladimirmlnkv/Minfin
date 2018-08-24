//
//  DetailInfo.swift
//  MinFin
//
//  Created by Владимир Мельников on 24/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import Foundation

protocol DetailInfo {
    var name: String { get }
    var startYear: Int { get }
    var endYear: Int? { get }
    var longDescription: String? { get }
    var quote: String? { get }
    var quoteSource: String? { get }
}
