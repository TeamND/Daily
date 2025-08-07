//
//  Types.swift
//  Daily
//
//  Created by seungyooooong on 8/7/25.
//

import Foundation

protocol Types: CaseIterable {
    var text: String { get }
    // FIXME: indicatorHeight 디자인 의견 확인 후 추가
    var indicatorPadding: CGFloat { get }
}
