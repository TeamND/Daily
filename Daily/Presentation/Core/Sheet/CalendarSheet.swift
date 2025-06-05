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
            calendarSheet
            ScrollView(.vertical, showsIndicators: false) {
                calendarSheet
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
        VStack {
            let today = "2025-05-30".toDate(format: .daily)!
            let calendar = Calendar.current
            let startOfMonth = calendar.date(from: DateComponents(year: today.year, month: today.month, day: 1))!
            let lengthOfMonth = calendar.range(of: .day, in: .month, for: startOfMonth)?.count ?? 0
            let dividerCount = (lengthOfMonth + startOfMonth.weekday - 1 - 1) / 7
            
            ForEach(0 ..< 6) { row in
                DailySpacer()
                HStack {
                    ForEach(0 ..< 7) { col in
                        if col > 0 { Spacer() }
                        
                        let day = row * 7 + col - (startOfMonth.weekday - 1) + 1
                        let date = calendar.date(from: DateComponents(year: today.year, month: today.month, day: day))!
                        if 0 < day && day <= lengthOfMonth {
                            Text("\(day)")
                                .frame(width: 33, height: 33)
                                .if(selectedDates.contains(date)) { view in
                                    view.background {
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(Colors.Brand.primary)
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
                
                if row < 5 {
                    DailySpacer()
                    DailyDivider(color: Colors.Border.secondary, height: 1).opacity(row < dividerCount ? 1 : 0)
                }
            }
            
            HStack {
                ForEach(selectedDates, id: \.self) { date in
                    Text("\(date.day)")
                }
            }
        }
        .padding(.horizontal, 16)
    }
}
