//
//  CalendarSheet.swift
//  Daily
//
//  Created by 최승용 on 3/27/24.
//

import SwiftUI

struct CalendarSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var calendarViewModel: CalendarViewModel
    @Binding var date: Date
    
    var body: some View {
        VStack {
            DatePicker("", selection: $date, displayedComponents: [.date])
                .datePickerStyle(.graphical)
            HStack {
                Text("\(String(date.year))년 \(date.month)월 \(date.day)일")
                Spacer()
                Button {
                    calendarViewModel.setCurrentYear(year: date.year)
                    calendarViewModel.setCurrentMonth(month: date.month)
                    calendarViewModel.setCurrentDay(day: date.day)
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("변경")
                }
            }
            .padding(.horizontal)
            .buttonStyle(.borderedProminent)
        }
        .accentColor(Color("CustomColor"))
    }
}
