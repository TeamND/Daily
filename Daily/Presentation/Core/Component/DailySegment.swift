//
//  DailySegment.swift
//  Daily
//
//  Created by seungyooooong on 8/7/25.
//

import SwiftUI

struct DailySegment<T: DailyTypes & Hashable & Equatable>: View {
    @State private var buttonFrame: CGRect = .zero
    
    let segmentType: SegmentTypes
    @Binding var currentType: T?
    let types: [T]
    let action: ((T) -> Void)?
    
    init(
        segmentType: SegmentTypes,
        currentType: Binding<T?>,
        types: [T],
        action: ((T) -> Void)? = nil
    ) {
        self.segmentType = segmentType
        self._currentType = currentType
        self.types = types
        self.action = action
    }
    
    init(
        segmentType: SegmentTypes,
        currentType: Binding<T>,
        types: [T],
        action: ((T) -> Void)? = nil
    ) {
        self.segmentType = segmentType
        let optionalBinding = Binding<T?>(
            get: { currentType.wrappedValue },
            set: { newValue in
                guard let newValue else { return }
                currentType.wrappedValue = newValue
            }
        )
        self._currentType = optionalBinding
        self.types = types
        self.action = action
    }
    
    var body: some View {
        Group {
            if let currentType {
                HStack(spacing: .zero) {
                    ForEach(types, id: \.self) { type in
                        Button {
                            if let action { action(type) }
                            else { _currentType.wrappedValue = type }
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
            } else {
                // FIXME: 추후 수정
                Text("🚧🚧 예상치 못한 문제가 발생했습니다.")
                    .font(Fonts.bodyLgSemiBold)
                    .foregroundStyle(Colors.Text.primary)
            }
        }
        .getFrame { buttonFrame = $0 }
        .padding(4)
        .background(Colors.Background.secondary)
        .cornerRadius(99)
    }
}
