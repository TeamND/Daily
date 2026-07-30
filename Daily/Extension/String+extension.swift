//
//  String+extension.swift
//  Daily
//
//  Created by seungyooooong on 10/20/24.
//

import Foundation

// MARK: - Localization
extension String {
    var localized: String {
        NSLocalizedString(self, tableName: nil, bundle: LanguageManager.shared.bundle, comment: "")
    }
    
    func localized(_ args: CVarArg...) -> String {
        String(format: self.localized, arguments: args)
    }
}

// MARK: - Date
extension String {
    func formatingDaily() -> String {
        let components = self.split(separator: "-")

        switch components.count {
        case 1:
            return "\(components[0])-01-01"

        case 2:
            return "\(components[0])-\(components[1])-01"

        default:
            return self
        }
    }
    
    func toDate(format: DateFormats = .daily, timeZone: TimeZone = .current) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.timeZone = timeZone
        return dateFormatter.date(from: self)
    }
}
