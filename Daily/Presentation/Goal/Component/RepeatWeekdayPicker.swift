//
//  RepeatWeekdayPicker.swift
//  Daily
//
//  Created by seungyooooong on 6/19/25.
//

import SwiftUI

struct RepeatWeekdayPicker: View {
    @AppStorage(UserDefaultKey.startDay.rawValue) var startDay: Int = 0
    
    @Binding var selectedWeekday: [Bool]
    
    var body: some View {
        HStack(spacing: .zero) {
            ForEach(.zero ..< GeneralServices.week, id: \.self) { index in
                if .zero < index { Spacer() }
                
                Button {
                    selectedWeekday[index].toggle()
                } label: {
                    Text(DayOfWeek.allCases[(index + startDay) % GeneralServices.week].text)
                        .font(selectedWeekday[index] ? Fonts.bodyLgSemiBold : Fonts.bodyLgMedium)
                        .foregroundStyle(selectedWeekday[index] ? Colors.Text.point : Colors.Text.tertiary)
                        .frame(width: 40, height: 40)
                        .background(Colors.Background.secondary)
                        .cornerRadius(8)
                        .if(selectedWeekday[index]) { view in
                            view.background {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Colors.Brand.primary, lineWidth: 1)
                            }
                        }
                }
            }
        }
    }
}
