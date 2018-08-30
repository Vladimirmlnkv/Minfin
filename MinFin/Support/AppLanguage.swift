//
//  AppLanguage.swift
//  MinFin
//
//  Created by Владимир Мельников on 26/08/2018.
//  Copyright © 2018 Владимир Мельников. All rights reserved.
//

import Foundation

class AppLanguage {
    
    static let lang = "lang"
    static let history = "history"
    static let library = "library"
    static let about = "about"
    static let language = "language"
    static let back = "back"
    static let history_title = "history_title"
    static let state_heads = "state_heads"
    static let ministers = "ministers"
    static let events = "events"
    static let multiple_ministers = "multiple_ministers"
    static let multiple_governers = "multiple_governers"
    static let search = "search"
    static let headings = "headings"
    static let catalog = "catalog"
    static let addresses = "addresses"
    static let write_us = "write_us"
    static let ministry = "ministry"
    static let cancel = "cancel"
    static let search_results = "search_results"
    static let first_address_name = "first_address_name"
    static let first_address = "first_address"
    static let second_address_name = "second_address_name"
    static let second_address = "second_address"
    static let platform = "platform"
    static let device = "device"
    static let version = "version"
    static let subject = "subject"
    static let no_connection_title = "no_connection_title"
    static let no_connection_message = "no_connection_message"
    static let ok = "ok"
    static let download = "download"
    static let open = "open"
    static let open_book_title = "open_book_title"
    static let open_book_option1 = "open_book_option1"
    static let open_book_option2 = "open_book_option2"
    
    static let standart = AppLanguage()
    private var languageKey = "appLanguageKey"
    
    var currentLanguage: String = "ru-RU"
    
    init() {
        if let lang = UserDefaults.standard.string(forKey: languageKey) {
            currentLanguage = lang
        } else {
            let lang = NSLocalizedString("lang", comment: "")
            currentLanguage = lang
            UserDefaults.standard.set(lang, forKey: languageKey)
        }
    }
    
    func changeLanguage() {
        if currentLanguage == "ru-RU" {
            UserDefaults.standard.set("en", forKey: languageKey)
            currentLanguage = "en"
        } else {
            UserDefaults.standard.set("ru-RU", forKey: languageKey)
            currentLanguage = "ru-RU"
        }
    }
}
