//
//  DoubleExtension.swift
//  Daily
//
//  Created by 최승용 on 5/25/24.
//

import Foundation

extension Double {
    func percentFormat() -> String {
//        print(Int(self * 100))
        if Int(self * 100) % 100 == 0 {
            return String(format: "%.0f", self) + "%"
        } else if Int(self * 100) % 10 == 0 {
            return String(format: "%.1f", self) + "%"
        } else {
            return String(format: "%.2f", self) + "%"
        }
    }
}
