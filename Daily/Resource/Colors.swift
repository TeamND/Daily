//
//  Colors.swift
//  Daily
//
//  Created by seungyooooong on 10/20/24.
//

import Foundation
import SwiftUI

enum Colors {
    // FIXME: 2.1.0 배포 전 삭제
    static let daily = Color("DailyColor")
    static let background = Color("BackgroundColor")
    static let theme = Color("ThemeColor")
    static let reverse = Color("ReverseColor")
    
    enum Brand {
        static let primary = Color("brandPrimary")
        static let secondary = Color("brandSecondary")
    }
    
    enum Background {
        static let primary = Color("backgroundPrimary")
        static let secondary = Color("backgroundSecondary")
        static let toast = Color("backgroundToast")
        static let dim = Color("backgroundDim")
    }
    
    enum Text {
        static let primary = Color("textPrimary")
        static let secondary = Color("textSecondary")
        static let tertiary = Color("textTertiary")
        static let inverse = Color("textInverse")
        static let point = Color("textPoint")
    }
    
    enum Border {
        static let primary = Color("borderPrimary")
        static let secondary = Color("borderSecondary")
    }
    
    enum Icon {
        static let primary = Color("iconPrimary")
        static let secondary = Color("iconSecondary")
        static let tertiary = Color("iconTertiary")
        static let interactiveDefault = Color("iconInteractiveDefault")
        static let interactivePressed = Color("iconInteractivePressed")
        static let inverse = Color("iconInverse")
    }
    
    enum Shadow {
        static let primary = Color("shadowPrimary")
    }
}
