//
//  Fonts.swift
//  DailyUtilities
//
//  Created by seungyooooong on 5/26/25.
//

import Foundation
import SwiftUI

@available(iOS 14.0, *)
public enum Fonts {
    // pretendard
    public static func pretendardBlack(size: CGFloat) -> Font {
        return .custom("Pretendard-Black", fixedSize: size)
    }
    public static func pretendardBold(size: CGFloat) -> Font {
        return .custom("Pretendard-Bold", fixedSize: size)
    }
    public static func pretendardExtraBold(size: CGFloat) -> Font {
        return .custom("Pretendard-ExtraBold", fixedSize: size)
    }
    public static func pretendardExtraLight(size: CGFloat) -> Font {
        return .custom("Pretendard-ExtraLight", fixedSize: size)
    }
    public static func pretendardLight(size: CGFloat) -> Font {
        return .custom("Pretendard-Light", fixedSize: size)
    }
    public static func pretendardMedium(size: CGFloat) -> Font {
        return .custom("Pretendard-Mideum", fixedSize: size)
    }
    public static func pretendardRegular(size: CGFloat) -> Font {
        return .custom("Pretendard-Regular", fixedSize: size)
    }
    public static func pretendardSemiBold(size: CGFloat) -> Font {
        return .custom("Pretendard-SemiBold", fixedSize: size)
    }
    public static func pretendardThin(size: CGFloat) -> Font {
        return .custom("Pretendard-Thin", fixedSize: size)
    }
    public static func pretendardVariable(size: CGFloat) -> Font {
        return .custom("PretendardVariable", fixedSize: size)
    }
    
    // daily scheduler
    public static let headingXlBold = pretendardBold(size: 28)
    public static let headingLgBold = pretendardBold(size: 24)
    public static let headingMdBold = pretendardBold(size: 20)
    
    public static let headingSmSemiBold = pretendardSemiBold(size: 18)
    public static let bodyLgSemiBold = pretendardSemiBold(size: 16)
    public static let bodyMdSemiBold = pretendardSemiBold(size: 14)
    
    public static let bodyXlMedium = pretendardMedium(size: 18)
    public static let bodyLgMedium = pretendardMedium(size: 16)
    
    public static let bodyLgRegular = pretendardRegular(size: 16)
    public static let bodyMdRegular = pretendardRegular(size: 14)
    public static let bodySmRegular = pretendardRegular(size: 12)
    public static let bodyXsmRegular = pretendardRegular(size: 9)
}

