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
    @State var selectedDate: Date = Date()
    
    var body: some View {
        ViewThatFits(in: .vertical) {
            VStack {
                DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                HStack {
                    Text("\(String(selectedDate.year))년 \(String(format: "%02d", selectedDate.month))월 \(String(format: "%02d", selectedDate.day))일")
                    Spacer()
                    Button {
                        currentDate = selectedDate.defaultDate()
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("변경")
                    }
                }
                .padding(.horizontal)
                .buttonStyle(.borderedProminent)
            }
            ScrollView(.vertical, showsIndicators: false) {
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
        .accentColor(Colors.daily)
        .onAppear {
            selectedDate = currentDate
        }
    }
}
