//
//  DailyCycleTypePicker.swift
//  Daily
//
//  Created by seungyooooong on 10/28/24.
//

import SwiftUI

struct DailyCycleTypePicker: View {
    @Binding var cycleType: CycleTypes
    
    var body: some View {
        HStack(spacing: .zero) {
            ForEach(CycleTypes.allCases, id: \.self) { type in
                Button {
                    cycleType = type
                } label: {
                    Text(type.text)
                        .font(Fonts.bodyLgSemiBold)
                        .foregroundStyle(cycleType == type ? Colors.Text.inverse : Colors.Text.secondary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 36)
                        .background {
                            RoundedRectangle(cornerRadius: 99)
                                .fill(cycleType == type ? Colors.Brand.primary : .clear)
                        }
                }
            }
        }
        .padding(4)
        .background {
            RoundedRectangle(cornerRadius: 99)
                .fill(Colors.Background.secondary)
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    DailyCycleTypePicker(cycleType: .constant(.date))
}
