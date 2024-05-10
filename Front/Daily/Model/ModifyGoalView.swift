//
//  ModifyGoalView.swift
//  Daily
//
//  Created by 최승용 on 4/8/24.
//

import SwiftUI

struct ModifyGoalView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userInfoViewModel: UserInfoViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    @Binding var record: RecordModel
    @State var modifyGoalModel: modifyGoalModel
    @State var isShowAlert: Bool = false
    @State var isShowContentLengthAlert: Bool = false
    @State var isShowCountRangeAlert: Bool = false
    
    var body: some View {
        VStack {
            RecordOnList(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, record: $record, isBeforeRecord: true)
            CustomDivider(color: .primary, height: 1, hPadding: CGFloat.fontSize)
            Spacer()
            VStack {
                HStack {
                    Spacer()
                    SymbolPickerGroup(symbol: $modifyGoalModel.symbol)
                }
                .frame(height: 40)
                
                ContentTextField(content: $modifyGoalModel.content, type: $record.type)
                
                HStack {
                    GoalCountPickerGroup(type: $modifyGoalModel.type, count: $modifyGoalModel.goal_count, time: $modifyGoalModel.goal_time, isShowAlert: $isShowAlert, isShowCountRangeAlert: $isShowCountRangeAlert)
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
                                modifyGoal(modifyGoalModel: modifyGoalModel) { data in
                                    if data.code == "00" {
                                        DispatchQueue.main.async {
                                            calendarViewModel.changeCalendar(amount: 0, userInfoViewModel: userInfoViewModel)
                                            self.presentationMode.wrappedValue.dismiss()
                                        }
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
    }
}
