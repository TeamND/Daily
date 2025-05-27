//
//  Colors.swift
//  DailyUtilities
//
//  Created by seungyooooong on 5/26/25.
//

import Foundation
import SwiftUI

@available(iOS 13.0, *)
public enum Colors {
    public enum Brand {
        public static let primary = Color("brandPrimary")
        public static let secondary = Color("brandSecondary")
    }
    
    public enum Background {
        public static let primary = Color("backgroundPrimary")
        public static let secondary = Color("backgroundSecondary")
    }
    
    public enum Text {
        public static let primary = Color("textPrimary")
        public static let secondary = Color("textSecondary")
        public static let tertiary = Color("textTertiary")
        public static let inverse = Color("textInverse")
        public static let point = Color("textPoint")
    }
    
    public enum Border {
        public static let primary = Color("borderPrimary")
        public static let secondary = Color("borderSecondary")
    }
    
    public enum Icon {
        public static let primary = Color("iconPrimary")
        public static let secondary = Color("iconSecondary")
        public static let tertiary = Color("iconTertiary")
        public static let interactiveDefault = Color("iconInteractiveDefault")
        public static let interactivePressed = Color("iconInteractivePressed")
        public static let inverse = Color("iconInverse")
    }
}
