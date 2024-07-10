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
    @State var isAll: Bool = true
    @State var set_time: Date = Date()
    @State var isShowAlert: Bool = false
    @State var isShowContentLengthAlert: Bool = false
    
    var body: some View {
        VStack {
            if record.is_set_time {
                TimeLine(record: $record)
            }
            RecordOnList(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, record: $record, isBeforeRecord: true)
            CustomDivider(color: .primary, height: 1, hPadding: CGFloat.fontSize)
            Spacer()
            VStack {
                RecordSection(title: "시간") {
                    HStack {
                        Text("하루 종일")
                            .opacity(modifyGoalModel.is_set_time ? 0.5 : 1)
                        Spacer()
                        Toggle("", isOn: $modifyGoalModel.is_set_time)
                            .labelsHidden()
                            .toggleStyle(SwitchToggleStyle(tint: Color("CustomColor")))
                            .scaleEffect(CGSize(width: 0.9, height: 0.9))
                        Spacer()
                        DatePicker("", selection: $set_time, displayedComponents: [.hourAndMinute])
                            .datePickerStyle(.compact)
                            .disabled(!modifyGoalModel.is_set_time)
                            .labelsHidden()
                            .opacity(modifyGoalModel.is_set_time ? 1 : 0.5)
                            .scaleEffect(CGSize(width: 0.9, height: 0.9))
                            .frame(height: CGFloat.fontSize * 4)
                    }
                }
                .font(.system(size: CGFloat.fontSize * 2.5))
                
                RecordSection(title: "목표", isEssential: true, essentialConditions: $modifyGoalModel.content.wrappedValue.count >= 2) {
                    ContentTextField(content: $modifyGoalModel.content, type: $record.type)
                }
                
                HStack {
                    // check & count = "횟수", timer = "시간"
                    RecordSection(title: $modifyGoalModel.type.wrappedValue == "timer" ? "시간" : "횟수") {
                        GoalCountPickerGroup(type: $modifyGoalModel.type, count: $modifyGoalModel.goal_count, time: $modifyGoalModel.goal_time, isShowAlert: $isShowAlert)
                    }
                    RecordSection(title: "심볼") {
                        SymbolPickerGroup(symbol: $modifyGoalModel.symbol)
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
                        if modifyGoalModel.content.count < 2 {
                            isShowAlert = true
                            isShowContentLengthAlert = true
                        } else {
                            DispatchQueue.main.async {
                                modifyGoalModel.set_time = set_time.toStringOfSetTime()
                                if isAll {
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
                                } else {
                                    withAnimation {
                                        alertViewModel.showToast(message: commingSoonToastMessage)
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
//                if self.isShowContentLengthAlert {
                    Alert(
                        title: Text(contentLengthAlertTitleText),
                        message: Text(contentLengthAlertMessageText),
                        dismissButton: .default(
                            Text("확인"), action: {
                                self.isShowContentLengthAlert = false
                            }
                        )
                    )
//                }
            })
            Spacer()
        }
        .onAppear {
            set_time = modifyGoalModel.set_time.toDateOfSetTime()
        }
    }
}
