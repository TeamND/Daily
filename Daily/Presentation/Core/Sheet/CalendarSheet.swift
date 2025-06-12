//
//  CalendarSheet.swift
//  Daily
//
//  Created by 최승용 on 3/27/24.
//

import SwiftUI

struct CalendarSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var currentDate: Date
    @State var selectedDate: Date = Date(format: .daily)
    @State var selectedDates: [Date] = []
    
    var body: some View {
        ViewThatFits(in: .vertical) {
//            calendarSheet
            dailyMultiDatePicker
            ScrollView(.vertical, showsIndicators: false) {
//                calendarSheet
                dailyMultiDatePicker
            }
        }
        .accentColor(Colors.daily)
        .onAppear {
            selectedDate = currentDate
        }
    }
    
    private var calendarSheet: some View {
        VStack {
            DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                .datePickerStyle(.graphical)
            HStack {
                Text("\(String(selectedDate.year))년 \(String(format: "%02d", selectedDate.month))월 \(String(format: "%02d", selectedDate.day))일")
                Spacer()
                Button {
                    currentDate = selectedDate
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("변경")
                }
            }
            .padding(.horizontal)
            .buttonStyle(.borderedProminent)
        }
    }
    
    private var dailyMultiDatePicker: some View {
        VStack(spacing: 8) {
            WeekIndicator(mode: .none).padding(.horizontal, -16)
            let today = "2025-06-30".toDate(format: .daily)!
            let calendar = Calendar.current
            let startOfMonth = calendar.date(from: DateComponents(year: today.year, month: today.month, day: 1))!
            let lengthOfMonth = calendar.range(of: .day, in: .month, for: startOfMonth)?.count ?? 0
            let rowCount = Int((lengthOfMonth + startOfMonth.weekday - 1 - 1) / 7)
            
            ForEach(0 ... rowCount, id: \.self) { row in
                HStack {
                    ForEach(0 ..< 7) { col in
                        if col > 0 { Spacer() }
                        
                        let day = row * 7 + col - (startOfMonth.weekday - 1) + 1
                        let date = calendar.date(from: DateComponents(year: today.year, month: today.month, day: day))!
                        
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
            
            Text("선택된 날짜")
                .font(Fonts.bodyMdRegular)
                .foregroundStyle(Colors.Text.tertiary)
                .hLeading()
            ViewThatFits(in: .horizontal) {
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
                    Spacer()
                }
                ScrollView(.horizontal) {
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
                        Spacer()
                    }
                }
            }
        }
        .padding(.horizontal, 16)
    }
}
