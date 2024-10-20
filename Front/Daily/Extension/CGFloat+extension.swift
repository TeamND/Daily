//
//  CGFloat+extension.swift
//  Daily
//
//  Created by seungyooooong on 10/20/24.
//

import Foundation
import SwiftUI

extension CGFloat {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    
    static let monthOnYearWidth = screenWidth / 3
    static let monthOnYearHeight = screenHeight / 6
    static let dayOnMonthWidth = screenWidth / 7
    
    static let fontSize = 6 * screenWidth / 393 // MARK: 6.7 iPhone 기준
}
