//
//  SegmentTypes.swift
//  Daily
//
//  Created by seungyooooong on 8/10/25.
//

import SwiftUI

enum SegmentTypes {
    case header
    case component
    
    var font: Font {
        switch self {
        case .header:
            return Fonts.bodyLgSemiBold
        case .component:
            return Fonts.bodyMdRegular
        }
    }
    
    var selectedFont: Font {
        switch self {
        case .header:
            return Fonts.bodyLgSemiBold
        case .component:
            return Fonts.bodyMdSemiBold
        }
    }
    
    var maxWidth: CGFloat {
        switch self {
        case .header:
            return .infinity
        case .component:
            return 60
        }
    }
    
    var height: CGFloat {
        switch self {
        case .header:
            return 34
        case .component:
            return 30
        }
    }
    
    var selectedForegroundColor: Color {
        switch self {
        case .header:
            return Colors.Text.inverse
        case .component:
            return Colors.Text.point
        }
    }
    
    var selectedBackgroundColor: Color {
        switch self {
        case .header:
            return Colors.Brand.primary
        case .component:
            return Colors.Background.primary
        }
    }
    
    var selectedBorderColor: Color {
        switch self {
        case .header:
            return .clear
        case .component:
            return Colors.Brand.primary
        }
    }
}

