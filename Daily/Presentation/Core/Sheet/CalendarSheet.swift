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
}
