//
//  String+extension.swift
//  Daily
//
//  Created by seungyooooong on 10/20/24.
//

import Foundation

// MARK: - Date
extension String {
    func toDate(format: DateFormats = .daily, timeZone: TimeZone = .current) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.timeZone = timeZone
        return dateFormatter.date(from: self)
    }
}

// MARK: - AttributedString
extension String {
    func accent(keywords: [String], style: (inout AttributeContainer) -> Void) -> AttributedString {
        var attributedString = AttributedString(self)
        
        for keyword in keywords {
            if let range = self.range(of: keyword) {
                let nsRange = NSRange(range, in: self)
                if let attributedRange = Range(nsRange, in: attributedString) {
                    var container = AttributeContainer()
                    style(&container)
                    attributedString[attributedRange].setAttributes(container)
                }
            }
        }
        
        return attributedString
    }
}
