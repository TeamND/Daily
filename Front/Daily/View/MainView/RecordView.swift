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
            RecordSection(title: "날짜") {
                VStack {
                    HStack {
                        Menu {
                            ForEach(0 ..< cycle_types.count, id: \.self) { index in
                                Button {
                                    withAnimation {
                                        typeIndex = index
                                    }
                                } label: {
                                    Text(cycle_types[index])
                                }
                            }
                        } label: {
                            Text(cycle_types[typeIndex])
                                .font(.system(size: CGFloat.fontSize * 2.5))
                        }
                        Spacer()
                        if typeIndex == 0 {
                            DatePickerGroup(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, date: $start_date)
                                .matchedGeometryEffect(id: "start_date", in: ns)
                                .matchedGeometryEffect(id: "end_date", in: ns)
                        } else if typeIndex == 1 {
                            Spacer()
                            Spacer()
                            WODPickerGroup(userInfoViewModel: userInfoViewModel, selectedWOD: selectedWOD, isSelectedWOD: isSelectedWOD)
                        }
                    }
                    if typeIndex == 1 {
                        VStack {
                            HStack {
                                DatePickerGroup(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, date: $start_date)
                                    .matchedGeometryEffect(id: "start_date", in: ns)
                                Spacer()
                                Text(" ~ ")
                                Spacer()
                                DatePickerGroup(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, date: $end_date)
                                    .matchedGeometryEffect(id: "end_date", in: ns)
                            }
                        }
                    }
                }
            }
            RecordSection(title: "시간") {
                HStack {
                    Text("하루 종일")
                        .opacity(is_set_time ? 0.5 : 1)
                    Spacer()
                    Toggle("", isOn: $is_set_time)
                        .labelsHidden()
                        .toggleStyle(SwitchToggleStyle(tint: Color("CustomColor")))
                        .scaleEffect(CGSize(width: 0.9, height: 0.9))
                    Spacer()
                    DatePicker("", selection: $set_time, displayedComponents: [.hourAndMinute])
                        .datePickerStyle(.compact)
                        .disabled(!is_set_time)
                        .labelsHidden()
                        .opacity(is_set_time ? 1 : 0.5)
                        .scaleEffect(CGSize(width: 0.9, height: 0.9))
                        .frame(height: CGFloat.fontSize * 4)
                }
            }
            .font(.system(size: CGFloat.fontSize * 2.5))
            
            RecordSection(title: "목표", isEssential: true, essentialConditions: $goalModel.content.wrappedValue.count >= 2) {
                ContentTextField(content: $goalModel.content, type: $goalModel.type)
            }
            
            HStack {
                GoalCountPickerGroup(type: $goalModel.type, count: $goalModel.goal_count, time: $goalModel.goal_time, isShowAlert: $isShowAlert, isShowCountRangeAlert: $isShowCountRangeAlert)
                Spacer()
                SymbolPickerGroup(symbol: $goalModel.symbol)
            }
            .padding()
            .frame(height: 50)
            
            HStack {
                Spacer()
                Button {
                    withAnimation {
                        goalModel.symbol = "체크"
                        goalModel.content = ""
                        goalModel.type = "check"
                        goalModel.goal_count = 1
                        is_set_time = false
                        set_time = "00:00".toDateOfSetTime()
                        typeIndex = 0
                        selectedWOD = []
                        isSelectedWOD = Array(repeating: false, count: 7)
                        start_date = beforeDate
                        end_date = beforeDate
                        calendarViewModel.setCurrentYear(year: start_date.year)
                        calendarViewModel.setCurrentMonth(month: start_date.month)
                        calendarViewModel.setCurrentDay(day: start_date.day)
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
