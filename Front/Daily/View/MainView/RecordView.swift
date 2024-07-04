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
                            DatePickerGroup(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, currentDate: $goalViewModel.start_date)
                                .matchedGeometryEffect(id: "start_date", in: ns)
                                .matchedGeometryEffect(id: "end_date", in: ns)
                        } else if goalViewModel.typeIndex == 1 {
                            Spacer()
                            Spacer()
                            WODPickerGroup(userInfoViewModel: userInfoViewModel, goalViewModel: goalViewModel)
                        }
                    }
                    if goalViewModel.typeIndex == 1 {
                        VStack {
                            HStack {
                                DatePickerGroup(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, currentDate: $goalViewModel.start_date)
                                    .matchedGeometryEffect(id: "start_date", in: ns)
                                Spacer()
                                Text(" ~ ")
                                Spacer()
                                DatePickerGroup(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel, currentDate: $goalViewModel.end_date)
                                    .matchedGeometryEffect(id: "end_date", in: ns)
                            }
                        }
                    }
                }
            }
            RecordSection(title: "시간") {
                HStack {
                    Text("하루 종일")
                        .opacity(goalViewModel.goalModel.is_set_time ? 0.5 : 1)
                    Spacer()
                    Toggle("", isOn: $goalViewModel.goalModel.is_set_time)
                        .labelsHidden()
                        .toggleStyle(SwitchToggleStyle(tint: Color("CustomColor")))
                        .scaleEffect(CGSize(width: 0.9, height: 0.9))
                    Spacer()
                    DatePicker("", selection: $goalViewModel.set_time, displayedComponents: [.hourAndMinute])
                        .datePickerStyle(.compact)
                        .disabled(!goalViewModel.goalModel.is_set_time)
                        .labelsHidden()
                        .opacity(goalViewModel.goalModel.is_set_time ? 1 : 0.5)
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
                        goalViewModel.resetAll(calendarViewModel: calendarViewModel)
                    }
                } label: {
                    Text("초기화")
                }
                Button {
                    goalViewModel.validateGoal(userInfoViewModel: userInfoViewModel, calendarViewModel: calendarViewModel) { goal in
                        addGoal(goal: goal) { data in
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
        .alert(isPresented: $goalViewModel.isShowAlert, content: {
            if goalViewModel.isShowContentLengthAlert {
                Alert(
                    title: Text(contentLengthAlertTitleText),
                    message: Text(contentLengthAlertMessageText),
                    dismissButton: .default(
                        Text("확인"), action: {
                            goalViewModel.isShowContentLengthAlert = false
                        }
                    )
                )
            } else if goalViewModel.isShowCountRangeAlert {
                Alert(
                    title: Text(countRangeAlertTitleText),
                    message: Text(countRangeAlertMessageText),
                    dismissButton: .default(
                        Text("확인"), action: {
                            goalViewModel.isShowCountRangeAlert = false
                        }
                    )
                )
            } else {
                Alert(
                    title: Text(wrongDateAlertTitleText(
                        type: goalViewModel.start_date > goalViewModel.end_date ? "wrongDateRange"
                        : goalViewModel.validateDateRange() ? "overDateRange"
                        : goalViewModel.selectedWOD.count == 0 ? "emptySelectedWOD"
                        : "logicalError")
                    ),
                    message: Text(wrongDateAlertMessageText(
                        type: goalViewModel.start_date > goalViewModel.end_date ? "wrongDateRange"
                        : goalViewModel.validateDateRange() ? "overDateRange"
                        : goalViewModel.selectedWOD.count == 0 ? "emptySelectedWOD"
                        : "logicalError")
                    ),
                    dismissButton: .default(
                        Text("확인"), action: {
                            goalViewModel.isShowWrongDateAlert = false
                        }
                    )
                )
            }
        })
        .onAppear {
            goalViewModel.initDatesAndSetTime(calendarViewModel: calendarViewModel)
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
