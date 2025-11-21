//
//  DailyDatePicker.swift
//  Daily
//
//  Created by seungyooooong on 10/28/24.
//

import SwiftUI

struct DailyDatePicker: View {
    @Binding var selectedDate: Date
    @State var currentDate: Date
    
    let calendar = Calendar.current
    
    init(date: Binding<Date>) {
        self._selectedDate = date
        self._currentDate = State(initialValue: date.wrappedValue)
    }
    
    var body: some View {
        DailyDatePickerHeader(currentDate: $currentDate)
        
        Spacer().frame(height: 20)
        
        VStack(spacing: 8) {
            WeekIndicator(mode: .none)
            
            let startOfMonth = calendar.date(from: DateComponents(year: currentDate.year, month: currentDate.month, day: 1))!
            let lengthOfMonth = calendar.range(of: .day, in: .month, for: startOfMonth)?.count ?? 0
            let rowCount = Int((lengthOfMonth + startOfMonth.weekday - 1 - 1) / 7)
            
            ForEach(0 ... rowCount, id: \.self) { row in
                HStack {
                    ForEach(0 ..< 7) { col in
                        if col > 0 { Spacer() }
                        
                        let day = row * 7 + col - (startOfMonth.weekday - 1) + 1
                        let date = calendar.date(from: DateComponents(year: currentDate.year, month: currentDate.month, day: day))!
                        
                        if 0 < day && day <= lengthOfMonth {
                            let isSelected = date == selectedDate
                            let isHoliday = UserDefaultManager.holidays?[date.year]?[date.getSelection()] != nil || date.weekday == 1
                            Text("\(day)")
                                .font(isSelected ? Fonts.bodyMdSemiBold : Fonts.bodySmRegular)
                                .foregroundStyle(
                                    isSelected ? Colors.Text.inverse :
                                        isHoliday ? Colors.Brand.holiday :
                                        Colors.Text.secondary
                                )
                                .frame(width: 33, height: 33)
                                .if(isSelected) { view in
                                    view.background {
                                        RoundedRectangle(cornerRadius: 33)
                                            .fill(Colors.Icon.interactivePressed)
                                    }
                                }
                                .onTapGesture {
                                    selectedDate = date
                                }
                        } else {
                            Text("-")
                                .frame(width: 33, height: 33)
                                .opacity(0)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 2)
    }
}
