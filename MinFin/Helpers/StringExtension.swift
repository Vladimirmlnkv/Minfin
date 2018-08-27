//
//  StringExtension.swift
//  MinFin
//
//  Created by Владимир Мельников on 26/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import UIKit

extension String {
    func customLocalized() ->String {
        
        let path = Bundle.main.path(forResource: AppLanguage.standart.currentLanguage, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }}
