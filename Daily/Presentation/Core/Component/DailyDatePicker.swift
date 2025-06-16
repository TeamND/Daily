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
        HStack {
            Button {
                currentDate = calendar.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
            } label: {
                Image(.circleChevronLeft)   // FIXME: background secondary Image로 변경
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
                Image(.circleChevronRight)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
            }
        }
        
        Spacer().frame(height: 20)
        
        VStack(spacing: 8) {
            WeekIndicator(mode: .none).padding(.horizontal, -16)
            
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
                            Text("\(day)")
                                .font(isSelected ? Fonts.bodyMdSemiBold : Fonts.bodySmRegular)
                                .foregroundStyle(isSelected ? Colors.Text.inverse : Colors.Text.secondary)
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
