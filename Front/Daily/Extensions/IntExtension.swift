//
//  IntExtension.swift
//  Daily
//
//  Created by 최승용 on 5/2/24.
//

import Foundation

extension Int {
    func timerFormat() -> String {
        if self < 60 {
            return String(format: "%d", self % 60)
        }
        if self < 3600 {
            return String(format: "%d:%02d", self % 3600 / 60, self % 60)
        }
        return String(format: "%d:%02d:%02d", self / 3600, self % 3600 / 60, self % 60)
    }
}
