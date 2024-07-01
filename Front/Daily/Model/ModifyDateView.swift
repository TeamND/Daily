//
//  ModifyDateView.swift
//  Daily
//
//  Created by 최승용 on 4/8/24.
//

import SwiftUI

struct ModifyDateView: View {
    @EnvironmentObject var alertViewModel: AlertViewModel
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userInfoViewModel: UserInfoViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    @Binding var record: RecordModel
    @State var date: Date = Date()
    @State var beforeDate: Date = Date()
    @State var beforeDOW: String = ""
    
    var body: some View {
        VStack {
            Label {
                Text("\(String(beforeDate.year)). \(beforeDate.month). \(beforeDate.day). \(beforeDOW)")
                    .font(.system(size: CGFloat.fontSize * 2.5))
            } icon: {
                Image(systemName: "calendar")
            }
            .hLeading()
            .padding(.horizontal)
            RecordOnList(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, record: $record, isBeforeRecord: true)
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
                    let modifyRecordModel = modifyRecordModel(uid: self.record.uid, date: date.yyyyMMdd())
                    modifyRecord(modifyRecordModel: modifyRecordModel) { data in
                        if data.code == "00" {
                            DispatchQueue.main.async {
                                calendarViewModel.changeCalendar(amount: 0, userInfoViewModel: userInfoViewModel, targetDate: date) { code in
                                    if code == "99" { alertViewModel.showAlert() }
                                }
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        } else {
                            alertViewModel.showAlert()
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
            date = calendarViewModel.getCurrentDate()
            beforeDate = date
            beforeDOW = calendarViewModel.getCurrentDOW(userInfoViewModel: userInfoViewModel)
        }
    }
}
