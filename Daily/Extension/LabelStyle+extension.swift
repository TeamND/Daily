//
//  LabelStyle+extension.swift
//  Daily
//
//  Created by seungyooooong on 10/25/24.
//

import Foundation
import SwiftUI

struct TrailingIconLabelStyle: LabelStyle {
    let spacing: CGFloat?
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: spacing) {
            configuration.title
            configuration.icon
        }
    }
}

extension LabelStyle where Self == TrailingIconLabelStyle {
    static func trailingIcon(spacing: CGFloat? = nil) -> Self { Self(spacing: spacing) }
}
