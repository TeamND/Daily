//
//  CalendarSheet.swift
//  Daily
//
//  Created by 최승용 on 3/27/24.
//

import SwiftUI

struct CalendarSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userInfo: UserInfo
    @Binding var date: Date
    
    var body: some View {
        VStack {
            DatePicker("", selection: $date, displayedComponents: [.date])
                .datePickerStyle(.graphical)
            HStack {
                Text("\(String(date.year))년 \(date.month)월 \(date.day)일")
                Spacer()
                Button {
                    userInfo.currentYear = date.year
                    userInfo.currentMonth = date.month
                    userInfo.currentDay = date.day
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Confirm")
                }
            }
            .padding(.horizontal)
            .buttonStyle(.borderedProminent)
        }
        .accentColor(Color("CustomColor"))
    }
}

#Preview {
    CalendarSheet(userInfo: UserInfo(), date: .constant(Date()))
}
