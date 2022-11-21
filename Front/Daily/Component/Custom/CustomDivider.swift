//
//  CustomDivider.swift
//  Daily
//
//  Created by 최승용 on 2022/11/10.
//

import SwiftUI

struct CustomDivider: View {
    let color: Color
    let height: CGFloat
    let hPadding: CGFloat

    init(color: Color = .gray.opacity(0.5), height: CGFloat = 0.5, hPadding: CGFloat = 0) {
        self.color = color
        self.height = height
        self.hPadding = hPadding
    }
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: height)
            .padding(.horizontal, hPadding)
    }
}
