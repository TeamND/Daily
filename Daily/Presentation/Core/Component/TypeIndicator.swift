//
//  TypeIndicator.swift
//  Daily
//
//  Created by seungyooooong on 8/7/25.
//

import SwiftUI

struct TypeIndicator<T: Types & Hashable & Equatable>: View {
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
                        .foregroundStyle(type == currentType ? Colors.Text.inverse : Colors.Text.secondary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 34)  // FIXME: indicatorHeight 디자인 의견 확인 후 추가
                        .background {
                            RoundedRectangle(cornerRadius: 99)
                                .fill(type == currentType ? Colors.Brand.primary : .clear)
                        }
                }
            }
        }
        .padding(currentType.indicatorPadding)
        .background {
            RoundedRectangle(cornerRadius: 99)
                .fill(Colors.Background.secondary)
        }
    }
}
