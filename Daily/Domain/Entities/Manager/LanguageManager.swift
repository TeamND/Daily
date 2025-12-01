//
//  LanguageManager.swift
//  Daily
//
//  Created by seungyooooong on 12/1/25.
//

import Foundation

final class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    
    @Published var language: Languages? = UserDefaultManager.language
    
    private init() { }
    
    var bundle: Bundle {
        guard let language,
              let path = Bundle.main.path(forResource: language.languageCode, ofType: "lproj"),
              let bundle = Bundle(path: path) else { return .main }
        return bundle
    }
}
