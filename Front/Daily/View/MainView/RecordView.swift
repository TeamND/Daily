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
    @Namespace var ns
    @ObservedObject var userInfoViewModel: UserInfoViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    @StateObject var goalViewModel: GoalViewModel = GoalViewModel()
    
    
    @State var goalModel: GoalModel = GoalModel()
    @State var start_date: Date = Date()
    @State var end_date: Date = Date()
    @State var beforeDate: Date = Date()
    @State var is_set_time: Bool = false
    @State var set_time = Date()
    @State var isShowAlert: Bool = false
    @State var isShowContentLengthAlert: Bool = false
    @State var isShowCountRangeAlert: Bool = false
    let cycle_types: [String] = ["날짜 선택", "요일 반복"]
    @State var typeIndex: Int = 0
    @State var selectedWOD: [Int] = []
    @State var isSelectedWOD: [Bool] = Array(repeating: false, count: 7)
    
    var body: some View {
        VStack {
//            TypePickerGroup(type: $goalModel.type, count: $goalModel.goal_count, time: $goalModel.goal_time)
            Spacer()
            RecordSection(title: "날짜", isNew: true) {
                VStack {
                    HStack {
                        CycleTypePickerGroup(goalViewModel: goalViewModel)
                        Spacer()
                        if goalViewModel.typeIndex == 0 {
                            DatePickerGroup(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, currentDate: $start_date)
                                .matchedGeometryEffect(id: "start_date", in: ns)
                                .matchedGeometryEffect(id: "end_date", in: ns)
                        } else if goalViewModel.typeIndex == 1 {
                            Spacer()
                            Spacer()
                            WODPickerGroup(userInfoViewModel: userInfoViewModel, selectedWOD: selectedWOD, isSelectedWOD: isSelectedWOD)
                        }
                    }
                    if goalViewModel.typeIndex == 1 {
                        VStack {
                            HStack {
                                DatePickerGroup(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, currentDate: $start_date)
                                    .matchedGeometryEffect(id: "start_date", in: ns)
                                Spacer()
                                Text(" ~ ")
                                Spacer()
                                DatePickerGroup(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, currentDate: $end_date)
                                    .matchedGeometryEffect(id: "end_date", in: ns)
                            }
                        }
                    }
                }
            }
            RecordSection(title: "시간") {
                HStack {
                    Text("하루 종일")
                        .opacity(goalViewModel.is_set_time ? 0.5 : 1)
                    Spacer()
                    Toggle("", isOn: $goalViewModel.is_set_time)
                        .labelsHidden()
                        .toggleStyle(SwitchToggleStyle(tint: Color("CustomColor")))
                        .scaleEffect(CGSize(width: 0.9, height: 0.9))
                    Spacer()
                    DatePicker("", selection: $goalViewModel.set_time, displayedComponents: [.hourAndMinute])
                        .datePickerStyle(.compact)
                        .disabled(!goalViewModel.is_set_time)
                        .labelsHidden()
                        .opacity(goalViewModel.is_set_time ? 1 : 0.5)
                        .scaleEffect(CGSize(width: 0.9, height: 0.9))
                        .frame(height: CGFloat.fontSize * 4)
                }
            }
            .font(.system(size: CGFloat.fontSize * 2.5))
            
            RecordSection(title: "목표", isEssential: true, essentialConditions: $goalViewModel.goalModel.content.wrappedValue.count >= 2) {
                ContentTextField(content: $goalViewModel.goalModel.content, type: $goalViewModel.goalModel.type)
            }
            
            HStack {
                // check & count = "횟수", timer = "시간"
                RecordSection(title: $goalViewModel.goalModel.type.wrappedValue == "timer" ? "시간" : "횟수") {
                    GoalCountPickerGroup(type: $goalViewModel.goalModel.type, count: $goalViewModel.goalModel.goal_count, time: $goalViewModel.goalModel.goal_time, isShowAlert: $goalViewModel.isShowAlert, isShowCountRangeAlert: $goalViewModel.isShowCountRangeAlert)
                }
                RecordSection(title: "심볼") {
                    SymbolPickerGroup(symbol: $goalViewModel.goalModel.symbol)
                }
            }
            
            HStack {
                Spacer()
                Button {
                    withAnimation {
//                        typeIndex = 0
                        goalViewModel.resetAll()
                        
                        
//                        goalViewModel.goalModel.symbol = "체크"
                        goalViewModel.goalModel.content = ""
                        goalViewModel.goalModel.type = "check"
                        goalViewModel.goalModel.goal_count = 1
                        goalViewModel.is_set_time = false
                        goalViewModel.set_time = "00:00".toDateOfSetTime()
//                        goalViewModel.selectedWOD = []
                        goalViewModel.isSelectedWOD = Array(repeating: false, count: 7)
                        goalViewModel.start_date = goalViewModel.beforeDate
                        goalViewModel.end_date = goalViewModel.beforeDate
                        calendarViewModel.setCurrentYear(year: goalViewModel.start_date.year)
                        calendarViewModel.setCurrentMonth(month: goalViewModel.start_date.month)
                        calendarViewModel.setCurrentDay(day: goalViewModel.start_date.day)
                    }
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
        .background(Color("ThemeColor"))
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
            start_date = calendarViewModel.getCurrentDate()
            end_date = calendarViewModel.getCurrentDate()
            beforeDate = start_date
            set_time = "00:00".toDateOfSetTime()
        }
        .onTapGesture {
            hideKeyboard()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    RecordView(userInfoViewModel: UserInfoViewModel(), calendarViewModel: CalendarViewModel())
}
