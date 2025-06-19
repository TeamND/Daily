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
            Text("반복방식")
                .font(Fonts.bodyLgSemiBold)
                .foregroundStyle(Colors.Text.primary)
            
            Spacer()
            
            Button {
                repeatType = repeatType == .weekly ? .custom : .weekly
            } label: {
                Text(repeatType.text)
                    .font(Fonts.bodyLgMedium)
                    .foregroundStyle(Colors.Text.secondary)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 12)
                    .background(Colors.Background.secondary)
                    .cornerRadius(8)
            }
        }
    }
}
