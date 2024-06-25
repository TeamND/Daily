//
//  ModifyGoalView.swift
//  Daily
//
//  Created by 최승용 on 4/8/24.
//

import SwiftUI

struct ModifyGoalView: View {
    @EnvironmentObject var alertViewModel: AlertViewModel
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userInfoViewModel: UserInfoViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    @Binding var record: RecordModel
    @State var modifyGoalModel: modifyGoalModel
    @State var set_time: Date = Date()
    @State var isShowAlert: Bool = false
    @State var isShowContentLengthAlert: Bool = false
    @State var isShowCountRangeAlert: Bool = false
    
    var body: some View {
        VStack {
            if record.is_set_time {
                TimeLine(record: $record)
            }
            RecordOnList(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, record: $record, isBeforeRecord: true)
            CustomDivider(color: .primary, height: 1, hPadding: CGFloat.fontSize)
            Spacer()
            VStack {
                HStack {
                    Spacer()
                    Toggle("", isOn: $modifyGoalModel.is_set_time)
                        .labelsHidden()
                        .toggleStyle(SwitchToggleStyle(tint: Color("CustomColor")))
                    DatePicker("", selection: $set_time, displayedComponents: [.hourAndMinute])
                        .datePickerStyle(.compact)
                        .disabled(!modifyGoalModel.is_set_time)
                        .labelsHidden()
                        .opacity(modifyGoalModel.is_set_time ? 1 : 0.5)
                }
                
                ContentTextField(content: $modifyGoalModel.content, type: $record.type)
                
                HStack {
                    GoalCountPickerGroup(type: $modifyGoalModel.type, count: $modifyGoalModel.goal_count, time: $modifyGoalModel.goal_time, isShowAlert: $isShowAlert, isShowCountRangeAlert: $isShowCountRangeAlert)
                    Spacer()
                    SymbolPickerGroup(symbol: $modifyGoalModel.symbol)
                }
                .padding()
                .frame(height: 40)
                
                HStack {
                    Spacer()
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("취소")
                    }
                    Button {
                        if modifyGoalModel.content.count < 2 {
                            isShowAlert = true
                            isShowContentLengthAlert = true
                        } else {
                            DispatchQueue.main.async {
                                modifyGoalModel.set_time = set_time.toStringOfSetTime()
                                modifyGoal(modifyGoalModel: modifyGoalModel) { data in
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
                            }
                        }
                    } label: {
                        Text("수정")
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .alert(isPresented: $isShowAlert, content: {
                if self.isShowContentLengthAlert {
                    Alert(
                        title: Text(contentLengthAlertTitleText),
                        message: Text(contentLengthAlertMessageText),
                        dismissButton: .default(
                            Text("확인"), action: {
                                self.isShowContentLengthAlert = false
                            }
                        )
                    )
                } else {
                    Alert(
                        title: Text(countRangeAlertTitleText),
                        message: Text(countRangeAlertMessageText),
                        dismissButton: .default(
                            Text("확인"), action: {
                                self.isShowCountRangeAlert = false
                            }
                        )
                    )
                }
            })
            Spacer()
        }
        .onAppear {
            set_time = modifyGoalModel.set_time.toDateOfSetTime()
        }
    }
}
