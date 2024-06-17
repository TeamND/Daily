//
//  RecordView.swift
//  Daily
//
//  Created by 최승용 on 3/9/24.
//

import SwiftUI

struct RecordView: View {
    @EnvironmentObject var alertViewModel: AlertViewModel
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userInfoViewModel: UserInfoViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    @State var goalModel: GoalModel = GoalModel()
    @State var date: Date = Date()
    @State var beforeDate: Date = Date()
    @State var is_set_time: Bool = false
    @State var set_time = Date()
    @State var isShowAlert: Bool = false
    @State var isShowContentLengthAlert: Bool = false
    @State var isShowCountRangeAlert: Bool = false
    
    var body: some View {
        VStack {
//            TypePickerGroup(type: $goalModel.type, count: $goalModel.goal_count, time: $goalModel.goal_time)
            Spacer()
            HStack {
                DatePickerGroup(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, date: $date)
                Spacer()
                Toggle("", isOn: $is_set_time)
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: Color("CustomColor")))
                DatePicker("", selection: $set_time, displayedComponents: [.hourAndMinute])
                    .datePickerStyle(.compact)
                    .disabled(!is_set_time)
                    .labelsHidden()
                    .opacity(is_set_time ? 1 : 0.5)
            }
            
            ContentTextField(content: $goalModel.content, type: $goalModel.type)
            
            HStack {
                GoalCountPickerGroup(type: $goalModel.type, count: $goalModel.goal_count, time: $goalModel.goal_time, isShowAlert: $isShowAlert, isShowCountRangeAlert: $isShowCountRangeAlert)
                Spacer()
                SymbolPickerGroup(symbol: $goalModel.symbol)
            }
            .padding()
            .frame(height: 40)
            
            HStack {
                Spacer()
                Button {
                    goalModel.symbol = "체크"
                    goalModel.content = ""
                    goalModel.type = "check"
                    goalModel.goal_count = 1
                    is_set_time = false
                    set_time = "00:00".toDateOfSetTime()
                    date = beforeDate
                    calendarViewModel.setCurrentYear(year: date.year)
                    calendarViewModel.setCurrentMonth(month: date.month)
                    calendarViewModel.setCurrentDay(day: date.day)
                } label: {
                    Text("초기화")
                }
                Button {
                    if goalModel.content.count < 2 {
                        isShowAlert = true
                        isShowContentLengthAlert = true
                    } else {
                        let currentDate = calendarViewModel.getCurrentYearStr() + calendarViewModel.getCurrentMonthStr() + calendarViewModel.getCurrentDayStr()
                        goalModel.user_uid = userInfoViewModel.userInfo.uid
                        goalModel.start_date = currentDate
                        goalModel.end_date = currentDate
                        goalModel.cycle_date = [currentDate]
                        goalModel.is_set_time = is_set_time
                        goalModel.set_time = set_time.toStringOfSetTime()
                        addGoal(goal: goalModel) { data in
                            if data.code == "00" {
                                DispatchQueue.main.async {
                                    calendarViewModel.changeCalendar(amount: 0, userInfoViewModel: userInfoViewModel) { code in
                                        if code == "99" { alertViewModel.showAlert() }
                                    }
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }
                    }
                } label: {
                    Text("추가")
                }
            }
            .buttonStyle(.borderedProminent)
            Spacer()
            Spacer()
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
        .onAppear {
            date = calendarViewModel.getCurrentDate()
            beforeDate = date
            set_time = "00:00".toDateOfSetTime()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    RecordView(userInfoViewModel: UserInfoViewModel(), calendarViewModel: CalendarViewModel())
}
