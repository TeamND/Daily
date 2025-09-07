//
//  SingleDateSection.swift
//  Daily
//
//  Created by seungyooooong on 6/18/25.
//

import SwiftUI

struct SingleDateSection: View {
    let title: String
    
    @Binding var date: Date
    @Binding var isShowDatePicker: Bool
    
    var action: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: .zero) {
            HStack {
                Text(title)
                    .font(Fonts.bodyLgSemiBold)
                    .foregroundStyle(Colors.Text.primary)
                
                Spacer()
                
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isShowDatePicker.toggle()
                        action?()
                    }
                } label: {
                    Text(date.toString(format: .singleDate))
                        .font(Fonts.bodyLgMedium)
                        .foregroundStyle(Colors.Text.point)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Colors.Background.secondary)
                        .cornerRadius(8)
                }
            }
            
            if isShowDatePicker {
                Spacer().frame(height: 16)
                
                DailyDatePicker(date: $date)
            }
        }
    }
}
