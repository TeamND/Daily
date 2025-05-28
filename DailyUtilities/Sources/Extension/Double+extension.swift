//
//  Double+extension.swift
//  Daily
//
//  Created by seungyooooong on 10/20/24.
//

import Foundation

extension Double {
    public func percentFormat() -> String {
        if Int(self * 100) % 100 == 0 {
            return String(format: "%.0f", self) + "%"
        } else if Int(self * 100) % 10 == 0 {
            return String(format: "%.1f", self) + "%"
        } else {
            return String(format: "%.2f", self) + "%"
        }
    }
}
