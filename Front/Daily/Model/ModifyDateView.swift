//
//  ModifyDateView.swift
//  Daily
//
//  Created by 최승용 on 4/8/24.
//

import SwiftUI

struct ModifyDateView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userInfo: UserInfo
    @Binding var record: RecordModel
    @State var date: Date = Date()
    @State var beforeDate: Date = Date()
    @State var beforeDOW: String = ""
    
    var body: some View {
        VStack {
            Text("\(String(beforeDate.year))년 \(beforeDate.month)월 \(beforeDate.day)일 \(beforeDOW)요일")
                .hLeading()
                .padding(.horizontal)
            BeforeRecord(record: $record)
            CustomDivider(color: .primary, height: 1, hPadding: CGFloat.fontSize)
            Spacer()
            DatePicker("", selection: $date, displayedComponents: [.date])
                .datePickerStyle(.graphical)
            HStack {
                Text("\(String(date.year))년 \(date.month)월 \(date.day)일")
                Spacer()
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("취소")
                }
                Button {
                    let modifyRecordModel = modifyRecordModel(
                        uid: self.record.uid,
                        date: String(format: "%04d", date.year) + String(format: "%02d", date.month) + String(format: "%02d", date.day)
                    )
                    modifyRecord(modifyRecordModel: modifyRecordModel) { data in
                        if data.code == "00" {
                            DispatchQueue.main.async {
                                userInfo.currentYear = date.year
                                userInfo.currentMonth = date.month
                                userInfo.currentDay = date.day
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                } label: {
                    Text("변경")
                }
            }
            .padding(.horizontal)
            .buttonStyle(.borderedProminent)
            Spacer()
        }
        .accentColor(Color("CustomColor"))
        .onAppear {
            date = Calendar.current.date(from: DateComponents(year: userInfo.currentYear, month: userInfo.currentMonth, day: userInfo.currentDay))!
            beforeDate = date
            beforeDOW = userInfo.currentDOW
        }
    }
}
