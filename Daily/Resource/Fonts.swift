//
//  Fonts.swift
//  Daily
//
//  Created by seungyooooong on 3/24/25.
//

import Foundation
import SwiftUI

enum Fonts {
    // pretendard
    static func pretendardBlack(size: CGFloat) -> Font {
        return .custom("Pretendard-Black", fixedSize: size)
    }
    static func pretendardBold(size: CGFloat) -> Font {
        return .custom("Pretendard-Bold", fixedSize: size)
    }
    static func pretendardExtraBold(size: CGFloat) -> Font {
        return .custom("Pretendard-ExtraBold", fixedSize: size)
    }
    static func pretendardExtraLight(size: CGFloat) -> Font {
        return .custom("Pretendard-ExtraLight", fixedSize: size)
    }
    static func pretendardLight(size: CGFloat) -> Font {
        return .custom("Pretendard-Light", fixedSize: size)
    }
    static func pretendardMedium(size: CGFloat) -> Font {
        return .custom("Pretendard-Mideum", fixedSize: size)
    }
    static func pretendardRegular(size: CGFloat) -> Font {
        return .custom("Pretendard-Regular", fixedSize: size)
    }
    static func pretendardSemiBold(size: CGFloat) -> Font {
        return .custom("Pretendard-SemiBold", fixedSize: size)
    }
    static func pretendardThin(size: CGFloat) -> Font {
        return .custom("Pretendard-Thin", fixedSize: size)
    }
    static func pretendardVariable(size: CGFloat) -> Font {
        return .custom("PretendardVariable", fixedSize: size)
    }
}

