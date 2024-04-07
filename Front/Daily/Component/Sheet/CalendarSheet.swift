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
    @State var recordUID: Int = -1
    
    var body: some View {
        VStack {
            DatePicker("", selection: $date, displayedComponents: [.date])
                .datePickerStyle(.graphical)
            HStack {
                Text("\(String(date.year))년 \(date.month)월 \(date.day)일")
                Spacer()
                Button {
                    if self.recordUID >= 0 {
                        let modifyRecordModel = modifyRecordModel(
                            date: String(format: "%04d", date.year) + String(format: "%02d", date.month) + String(format: "%02d", date.day)
                        )
                        modifyRecord(recordUID: String(recordUID), modifyRecordModel: modifyRecordModel) { data in
                            if data.code == "00" {
                                DispatchQueue.main.async {
                                    userInfo.currentYear = date.year
                                    userInfo.currentMonth = date.month
                                    userInfo.currentDay = date.day
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }
                    } else {
                        userInfo.currentYear = date.year
                        userInfo.currentMonth = date.month
                        userInfo.currentDay = date.day
                        self.presentationMode.wrappedValue.dismiss()
                    }
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
