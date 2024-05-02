//
//  IntExtension.swift
//  Daily
//
//  Created by 최승용 on 5/2/24.
//

import Foundation

extension Int {
    func hourFormat() -> String {
        return String(format: "%02d", self / 3600)
    }
    func minFormat() -> String {
        return String(format: "%02d", self % 3600 / 60)
    }
    func secFormat() -> String {
        return String(format: "%02d", self % 60)
    }
    func timerFormat() -> String {
        var returnString = ""
        if self >= 3600 {
            returnString = self.hourFormat() + ":"
        }
        if self >= 60 {
            returnString = returnString + self.minFormat() + ":"
        }
        returnString = returnString + self.secFormat()
        return returnString
    }
}
