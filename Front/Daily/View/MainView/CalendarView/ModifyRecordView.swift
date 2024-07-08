//
//  ModifyRecordView.swift
//  Daily
//
//  Created by 최승용 on 7/7/24.
//

import SwiftUI

struct ModifyRecordView: View {
    @EnvironmentObject var alertViewModel: AlertViewModel
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userInfoViewModel: UserInfoViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    @Binding var record: RecordModel
    @State var recordCount: Int = 0
    
    var body: some View {
        VStack {
            RecordOnList(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, record: $record, isBeforeRecord: true)
            CustomDivider(color: .primary, height: 1, hPadding: CGFloat.fontSize)
            Spacer()
            ZStack {
                Circle()
                    .stroke(.primary, lineWidth: 1)
                    .padding(CGFloat.fontSize * 15)
                HStack {
                    Button {
                        if recordCount > 0 {
                            recordCount -= 1
                        } else {
                            withAnimation {
                                alertViewModel.showToast(message: "최소 기록 횟수는 0번이에요 😓")
                            }
                        }
                    } label: {
                        Text("-")
                            .font(.system(size: CGFloat.fontSize * 5, weight: .bold))
                            .frame(width: CGFloat.fontSize * 10)
                            .padding()
                            .background {
                                Circle()
                                    .fill(Color("BackgroundColor"))
                                    .opacity(0.8)
                            }
                    }
                    Menu {
                        ForEach(0 ... record.goal_count, id:\.self) { record_count in
                            Button {
                                self.recordCount = record_count
                            } label: {
                                Text("\(String(record_count))번")
                            }
                        }
                    } label: {
                        Text("\(recordCount)")
                            .font(.system(size: CGFloat.fontSize * 10, weight: .bold))
                            .frame(width: CGFloat.fontSize * 10)
                            .padding()
                            .foregroundColor(.primary)
                    }
                    Button {
                        if recordCount < record.goal_count {
                            recordCount += 1
                        } else {
                            withAnimation {
                                alertViewModel.showToast(message: "최대 기록 횟수는 \(record.goal_count)번이에요 🙌")
                            }
                        }
                    } label: {
                        Text("+")
                            .font(.system(size: CGFloat.fontSize * 5, weight: .bold))
                            .frame(width: CGFloat.fontSize * 10)
                            .padding()
                            .background {
                                Circle()
                                    .fill(Color("BackgroundColor"))
                                    .opacity(0.8)
                            }
                    }
                }
            }
            
            HStack {
                Spacer()
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("취소")
                }
                Button {
                    let modifyRecordCountModel = modifyRecordCountModel(uid: self.record.uid, record_count: recordCount)
                    modifyRecordCount(modifyRecordCountModel: modifyRecordCountModel) { data in
                        if data.code == "00" {
                            DispatchQueue.main.async {
                                calendarViewModel.changeCalendar(amount: 0, userInfoViewModel: userInfoViewModel) { code in
                                    if code == "99" { alertViewModel.showAlert() }
                                }
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        } else {
                            alertViewModel.showAlert()
                        }
                    }
                } label: {
                    Text("수정")
                }
            }
            .padding(.horizontal)
            .buttonStyle(.borderedProminent)
            Spacer()
        }
        .onAppear {
            recordCount = record.record_count
        }
    }
}
