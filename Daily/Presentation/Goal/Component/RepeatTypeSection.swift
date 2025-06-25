//
//  RepeatTypeSection.swift
//  Daily
//
//  Created by seungyooooong on 6/18/25.
//

import SwiftUI

struct RepeatTypeSection: View {
    @Binding var repeatType: RepeatTypes
    
    var body: some View {
        HStack {
            Text("반복 방식")
                .font(Fonts.bodyLgSemiBold)
                .foregroundStyle(Colors.Text.primary)
            
            Spacer()
            
            Button {
                // TODO: 추후에 daily menu 추가
                repeatType = repeatType == .weekly ? .custom : .weekly
            } label: {
                HStack(spacing: 4) {
                    Text(repeatType.text)
                        .font(Fonts.bodyLgMedium)
                        .foregroundStyle(Colors.Text.secondary)
                    
                    Image(.chevronUpDown)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .background(Colors.Background.secondary)
                .cornerRadius(8)
            }
        }
    }
}
