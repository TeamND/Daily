//
//  Array+extension.swift
//  Daily
//
//  Created by seungyooooong on 12/29/24.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
