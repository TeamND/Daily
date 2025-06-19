//
//  DailyMultiDatePicker.swift
//  Daily
//
//  Created by seungyooooong on 6/18/25.
//

import SwiftUI

struct DailyMultiDatePicker: View {
    @Binding var selectedDates: [Date]
    @State var currentDate: Date
    
    let calendar = Calendar.current
    
    init(dates: Binding<[Date]>) {
        self._selectedDates = dates
        self._currentDate = State(initialValue: dates.wrappedValue.first ?? Date())
    }
    
    var body: some View {
        DailyDatePickerHeader(currentDate: $currentDate)
        
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
                            let isSelected = selectedDates.contains(date)
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
                                    if let index = selectedDates.firstIndex(of: date) {
                                        selectedDates.remove(at: index)
                                    } else {
                                        selectedDates.append(date)
                                    }
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
        
        Spacer().frame(height: 20)
        
        VStack(spacing: 8) {
            Text("선택된 날짜")
                .font(Fonts.bodyMdRegular)
                .foregroundStyle(Colors.Text.tertiary)
                .hLeading()
            ViewThatFits(in: .horizontal) {
                SelectedDatesView(selectedDates: $selectedDates)
                ScrollView(.horizontal) {
                    SelectedDatesView(selectedDates: $selectedDates)
                }
            }
        }
    }
}

struct SelectedDatesView: View {
    @Binding var selectedDates: [Date]
    
    var body: some View {
        HStack(spacing: 6) {
            ForEach(selectedDates, id: \.self) { date in
                HStack(spacing: 4) {
                    Text("\(date.toString(format: .multiDate))")
                        .font(Fonts.bodyMdRegular)
                        .foregroundStyle(Colors.Text.tertiary)
                    
                    Button {
                        selectedDates.removeAll { $0 == date }
                    } label: {
                        Image(.close)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12)
                    }
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 4)
                .background {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Colors.Background.secondary)
                }
            }
        }
        .hLeading()
    }
}
