//
//  RecordView.swift
//  Daily
//
//  Created by 최승용 on 3/9/24.
//

import SwiftUI

struct RecordView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userInfoViewModel: UserInfoViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    @State var goalModel: GoalModel = GoalModel()
    @State var date: Date = Date()
    @State var beforeDate: Date = Date()
    @State var isAllDay: Bool = true
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
                SymbolPickerGroup(symbol: $goalModel.symbol)
            }
            .frame(height: 40)
            
            HStack {
                DatePicker("", selection: $set_time, displayedComponents: [.hourAndMinute])
                    .datePickerStyle(.compact)
                    .disabled(isAllDay)
                    .labelsHidden()
                    .opacity(isAllDay ? 0.5 : 1)
                Spacer()
                Toggle("", isOn: $isAllDay)
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: Color("CustomColor")))
                Spacer()
                Text("하루 종일")
                    .foregroundStyle(Color("OppositeColor").opacity(isAllDay ? 1 : 0.5))
            }
            
            ContentTextField(content: $goalModel.content, type: $goalModel.type)
            
            HStack {
                GoalCountPickerGroup(type: $goalModel.type, count: $goalModel.goal_count, time: $goalModel.goal_time, isShowAlert: $isShowAlert, isShowCountRangeAlert: $isShowCountRangeAlert)
                Spacer()
                Button {
                    goalModel.symbol = "체크"
                    goalModel.content = ""
                    goalModel.type = "check"
                    goalModel.goal_count = 1
                    isAllDay = true
                    initSetTime()
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
                        addGoal(goal: goalModel) { data in
                            if data.code == "00" {
                                goalModel.symbol = "체크"
                                goalModel.content = ""
                                goalModel.type = "check"
                                goalModel.goal_count = 1
                                DispatchQueue.main.async {
                                    calendarViewModel.changeCalendar(amount: 0, userInfoViewModel: userInfoViewModel)
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
            initSetTime()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    func initSetTime() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let timeStr = "00:00"
        set_time = dateFormatter.date(from: timeStr)!
    }
}


#Preview {
    RecordView(userInfoViewModel: UserInfoViewModel(), calendarViewModel: CalendarViewModel())
}
