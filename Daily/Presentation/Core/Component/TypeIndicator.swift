//
//  TypeIndicator.swift
//  Daily
//
//  Created by seungyooooong on 8/7/25.
//

import SwiftUI

struct TypeIndicator<T: Types & Hashable & Equatable>: View {
    @State private var buttonFrame: CGRect = .zero
    
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
                        .font(Fonts.bodyLgSemiBold)
                        .foregroundStyle(Colors.Text.secondary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 34)
                }
            }
        }
        .overlay {
            let count = CGFloat(types.count)
            let index = CGFloat(types.firstIndex(of: currentType) ?? 0)
            let offsetX = ((2 * index - count + 1) / (2 * count)) * buttonFrame.width

            Text(currentType.text)
                .font(Fonts.bodyLgSemiBold)
                .foregroundStyle(Colors.Text.inverse)
                .frame(maxWidth: buttonFrame.width / CGFloat(types.count))
                .frame(height: 34)
                .background(Colors.Brand.primary)
                .cornerRadius(99)
                .offset(x: offsetX)
                .animation(.easeInOut(duration: 0.3), value: currentType)
        }
        .padding(2)
        .background(Colors.Background.secondary)
        .cornerRadius(99)
        .getFrame { buttonFrame = $0 }
    }
}
