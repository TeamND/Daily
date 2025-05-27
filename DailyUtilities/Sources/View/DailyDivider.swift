//
//  DailyDivider.swift
//  Daily
//
//  Created by 최승용 on 2022/11/10.
//

import SwiftUI

@available(iOS 17.0, *)
public struct DailyDivider: View {
    public let color: Color
    public let height: CGFloat
    public let hPadding: CGFloat

    public init(color: Color = .gray.opacity(0.5), height: CGFloat = 0.5, hPadding: CGFloat = 0) {
        self.color = color
        self.height = height
        self.hPadding = hPadding
    }
    
    public var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: height)
            .padding(.horizontal, hPadding)
    }
}
