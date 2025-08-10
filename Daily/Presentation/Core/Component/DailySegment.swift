//
//  DailySegment.swift
//  Daily
//
//  Created by seungyooooong on 8/7/25.
//

import SwiftUI

struct DailySegment<T: Types & Hashable & Equatable>: View {
    @State private var buttonFrame: CGRect = .zero
    
    let segmentType: SegmentTypes
    @Binding var currentType: T
    let types: [T]
    let action: (T) -> Void
    
    var body: some View {
        HStack(spacing: .zero) {
            ForEach(types, id: \.self) { type in
                Button {
                    action(type)
                } label: {
                    Text(type.text)
                        .font(segmentType.font)
                        .foregroundStyle(Colors.Text.tertiary)
                        .frame(maxWidth: segmentType.maxWidth)
                        .frame(height: segmentType.height)
                }
            }
        }
        .overlay {
            let count = CGFloat(types.count)
            let index = CGFloat(types.firstIndex(of: currentType) ?? 0)
            let offsetX = ((2 * index - count + 1) / (2 * count)) * buttonFrame.width

            Text(currentType.text)
                .font(segmentType.selectedFont)
                .foregroundStyle(segmentType.selectedForegroundColor)
                .frame(maxWidth: buttonFrame.width / CGFloat(types.count))
                .frame(height: segmentType.height)
                .background {
                    RoundedRectangle(cornerRadius: 99)
                        .fill(segmentType.selectedBackgroundColor)
                        .stroke(segmentType.selectedBorderColor, lineWidth: 1)
                }
                .offset(x: offsetX)
                .animation(.easeInOut(duration: 0.3), value: currentType)
        }
        .getFrame { buttonFrame = $0 }
        .padding(4)
        .background(Colors.Background.secondary)
        .cornerRadius(99)
    }
}
