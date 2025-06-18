//
//  DailyDatePickerHeader.swift
//  Daily
//
//  Created by seungyooooong on 6/18/25.
//

import SwiftUI

struct DailyDatePickerHeader: View {
    @Binding var currentDate: Date
    
    let calendar = Calendar.current
    
    var body: some View {
        HStack {
            Button {
                currentDate = calendar.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
            } label: {
                Image(.circleChevronLeftSecondary)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
            }
            
            Spacer()
            
            Text("\(String(currentDate.year))년 \(currentDate.month)월")
                .font(Fonts.bodyLgSemiBold)
                .foregroundStyle(Colors.Text.secondary)
            
            Spacer()
            
            Button {
                currentDate = calendar.date(byAdding: .month, value: +1, to: currentDate) ?? currentDate
            } label: {
                Image(.circleChevronRightSecondary)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
            }
        }
    }
}
